#!/usr/bin/env bash
# =============================================================================
# ETAPA 6 - VM con startup script
# =============================================================================
# NO es un script ejecutable. Es un cuaderno de copiar y pegar: los comandos van
# comentados y se lanzan en PowerShell quitando el # del principio.
#
# -----------------------------------------------------------------------------
# POR QUE HAY ARCHIVOS DE ESTA ETAPA EN DOS CARPETAS
# -----------------------------------------------------------------------------
# Los ENTREGABLES del ejercicio no estan aqui, estan en compute-engine/:
#
#   compute-engine/create-instance.sh   el comando de creacion de la VM
#   compute-engine/startup-script.sh    ESE SI se ejecuta: viaja a la VM
#
# Y estan alli a proposito. En un entorno productivo el codigo que crea un
# recurso vive JUNTO AL RECURSO, no en un cajon generico de scripts: quien
# abre compute-engine/ encuentra alli la maquina, como se crea y con que
# arranca, sin tener que saber que existe otra carpeta. Lo mismo que hace
# terraform/ con network.tf y lo que hara gke/ con sus manifiestos.
#
# Esta carpeta, scripts/, es otra cosa: el cuaderno de estudio del curso, una
# entrada por etapa (etapa-00 a etapa-06) para poder repasar la secuencia
# completa en orden. Por eso aqui estan LOS PASOS -incluida la regla de
# firewall, que no es de Compute Engine- y alli esta EL ENTREGABLE.
#
# Si algun dia esto dejara de ser un laboratorio, scripts/ sobraria y
# compute-engine/ se quedaria.
# -----------------------------------------------------------------------------
#
# El porque de cada cosa esta en docs/apuntes-etapa-06-vm-startup-script.md
#
# ############################################################################
# # AVISO DE COSTE - AQUI EMPIEZA A CORRER EL RELOJ                          #
# # Un e2-micro encendido ronda los 6 USD/mes, mas ~1 USD del disco, que se  #
# # PAGA AUNQUE PARES LA MAQUINA. Nada de esto se apaga solo. No cierres la  #
# # sesion sin pasar por el paso 6.                                          #
# ############################################################################
#
# Los pasos van EN ORDEN. El 1 antes que el 3, o la web no respondera.
# =============================================================================


# -----------------------------------------------------------------------------
# 0. Comprobar donde vas a crear las cosas
# -----------------------------------------------------------------------------
#   gcloud config list
#
#   Esperado: account jona.samah@gmail.com, project gcp-lab-jona-01,
#             region us-east1, zone us-east1-b, configuracion [lab]


# -----------------------------------------------------------------------------
# 1. La regla del puerto 80
# -----------------------------------------------------------------------------
# ssh-custom (etapa 5) abre el 22. La web va por el 80 y sin regla el navegador
# se queda cargando hasta dar ERR_TIMED_OUT. Esto va primero, o perderas el rato
# buscando el fallo dentro de la maquina.
#
#   gcloud compute firewall-rules create http-custom --network=vpc-lab --action=allow --direction=ingress --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=web-server


# -----------------------------------------------------------------------------
# 2. Comprobar que estan LAS DOS reglas
# -----------------------------------------------------------------------------
#   gcloud compute firewall-rules list --filter="network:vpc-lab" --format="table(name,allowed[].map().firewall_rule().list(),targetTags.list())"
#
#   Esperado: ssh-custom   tcp:22   web-server
#             http-custom  tcp:80   web-server


# -----------------------------------------------------------------------------
# 3. Crear la VM
# -----------------------------------------------------------------------------
# DESDE LA RAIZ DEL PROYECTO, no desde terraform/ ni desde scripts/: la ruta del
# --metadata-from-file es relativa a donde estes tu.
#
#   cd C:\Users\Joony\OneDrive\Documentos\proyectos_programacion\gcp-lab-jona-01
#
# Y el comando, en UNA SOLA LINEA:
#
#   gcloud compute instances create servidor-web-1 --zone=us-east1-b --machine-type=e2-micro --subnet=subred-us-east1 --tags=web-server --metadata-from-file=startup-script=compute-engine/startup-script.sh
#
#   --subnet                la subred de la etapa 4. Sin esto la VM va a la
#                           red default
#   --tags                  la etiqueta de la etapa 5. Sin esto no puedes ni
#                           entrar por SSH
#   --metadata-from-file    EL EJERCICIO: el archivo se copia a la metadata
#                           bajo la clave startup-script


# -----------------------------------------------------------------------------
# 4. La IP externa
# -----------------------------------------------------------------------------
#   gcloud compute instances describe servidor-web-1 --zone=us-east1-b --format="value(networkInterfaces[0].accessConfigs[0].natIP)"


# =============================================================================
# 5. COMPROBACIONES DE LA ETAPA 6
# =============================================================================
# 5.1 La maquina esta viva:
#
#   gcloud compute instances list --filter="name:servidor-web-1"
#
#   Esperado: RUNNING, us-east1-b, IP interna 10.10.0.x y una externa
#
# 5.2 LA del ejercicio. Espera un minuto largo antes de lanzarla: la VM dice
#     RUNNING en cuanto arranca el sistema operativo, NO cuando acaba el
#     apt-get.
#
#   (Invoke-WebRequest http://LA_IP).StatusCode
#
#   Esperado: 200, con "Welcome to nginx" en el cuerpo.
#   Si da 200 ya esta probado que nadie entro por SSH a instalar nada, y eso es
#   el ejercicio entero.
#
# 5.3 Por dentro, si quieres verlo:
#
#   gcloud compute ssh servidor-web-1 --zone=us-east1-b
#
#   y dentro de la maquina:
#     sudo journalctl -u google-startup-scripts.service   # el log del script
#     systemctl status nginx
# =============================================================================


# -----------------------------------------------------------------------------
# 6. APAGADO - NO CIERRES LA SESION SIN ESTO
# -----------------------------------------------------------------------------
# La etapa 7 empieza parando esta maquina, asi que si sigues manana: stop.
# Si cierras el laboratorio: delete, que se lleva tambien el disco.
#
#   gcloud compute instances stop servidor-web-1 --zone=us-east1-b
#   gcloud compute instances delete servidor-web-1 --zone=us-east1-b
#
# Y la comprobacion de que no queda nada encendido:
#
#   gcloud compute instances list        # esperado al cerrar: vacio


# -----------------------------------------------------------------------------
# LIMPIEZA DE LA REGLA (etapa 20)
# -----------------------------------------------------------------------------
#   gcloud compute firewall-rules delete http-custom
