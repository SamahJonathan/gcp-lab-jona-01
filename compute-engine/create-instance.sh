#!/usr/bin/env bash
# =============================================================================
# ETAPA 6 - Creacion de servidor-web-1
# =============================================================================
# NO es un script ejecutable. Es el comando de creacion, guardado comentado.
#
# Este archivo es el ENTREGABLE del ejercicio 6 y vive aqui, junto al recurso
# que crea, no en scripts/. La secuencia completa de la etapa -la regla del
# puerto 80, las comprobaciones y el apagado- esta en:
#
#   scripts/etapa-06-vm-startup-script.sh
#
# El porque de cada cosa, en docs/apuntes-etapa-06-vm-startup-script.md
#
# AVISO DE COSTE: un e2-micro encendido ronda los 6 USD/mes, mas ~1 USD del
# disco, que se paga AUNQUE PARES LA MAQUINA. Nada de esto se apaga solo.
# =============================================================================


# -----------------------------------------------------------------------------
# PASO PREVIO OBLIGATORIO: la regla del puerto 80
# -----------------------------------------------------------------------------
# La etapa 5 creo ssh-custom, que abre SOLO el tcp:22. La web va por el 80 y sin
# regla el navegador da ERR_TIMED_OUT: el paquete llega a GCP y se descarta
# contra la implicita de ingress deny, que no contesta nada.
#
# Comprueba si ya existe:
#
#   gcloud compute firewall-rules list --filter="network:vpc-lab" --format="table(name,allowed[].map().firewall_rule().list(),targetTags.list())"
#
#   Esperado: ssh-custom tcp:22 web-server  Y  http-custom tcp:80 web-server
#
# Si falta, creala. Aplica al instante y no hace falta reiniciar la VM:
#
#   gcloud compute firewall-rules create http-custom --network=vpc-lab --action=allow --direction=ingress --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=web-server


# -----------------------------------------------------------------------------
# El comando
# -----------------------------------------------------------------------------
# DESDE LA RAIZ DEL PROYECTO: la ruta del --metadata-from-file es relativa a
# donde estes tu, no a donde esta este archivo.
#
#   cd C:\Users\Joony\OneDrive\Documentos\proyectos_programacion\gcp-lab-jona-01
#
# En UNA SOLA LINEA. El \ de continuacion del video es de bash:
#
#   gcloud compute instances create servidor-web-1 --zone=us-east1-b --machine-type=e2-micro --subnet=subred-us-east1 --tags=web-server --metadata-from-file=startup-script=compute-engine/startup-script.sh
#
#   servidor-web-1          nombre. Minusculas y guion
#   --zone=us-east1-b       una VM es ZONAL, y su zona tiene que estar en la
#                           region de su subred
#   --machine-type=e2-micro 2 vCPU compartidas y 1 GB de RAM
#   --subnet                la subred de la etapa 4. Sin esto la VM se va a la
#                           red default
#   --tags=web-server       la etiqueta de la etapa 5. Sin esto ssh-custom no le
#                           aplica y no puedes ni entrar
#   --metadata-from-file    EL EJERCICIO: el contenido de startup-script.sh se
#                           copia a la metadata bajo la clave startup-script
#
# Los tres ultimos son el hilo del laboratorio: la red de la etapa 4, la
# etiqueta de la 5 y el script de la 6, cosidos en un solo comando.
#
# Dos flags que no estan y conviene conocer:
#
#   --image-family=debian-12 --image-project=debian-cloud
#       sin ellos gcloud elige la imagen por su cuenta, y el valor por defecto
#       puede cambiar sin avisar
#
#   --no-address
#       arranca la VM SIN IP externa. Lo correcto para lo que no deba ser
#       publico. Aqui no se usa porque el ejercicio es abrir la web


# -----------------------------------------------------------------------------
# Borrado
# -----------------------------------------------------------------------------
#   gcloud compute instances delete servidor-web-1 --zone=us-east1-b
