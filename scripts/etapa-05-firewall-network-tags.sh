#!/usr/bin/env bash
# =============================================================================
# ETAPA 5 - Firewall y network tags
# =============================================================================
# NO es un script ejecutable. Es un cuaderno de copiar y pegar.
# Los comandos van comentados a proposito. Se ejecutan en PowerShell, desde la
# RAIZ del proyecto, quitando el # del principio de la linea.
#
# Entregable: este archivo. Aqui no hay Terraform: la regla se crea con gcloud,
# igual que en el video.
# Apuntes: docs/apuntes-etapa-05-firewall-network-tags.md
# Coste: 0. Las reglas de firewall no se facturan.
# =============================================================================


# -----------------------------------------------------------------------------
# 0. El punto de partida: la red no deja entrar nada
# -----------------------------------------------------------------------------
# La etapa 4 termino con vpc-lab sin ninguna regla de firewall. Compruebalo:
#
#   gcloud compute firewall-rules list --filter="network:vpc-lab"
#
#   Esperado: vacio.
#
# Y mira las cuatro que SI trae la red de fabrica, para tener el contraste:
#
#   gcloud compute firewall-rules list --filter="network:default"
#
#   Esperado: default-allow-icmp, default-allow-internal, default-allow-rdp,
#             default-allow-ssh
#
# Que vpc-lab no tenga ninguna no es un descuido: toda VPC tiene dos reglas
# IMPLICITAS que no salen en estos listados y que no se pueden borrar:
#
#   ingress -> DENY   prioridad 65535   (todo lo entrante, bloqueado)
#   egress  -> ALLOW  prioridad 65535   (todo lo saliente, permitido)
#
# 65535 es la prioridad mas baja posible: son la ultima palabra, la que se
# aplica cuando ninguna regla tuya ha encajado. Por eso el firewall de GCP se
# escribe EN POSITIVO: no listas lo que prohibes, listas lo poco que permites.


# -----------------------------------------------------------------------------
# 1. La regla del ejercicio
# -----------------------------------------------------------------------------
# En UNA SOLA LINEA. El \ de final de linea del video es de bash y PowerShell no
# lo entiende.
#
#   gcloud compute firewall-rules create ssh-custom --network=vpc-lab --action=allow --direction=ingress --rules=tcp:22 --source-ranges=0.0.0.0/0 --target-tags=web-server
#
# Campo a campo:
#
#   ssh-custom               nombre de la regla, unico en el proyecto
#   --network=vpc-lab        LA REGLA CUELGA DE LA RED, no de la subred. Aplica
#                            a todas las subredes que tenga esa red
#   --action=allow           la alternativa es deny, para tapar un agujero que
#                            otra regla mas ancha haya abierto
#   --direction=ingress      es el valor por defecto; escrito para que se vea
#                            que existe egress
#   --rules=tcp:22           protocolo y puerto. Admite listas (tcp:80,tcp:443),
#                            rangos (tcp:8000-8080) y all
#   --source-ranges=...      DE DONDE VIENE el trafico
#   --target-tags=...        A QUE LLEGA: solo las VMs con esa etiqueta
#
# Los dos ultimos son los que mas se confunden: uno es el origen y otro el
# destino. Una regla ingress necesita los dos.
#
# No se puso --priority, asi que nace con 1000. El rango va de 0 a 65535 y
# CUANTO MAS BAJO, MAS MANDA. Si dos reglas empatan en prioridad, gana el deny.


# -----------------------------------------------------------------------------
# 2. AVISO sobre el 0.0.0.0/0 del puerto 22
# -----------------------------------------------------------------------------
# Eso es abrir el SSH a TODO INTERNET. En el laboratorio da igual, pero en un
# proyecto real es el hallazgo numero uno de cualquier auditoria: hay bots
# barriendo el rango de GCP buscando exactamente esto.
#
# Las dos formas serias de escribirlo:
#
#   --source-ranges=TU.IP.PUBLICA/32    solo desde tu casa
#   --source-ranges=35.235.240.0/20     solo por IAP TCP forwarding
#
# El segundo es el rango fijo desde el que Google abre el tunel de IAP. Con eso
# la VM ni siquiera necesita IP externa, y quien decide si pasas es IAM.
#
# Para ver tu IP publica antes de usar la primera opcion:
#
#   (Invoke-WebRequest ifconfig.me).Content


# -----------------------------------------------------------------------------
# 3. Los network tags, para cuando llegue la VM de la etapa 6
# -----------------------------------------------------------------------------
# Un network tag es una etiqueta de texto pegada a una VM. La regla no apunta a
# maquinas, apunta a la etiqueta: se escribe UNA VEZ y las maquinas entran y
# salen de su alcance solo con ponersela o quitarsela, en caliente y sin
# reiniciar nada.
#
#   gcloud compute instances add-tags servidor-web-1 --tags=web-server --zone=us-east1-b
#   gcloud compute instances remove-tags servidor-web-1 --tags=web-server --zone=us-east1-b
#
# Nombre de una etiqueta: minusculas, numeros y guion, hasta 63 caracteres, un
# maximo de 64 por instancia. Encaja con la convencion del laboratorio.
#
# OJO: una etiqueta es SOLO UN TEXTO, no una credencial. Quien tenga el permiso
# compute.instances.setTags puede ponerle web-server a una VM y colarse dentro
# del alcance de tu regla. La version robusta apunta a la identidad en vez de al
# texto, y no se puede mezclar con --target-tags en la misma regla:
#
#   --target-service-accounts=deployer-sa@PROJECT_ID.iam.gserviceaccount.com


# =============================================================================
# COMPROBACIONES DE LA ETAPA 5
# =============================================================================
# 1. LA comprobacion del ejercicio:
#
#   gcloud compute firewall-rules describe ssh-custom --format="value(targetTags,allowed,direction)"
#
#   Esperado: web-server   tcp:22   INGRESS
#
# 2. La regla ya no esta sola en la red, y se ve su prioridad:
#
#   gcloud compute firewall-rules list --filter="network:vpc-lab" --format="table(name,direction,priority,allowed[].map().firewall_rule().list(),targetTags.list())"
#
#   Esperado: 1 fila -> ssh-custom, INGRESS, 1000, tcp:22, web-server
#
# 3. Todas las reglas del proyecto, para ver que cada una vive en UNA red:
#
#   gcloud compute firewall-rules list --format="table(name,network,direction,priority)"
#
#   Esperado: las 4 de default y ssh-custom en vpc-lab
# =============================================================================


# -----------------------------------------------------------------------------
# LO QUE FALTA PARA LA ETAPA 6
# -----------------------------------------------------------------------------
# ssh-custom abre el 22, el de SSH. Nada mas.
#
# La etapa 6 monta un nginx y quiere verlo desde el navegador, y eso es el
# puerto 80. Con solo ssh-custom, ese Invoke-WebRequest se queda CARGANDO hasta
# que expira: no da "conexion rechazada", porque un paquete descartado por el
# firewall no contesta nada. Es facil pensar que el nginx aun se esta
# instalando.
#
# La segunda regla, que hace falta antes de dar por buena la etapa 6:
#
#   gcloud compute firewall-rules create http-custom --network=vpc-lab --action=allow --direction=ingress --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=web-server
#
# Aqui el 0.0.0.0/0 SI tiene sentido: un servidor web publico esta para que
# entre cualquiera. Era en el 22 donde resultaba discutible.
#
# Esta es la regla que el video nunca crea, y por eso su uptime check del
# ejercicio 18 sale en rojo y lo deja asi.


# -----------------------------------------------------------------------------
# LIMPIEZA (etapa 20)
# -----------------------------------------------------------------------------
# Esto lo creo gcloud, asi que lo borra gcloud. No esta en el estado de
# Terraform y un destroy no lo tocaria.
#
#   gcloud compute firewall-rules delete ssh-custom
#   gcloud compute firewall-rules delete http-custom
#
# No corre prisa: no cuestan nada. Pero una regla que abre el 22 a todo internet
# apuntando a una etiqueta que ya no usa nadie es basura que conviene no dejar.
