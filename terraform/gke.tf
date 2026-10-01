# ETAPA 10 - Cluster de GKE
# Apuntes: docs/apuntes-etapa-10-gke.md
#
# Kubernetes gestionado: Google se ocupa del control plane -el cerebro que decide
# que corre y donde, y que se auto-repara-, y tu solo de los nodos donde corren
# las aplicaciones.
#
# ###########################################################################
# # EL RECURSO MAS CARO DEL CURSO. Un nodo e2-medium ronda los 25 USD/mes y  #
# # se paga este vacio o lleno, 24/7. El control plane son 0,10 USD/h, con   #
# # UN cluster zonal exento por cuenta de facturacion (este seria el unico). #
# #                                                                          #
# # HACER LAS ETAPAS 10 Y 11 SEGUIDAS Y DESTRUIR EL MISMO DIA. En el         #
# # proyecto anterior esto se quedo una semana encendido.                    #
# ###########################################################################


resource "google_container_cluster" "primary" {
  name = "cluster-lab"

  # ZONAL, no regional. Dos motivos:
  #   - precio: un cluster regional replica el control plane en tres zonas y no
  #     entra en la exencion de un cluster zonal por cuenta de facturacion.
  #   - nodos: en un cluster regional, initial_node_count se crea POR ZONA. Con
  #     1 saldrian 3 nodos y 3 facturas.
  # Para produccion se querria regional, justo por lo contrario: sobrevivir a la
  # caida de una zona.
  #
  # Zona APARTE de var.zone (us-east1-b): el 01-10-2026 el primer intento murio
  # ahi por falta de e2-medium en el inventario de Google. El motivo completo, en
  # la variable. Y el efecto colateral que importa: el cluster NO se queda sin
  # crear, se queda en estado ERROR, listado y facturando, asi que hay que
  # destruirlo antes de reintentar.
  location = var.gke_zone

  # ESTA ES LA LINEA QUE FALTO EN EL PROYECTO ANTERIOR.
  # Sin network/subnetwork, GKE se va a la red "default" -la de modo auto que la
  # etapa 4 decidio no usar- y el cluster acaba fuera de tu red, con sus reglas
  # de firewall colgando de otra VPC. No se arregla editando: la red de un
  # cluster es inmutable y cambiarla obliga a recrearlo.
  network    = google_compute_network.vpc_lab.id
  subnetwork = google_compute_subnetwork.subred_us_east1.id

  # Un cluster VPC-native necesita DOS rangos mas, aparte del de los nodos:
  #   nodos     -> 10.10.0.0/24, la subred de la etapa 4
  #   pods      -> este /16
  #   servicios -> este /22
  # Pedirlos por tamano y sin direcciones concretas deja que GKE elija huecos
  # libres y cree los rangos secundarios en la subred. Que los pods tengan IP
  # propia de la VPC es lo que hace que un pod sea enrutable como una VM.
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "/16"
    services_ipv4_cidr_block = "/22"
  }

  # initial_node_count + node_config crea el "default-pool" de una vez, que es
  # lo que hace el video. La forma recomendada en serio es
  # remove_default_node_pool = true y un google_container_node_pool aparte, para
  # poder cambiar el tipo de maquina sin recrear el cluster entero.
  initial_node_count = 1

  node_config {
    # e2-medium (2 vCPU, 4 GB) es el minimo razonable: en un e2-micro no caben
    # los componentes del propio Kubernetes, que reservan CPU y RAM de cada nodo.
    machine_type = "e2-medium"

    # 30 GB pd-standard en vez de los 100 GB pd-balanced por defecto. Es la
    # diferencia entre ~1,20 y ~10 USD al mes de disco.
    disk_size_gb = 30
    disk_type    = "pd-standard"

    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]

    # La etiqueta de la etapa 5, para que las reglas ssh-custom y http-custom
    # tambien alcancen a los nodos.
    tags = ["web-server"]
  }

  # TRUE por defecto en el proveedor, y con TRUE "terraform destroy" FALLA.
  # Es el error que en el video aparece al final del curso ("deletion protection
  # false") cuando intenta limpiar y el cluster se niega a morir. Aqui se pone a
  # false desde el principio: es un laboratorio y se destruye el mismo dia.
  deletion_protection = false

  depends_on = [google_project_service.apis]
}


# -----------------------------------------------------------------------------
# APAGADO - el mismo dia, y EN ESTE ORDEN
# -----------------------------------------------------------------------------
# 1) PRIMERO borrar el Service de tipo LoadBalancer de la etapa 11, desde Cloud
#    Shell:
#
#      kubectl delete service nginx-app
#
#    Ese Service no lo gestiona Terraform: lo creo kubectl, y por debajo creo un
#    balanceador y una IP externa que son recursos de Compute Engine. Si se
#    destruye el cluster con el Service vivo, el balanceador queda HUERFANO
#    facturando sin que nada lo reclame, y hay que ir a buscarlo a mano con
#    gcloud compute forwarding-rules list.
#
# 2) DESPUES el cluster:
#
#      terraform -chdir=terraform destroy '-target=google_container_cluster.primary'
#
# Comprobacion final:
#
#   gcloud container clusters list          # vacio
#   gcloud compute forwarding-rules list    # vacio
#   gcloud compute instances list           # vacio (los nodos son VMs)
