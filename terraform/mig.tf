# ETAPA 7 - Managed Instance Group
# Apuntes: docs/apuntes-etapa-07-mig.md
#
# La etapa 6 creo UNA maquina a mano. Esta crea un GRUPO que se gestiona solo:
# si una instancia desaparece o deja de responder, el grupo levanta otra sin que
# nadie se lo pida. Es el paso de "mascota" a "ganado".
#
# ###########################################################################
# # COSTE: 2 VMs encendidas + 2 discos + 2 IPs externas. Del orden de 12-14 #
# # USD/mes si se queda arriba. NO SE APAGA SOLO, y borrar las instancias a #
# # mano NO SIRVE: el grupo las repone. Ver el bloque de apagado abajo.     #
# ###########################################################################


# -----------------------------------------------------------------------------
# 1. La plantilla
# -----------------------------------------------------------------------------
# Un instance template es el molde: describe como es UNA maquina, y el grupo lo
# usa para fabricar copias identicas. Es INMUTABLE: no se edita, se sustituye.
resource "google_compute_instance_template" "app_template" {
  # name_prefix en vez de name, y create_before_destroy abajo. Los dos van
  # juntos y son obligatorios en la practica: como la plantilla no se puede
  # editar, cualquier cambio la reemplaza, y Terraform no puede borrar la vieja
  # mientras el grupo la este usando. Con este par crea la nueva primero, con un
  # nombre distinto, y borra la anterior despues.
  name_prefix  = "app-template-"
  machine_type = "e2-micro"

  # La misma etiqueta de la etapa 5. Sin esto las reglas ssh-custom y
  # http-custom no aplican a estas maquinas: ni entrarias por SSH ni pasarian
  # los sondeos de salud, y el grupo las mataria en bucle.
  tags = ["web-server"]

  disk {
    source_image = "debian-cloud/debian-12"
    auto_delete  = true
    boot         = true
    disk_size_gb = 10
    disk_type    = "pd-standard"
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subred_us_east1.id

    # Bloque vacio = IP externa efimera. Hace falta de verdad: sin salida a
    # internet el apt-get del startup script no puede descargar nginx, la
    # maquina nunca pasaria el health check y el grupo la recrearia sin parar.
    # La alternativa seria montar un Cloud NAT, que son mas recursos y mas
    # coste para el laboratorio.
    access_config {}
  }

  # El MISMO script de la etapa 6, sin copiarlo. path.module es terraform/, asi
  # que sube un nivel y entra en compute-engine/. Un solo archivo, un solo sitio
  # donde corregirlo.
  metadata = {
    startup-script = file("${path.module}/../compute-engine/startup-script.sh")
  }

  lifecycle {
    create_before_destroy = true
  }
}


# -----------------------------------------------------------------------------
# 2. El sondeo de salud
# -----------------------------------------------------------------------------
# Esto es lo que separa "reponer una maquina borrada" de AUTO-HEALING de verdad.
# Sin health check el grupo solo sabe contar: si hay menos de 2, crea. Con el,
# ademas pregunta a cada maquina si sigue sirviendo, y sustituye a la que este
# viva pero rota (nginx caido, proceso colgado).
#
# Los sondeos salen de los rangos 130.211.0.0/22 y 35.191.0.0/16, de Google. Aqui
# pasan porque http-custom abre el 80 desde 0.0.0.0/0 al tag web-server. En un
# proyecto serio se abre una regla solo para esos dos rangos.
resource "google_compute_health_check" "nginx" {
  name = "nginx-health-check"

  check_interval_sec  = 10 # cada cuanto pregunta
  timeout_sec         = 5  # cuanto espera la respuesta
  healthy_threshold   = 2  # 2 respuestas buenas seguidas -> sana
  unhealthy_threshold = 3  # 3 fallos seguidos -> enferma

  http_health_check {
    port         = 80
    request_path = "/"
  }
}


# -----------------------------------------------------------------------------
# 3. El grupo
# -----------------------------------------------------------------------------
# REGIONAL, no zonal: reparte las instancias entre las zonas de us-east1
# (us-east1-b, -c y -d). Ahi esta la diferencia con la etapa 6, donde una zona
# caida se llevaba por delante la unica maquina que habia.
resource "google_compute_region_instance_group_manager" "app_mig" {
  name   = "app-mig"
  region = var.region

  # Las instancias se llamaran app-XXXX, con un sufijo aleatorio. No se eligen
  # los nombres: son ganado, no mascotas.
  base_instance_name = "app"

  # EL NUMERO QUE CUESTA DINERO. Bajarlo a 0 apaga el grupo sin destruirlo.
  #
  # A 0 desde que la etapa 7 quedo cerrada (29-09-2026). El grupo, la plantilla y
  # el health check son gratis: lo que se factura son las instancias. Dejarlo en
  # 2 hacia que cualquier "terraform apply" de una etapa posterior levantara dos
  # VMs sin que nadie lo pidiera.
  #
  # Para repetir el ejercicio 7: subirlo a 2, aplicar, y volver a 0 al terminar.
  target_size = 0

  version {
    instance_template = google_compute_instance_template.app_template.id
  }

  auto_healing_policies {
    health_check = google_compute_health_check.nginx.id

    # Cuanto espera antes de empezar a juzgar a una maquina recien nacida.
    # 300 segundos es generoso a proposito: el startup script tiene que hacer
    # apt-get update e instalar nginx, y si el plazo se queda corto el grupo
    # mata las maquinas antes de que terminen de arrancar. Ese bucle es caro y
    # desconcertante.
    initial_delay_sec = 300
  }
}


# -----------------------------------------------------------------------------
# APAGADO (al cerrar la sesion)
# -----------------------------------------------------------------------------
# Borrar las instancias a mano NO sirve: el grupo las repone en un par de
# minutos. Hay dos formas buenas:
#
#   a) Bajar target_size a 0 y aplicar. Conserva el grupo y la plantilla, que
#      no cuestan nada, y apaga lo que se factura.
#
#   b) Destruir. En PowerShell el -target VA ENTRECOMILLADO ENTERO:
#
#      terraform -chdir=terraform destroy '-target=google_compute_region_instance_group_manager.app_mig'
#
# Comprobacion final, la del ejercicio 20:
#
#   gcloud compute instances list        # esperado: vacio
