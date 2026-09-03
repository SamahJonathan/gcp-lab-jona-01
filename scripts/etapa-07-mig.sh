#!/usr/bin/env bash
# =============================================================================
# ETAPA 7 - Managed Instance Group (MIG)
# =============================================================================
# NO es un script ejecutable. Es un cuaderno de copiar y pegar: los comandos van
# comentados y se lanzan en PowerShell quitando el # del principio.
#
# Entregable: terraform/mig.tf
# Apuntes:    docs/apuntes-etapa-07-mig.md
#
# ############################################################################
# # AVISO DE COSTE - EL EJERCICIO MAS CARO HASTA AHORA                       #
# # 2 VMs + 2 discos + 2 IPs externas: del orden de 12-14 USD/mes si se      #
# # queda encendido. Y OJO: borrar las instancias a mano NO APAGA NADA, el   #
# # grupo las repone. Se apaga con el paso 6, y solo con el paso 6.          #
# ############################################################################
#
# Los pasos van EN ORDEN.
# =============================================================================


# -----------------------------------------------------------------------------
# 0. De donde venimos
# -----------------------------------------------------------------------------
# La etapa 6 creo UNA maquina a mano, en UNA zona, y la configuraste con un
# startup script. Aqui no se crea ninguna maquina: se crea un GRUPO que las
# fabrica solo, a partir de una plantilla, repartidas entre las tres zonas de
# us-east1 (-b, -c y -d).
#
# Comprueba que no queda nada de la etapa 6 y que estas donde crees:
#
#   gcloud compute instances list        # esperado: vacio
#   gcloud config list                   # esperado: proyecto gcp-lab-jona-01, perfil lab
#
# Y que siguen las dos reglas de firewall de las etapas 5 y 6:
#
#   gcloud compute firewall-rules list --filter="network:vpc-lab" --format="table(name,allowed[].map().firewall_rule().list(),targetTags.list())"
#
#   Esperado: ssh-custom tcp:22 web-server  Y  http-custom tcp:80 web-server
#
# La segunda no es opcional aqui: por el puerto 80 pasan tambien los sondeos de
# salud de Google. Sin ella las maquinas nunca llegarian a HEALTHY y el grupo
# las recrearia en bucle.


# -----------------------------------------------------------------------------
# 1. El ciclo de Terraform
# -----------------------------------------------------------------------------
# Desde la raiz, el flag -chdir hace el trabajo.
#
#   terraform -chdir=terraform fmt
#   terraform -chdir=terraform validate
#   terraform -chdir=terraform plan
#
# El plan tiene que decir EXACTAMENTE:
#
#   Plan: 3 to add, 0 to change, 0 to destroy.
#
# Los tres son la plantilla, el health check y el grupo. Si dice mas, o dice
# algo de 'destroy', PARA y mira que hay de mas: los 16 recursos de las etapas
# 1 a 4 ya estan en el estado y no deben aparecer.
#
#   terraform -chdir=terraform apply
#
# La plantilla y el health check se crean al instante. El grupo tarda: primero
# se crea el, luego levanta las dos maquinas, y luego cada maquina ejecuta su
# startup script e instala nginx. Cuenta 3-4 minutos hasta tenerlo todo verde.


# =============================================================================
# 2. COMPROBACIONES DE LA ETAPA 7
# =============================================================================
# 2.1 LA del ejercicio:
#
#   gcloud compute instance-groups managed list-instances app-mig --region=us-east1
#
#   Esperado: 2 instancias app-XXXX, STATUS RUNNING y HEALTH_STATE HEALTHY.
#
#   PACIENCIA con la columna HEALTH_STATE. Sale vacia o UNKNOWN durante los
#   primeros minutos y eso es NORMAL: el grupo espera los 300 segundos de
#   initial_delay_sec antes de juzgar a una maquina recien nacida, y ademas
#   nginx tarda en instalarse. No toques nada hasta pasados ~5 minutos.
#
# 2.2 Donde han caido, que es el motivo de que el grupo sea regional:
#
#   gcloud compute instances list --format="table(name,zone,status)"
#
#   Esperado: 2 maquinas app-XXXX en zonas DISTINTAS de us-east1.
#
# 2.3 Que las dos salen de la misma plantilla:
#
#   gcloud compute instance-templates list --format="table(name,machineType,creationTimestamp)"
#
# 2.4 Que el nginx se instalo solo tambien aqui. Coge la IP externa de una:
#
#   gcloud compute instances list --filter="name~app-" --format="value(name,networkInterfaces[0].accessConfigs[0].natIP)"
#
#   y contra esa IP:
#
#   (Invoke-WebRequest http://LA_IP -UseBasicParsing).StatusCode
#
#   Esperado: 200. Escribe http:// a mano, o el navegador se ira al 443.
# =============================================================================


# -----------------------------------------------------------------------------
# 3. LA PRUEBA DE VERDAD: auto-healing
# -----------------------------------------------------------------------------
# Esto es el ejercicio, no el apply. Borra UNA instancia a mano:
#
#   gcloud compute instances list --format="value(name,zone)"      # elige una
#   gcloud compute instances delete app-XXXX --zone=us-east1-X
#
# Espera 2 minutos y vuelve a listar:
#
#   gcloud compute instance-groups managed list-instances app-mig --region=us-east1
#
#   Esperado: SIGUEN SIENDO 2. Veras una nueva, con otro nombre, en estado
#   CREATING o RUNNING.
#
# Eso es el grupo cuadrando la realidad con su target_size. Y es exactamente el
# motivo por el que en el paso 6 NO se apaga borrando instancias.
#
# Matiz que conviene tener claro: reponer una maquina BORRADA lo hace el grupo
# solo con contar, sin health check. Lo que anade el health check es detectar la
# maquina que sigue VIVA pero rota. Para verlo, entra en una y para el nginx:
#
#   gcloud compute ssh app-XXXX --zone=us-east1-X --command="sudo systemctl stop nginx"
#
# A los ~30 segundos (3 fallos x 10s) pasa a UNHEALTHY, y el grupo la sustituye.


# -----------------------------------------------------------------------------
# 4. Escalar a mano, para ver que el numero manda
# -----------------------------------------------------------------------------
# Se puede desde gcloud, pero OJO: eso deja el estado de Terraform desfasado, y
# el siguiente apply lo devolveria a 2. Lo limpio es cambiar target_size en
# mig.tf y aplicar.
#
#   gcloud compute instance-groups managed resize app-mig --region=us-east1 --size=3


# -----------------------------------------------------------------------------
# 5. Lo que NO trae este ejercicio
# -----------------------------------------------------------------------------
# El autoescalado por CPU (el segundo superpoder que menciona el video) no esta
# aqui: haria falta un recurso google_compute_region_autoscaler aparte. Con
# target_size fijo el grupo mantiene 2, ni mas ni menos, pase lo que pase con la
# carga. Se deja fuera a proposito: un autoescalador en un laboratorio es una
# forma estupenda de que la factura suba sola.


# =============================================================================
# 6. APAGADO - IMPRESCINDIBLE AL CERRAR LA SESION
# =============================================================================
# BORRAR LAS INSTANCIAS A MANO NO SIRVE. El grupo las repone. Dos formas buenas:
#
# a) Bajar a cero sin destruir nada. Edita target_size = 0 en terraform/mig.tf y:
#
#      terraform -chdir=terraform apply
#
#    El grupo, la plantilla y el health check se quedan (no cuestan nada) y las
#    maquinas desaparecen. Para volver, target_size = 2 y otro apply.
#
# b) Destruir el grupo. En PowerShell el -target VA ENTRECOMILLADO ENTERO, o se
#    come lo que hay detras del punto:
#
#      terraform -chdir=terraform destroy '-target=google_compute_region_instance_group_manager.app_mig'
#
# Y la comprobacion, que es la que vale:
#
#   gcloud compute instances list        # esperado: vacio
#
# Si sale alguna maquina, NO ESTA APAGADO. Espera un minuto y vuelve a mirar: el
# borrado de dos instancias tarda un poco.


# -----------------------------------------------------------------------------
# LIMPIEZA TOTAL (etapa 20)
# -----------------------------------------------------------------------------
#   terraform -chdir=terraform destroy '-target=google_compute_region_instance_group_manager.app_mig'
#   terraform -chdir=terraform destroy '-target=google_compute_health_check.nginx'
#   terraform -chdir=terraform destroy '-target=google_compute_instance_template.app_template'
#
# En ese orden: primero quien usa, luego lo usado.
