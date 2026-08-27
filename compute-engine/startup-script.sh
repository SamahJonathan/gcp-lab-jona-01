#!/bin/bash
# =============================================================================
# ETAPA 6 - Startup script de servidor-web-1
# =============================================================================
# ESTE SI ES UN SCRIPT DE VERDAD. No es un cuaderno de copiar y pegar: su
# contenido viaja a la metadata de la VM y lo ejecuta el agente de Google al
# arrancar la maquina. Si lo comentas, no hace nada.
#
# Se manda con:
#   --metadata-from-file=startup-script=compute-engine/startup-script.sh
#
# Tres cosas que hay que tener claras antes de tocarlo:
#
#   1. Corre como ROOT. Por eso no hay ningun sudo: no hace falta.
#      Y por eso compute.instances.setMetadata era uno de los permisos
#      peligrosos de la etapa 3: escribir metadata es escribir esto, y esto
#      es root dentro de la maquina.
#
#   2. Corre en CADA ARRANQUE, no solo en el primero (el video se equivoca en
#      esto). Si paras y enciendes la VM, se ejecuta entero otra vez. Por eso
#      tiene que ser IDEMPOTENTE: lanzarlo diez veces debe dejar la maquina
#      igual que lanzarlo una. Nada de >> a un fichero de configuracion.
#
#   3. Corre SIN NADIE DELANTE. No hay terminal donde ver errores ni donde
#      contestar preguntas. Todo tiene que ser no interactivo, y lo que pase
#      se lee despues con:
#        sudo journalctl -u google-startup-scripts.service
#
# El .gitattributes del repo fuerza eol=lf para los .sh. No lo cambies: si este
# archivo acabara con finales de linea de Windows, la VM leeria el shebang como
# "/bin/bash\r" y fallaria con un "bad interpreter" bastante desconcertante.
# =============================================================================

# Si algo falla, para aqui. Sin esto el script seguiria adelante con el nginx
# sin instalar y el log terminaria en "todo bien" mintiendo.
set -e

# apt-get no puede pararse a preguntar nada: no hay quien conteste.
export DEBIAN_FRONTEND=noninteractive

apt-get update

# El -y es obligatorio, por lo mismo. Y es la linea que hace idempotente al
# script: sobre un paquete ya instalado, no hace nada.
apt-get install -y nginx

# En Debian, instalar el paquete ya arranca y habilita el servicio, asi que
# estas dos lineas son redundantes. Se dejan porque hacen explicito lo que
# quieres y porque en otras distribuciones si hacen falta. Tambien son
# idempotentes: sobre un servicio ya arrancado, no hacen nada.
systemctl enable nginx
systemctl start nginx

# La pagina que sirve es la de fabrica de Debian, la del "Welcome to nginx".
# No la tocamos: es justo el texto que busca la comprobacion de la etapa.

# Marca de final, para reconocer en el log que el script llego hasta abajo.
echo "startup-script: nginx instalado y arrancado"
