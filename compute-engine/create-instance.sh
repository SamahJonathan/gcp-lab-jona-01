#!/usr/bin/env bash
# =============================================================================
# ETAPA 6 - VM con startup script
# =============================================================================
# NO es un script ejecutable. Es un cuaderno de copiar y pegar.
# Los comandos van comentados a proposito. Se ejecutan en PowerShell, desde la
# RAIZ del proyecto, quitando el # del principio de la linea.
#
# El otro entregable, compute-engine/startup-script.sh, SI es un script de
# verdad: su contenido viaja a la VM y se ejecuta alli.
#
# Apuntes: docs/apuntes-etapa-06-vm-startup-script.md
#
# ############################################################################
# # AVISO DE COSTE. Aqui empieza el modulo 2 y aqui empieza a correr el reloj.#
# # Todo lo anterior -APIs, una identidad, un rol, una red, una regla- es     #
# # gratis. Una VM encendida, no. Lee la seccion del dinero antes de lanzar   #
# # nada, y no cierres la sesion sin pasar por la de apagado.                 #
# ############################################################################
# =============================================================================


# -----------------------------------------------------------------------------
# 0. Antes de empezar: las dos reglas de firewall
# -----------------------------------------------------------------------------
# La etapa 5 creo ssh-custom, que abre tcp:22. La web va por tcp:80 y para el 80
# no hay ninguna regla, asi que manda la implicita de ingress deny: el navegador
# se quedaria cargando hasta expirar.
#
# Comprueba que estan LAS DOS:
#
#   gcloud compute firewall-rules list --filter="network:vpc-lab" --format="table(name,allowed[].map().firewall_rule().list(),targetTags.list())"
#
#   Esperado: ssh-custom tcp:22 web-server
#             http-custom tcp:80 web-server
#
# Si falta http-custom, el comando esta al final de
# scripts/etapa-05-firewall-network-tags.sh.
#
# Y que la subred de la etapa 4 sigue en su sitio:
#
#   gcloud compute networks subnets list --filter="network:vpc-lab"
#
#   Esperado: subred-us-east1, us-east1, 10.10.0.0/24


# -----------------------------------------------------------------------------
# 1. El comando del ejercicio
# -----------------------------------------------------------------------------
# En UNA SOLA LINEA, desde la RAIZ del proyecto: la ruta del
# --metadata-from-file es relativa a donde estes tu, no a donde esta el archivo.
#
#   gcloud compute instances create servidor-web-1 --zone=us-east1-b --machine-type=e2-micro --subnet=subred-us-east1 --tags=web-server --metadata-from-file=startup-script=compute-engine/startup-script.sh
#
# Campo a campo:
#
#   servidor-web-1          nombre. Minusculas y guion, como manda la convencion
#   --zone=us-east1-b       una VM es ZONAL. Tiene que estar en una zona de la
#                           region de su subred
#   --machine-type=e2-micro 2 vCPU compartidas y 1 GB de RAM
#   --subnet=...            LA SUBRED DE LA ETAPA 4. Sin esto la VM se va a la
#                           red default, la de las 42 subredes
#   --tags=web-server       LA ETIQUETA DE LA ETAPA 5. Sin esto, ssh-custom no
#                           le aplica y no puedes ni entrar
#   --metadata-from-file    EL EJERCICIO. El contenido del archivo se copia a la
#                           metadata bajo la clave startup-script
#
# Los tres del medio son el hilo del laboratorio: la red de la 4, la etiqueta de
# la 5 y el script de la 6, cosidos en un solo comando. Quita cualquiera y algo
# se rompe.


# -----------------------------------------------------------------------------
# 2. Dos flags que no estan y conviene conocer
# -----------------------------------------------------------------------------
#   --image-family=debian-12 --image-project=debian-cloud
#
#     Sin ellos gcloud elige una imagen de Debian por su cuenta. Funciona, pero
#     en un script serio la imagen se escribe: si manana cambian el valor por
#     defecto, tu maquina cambia de sistema operativo sin que tu toques nada.
#     Es la misma idea de reproducibilidad que llevo a la red custom.
#
#   --no-address
#
#     Arranca la VM SIN IP externa. Es lo correcto para cualquier cosa que no
#     tenga que ser publica: mas barato y sin superficie expuesta. Aqui no se
#     usa porque el ejercicio consiste justo en abrir la web desde el navegador.


# =============================================================================
# COMPROBACIONES DE LA ETAPA 6
# =============================================================================
# 1. La maquina esta viva:
#
#   gcloud compute instances list --filter="name:servidor-web-1"
#
#   Esperado: RUNNING, zona us-east1-b, una IP interna 10.10.0.x -de la subred
#   de la etapa 4- y una externa.
#
#   Para quedarte solo con la externa:
#
#   gcloud compute instances describe servidor-web-1 --zone=us-east1-b --format="value(networkInterfaces[0].accessConfigs[0].natIP)"
#
# 2. La web responde:
#
#   (Invoke-WebRequest http://IP_EXTERNA).StatusCode
#
#   Esperado: 200, y "Welcome to nginx" en el cuerpo.
#
#   PACIENCIA EL PRIMER MINUTO. La VM aparece como RUNNING ANTES de que el
#   startup script haya terminado: RUNNING significa que el sistema operativo
#   arranco, no que tu script acabara. El apt-get tarda lo suyo.
#
# 3. LA MEDIDA DE VERDAD: el script se ejecuto solo.
#
#   Si la 2 da 200, ya esta probado: nadie entro por SSH a instalar nada. Eso es
#   el ejercicio entero. Para verlo por dentro:
#
#   gcloud compute ssh servidor-web-1 --zone=us-east1-b
#
#   y ya dentro de la maquina:
#
#     sudo journalctl -u google-startup-scripts.service
#     systemctl status nginx
#
#   El primero es el log del agente ejecutando tu script, linea a linea, hasta
#   el "startup-script: nginx instalado y arrancado" del final. Es el sitio
#   donde mirar cuando un startup script no hace lo que esperabas, y como corre
#   sin nadie delante, es el UNICO sitio.
#
#   Y la metadata, desde dentro de la VM, para ver que cualquier proceso la lee
#   sin permisos especiales -y por que ahi no se ponen contrasenas-:
#
#     curl -H "Metadata-Flavor: Google" http://169.254.169.254/computeMetadata/v1/instance/attributes/startup-script
# =============================================================================


# -----------------------------------------------------------------------------
# EL DINERO
# -----------------------------------------------------------------------------
#   vCPU y RAM del e2-micro   se pagan mientras la VM este ENCENDIDA
#   disco de arranque, 10 GB  se paga mientras la VM EXISTA, encendida o parada
#   IP externa efimera        se paga mientras este asignada a una VM encendida
#   trafico de salida         se paga si lo hay
#
# Ordenes de magnitud: el e2-micro en us-east1 ronda los 6 USD al mes encendido
# a todas horas, el disco 1 USD, y la IP unos centimos al dia. El numero que
# vale es el de la consola de Facturacion, no este.
#
# Tres matices que importan mas que las cifras:
#
#   - PARAR NO ES BORRAR. Parada no pagas CPU ni RAM, pero el disco sigue
#     contando. Para no pagar nada hay que borrar la instancia.
#
#   - La IP EFIMERA se libera al parar la VM: no se cobra, y al encenderla otra
#     vez te dan OTRA DISTINTA. El aviso del plan.md sobre "la IPv4 se cobra
#     aunque pares la VM" vale para una IP ESTATICA reservada, que se factura
#     -y mas cara- precisamente cuando no esta enganchada a nada. Esta no lo es.
#
#   - El nivel gratuito existe (us-east1 es una de las tres regiones con un
#     e2-micro siempre gratis al mes) pero NO CUENTES CON EL: la cuenta de
#     facturacion esta compartida con el proyecto del curso, el nivel gratuito
#     va por cuenta y no por proyecto, y el disco que crea este comando no es
#     del tipo que entra.


# -----------------------------------------------------------------------------
# APAGADO AL CERRAR LA SESION
# -----------------------------------------------------------------------------
# La etapa 7 empieza parando esta maquina, asi que si vas seguido: stop.
# Si cierras el laboratorio por hoy: delete. El comando de creacion esta aqui
# guardado y rehacerla cuesta un minuto.
#
#   gcloud compute instances stop servidor-web-1 --zone=us-east1-b
#   gcloud compute instances delete servidor-web-1 --zone=us-east1-b
#
# Y la comprobacion de que no queda nada encendido, la del ejercicio 20:
#
#   gcloud compute instances list
#
#   Esperado, al cerrar: vacio.
