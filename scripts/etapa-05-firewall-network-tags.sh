#!/usr/bin/env bash
# =============================================================================
# ETAPA 5 - Firewall y network tags
# =============================================================================
# NO es un script ejecutable. Es un cuaderno de copiar y pegar.
# Los comandos van comentados a proposito. Se ejecutan en PowerShell, quitando
# el # del principio de la linea. Ninguno lee archivos, asi que da igual la
# carpeta desde la que los lances.
#
# El porque de cada cosa esta en docs/apuntes-etapa-05-firewall-network-tags.md
# Coste: 0. Las reglas de firewall no se facturan.
# =============================================================================


# -----------------------------------------------------------------------------
# 1. El punto de partida
# -----------------------------------------------------------------------------
# vpc-lab no tiene ninguna regla. Toda VPC lleva dos IMPLICITAS que no se listan
# ni se borran: ingress DENY y egress ALLOW, las dos con prioridad 65535. O sea:
# no entra nada, sale todo.
#
#   gcloud compute firewall-rules list --filter="network:vpc-lab"    # vacio
#   gcloud compute firewall-rules list --filter="network:default"    # las 4 de fabrica


# -----------------------------------------------------------------------------
# 2. La regla del ejercicio
# -----------------------------------------------------------------------------
# En UNA SOLA LINEA: el \ de continuacion del video es de bash.
#
#   gcloud compute firewall-rules create ssh-custom --network=vpc-lab --action=allow --direction=ingress --rules=tcp:22 --source-ranges=0.0.0.0/0 --target-tags=web-server
#
#   --source-ranges  DE DONDE VIENE el trafico (0.0.0.0/0 = todo internet)
#   --target-tags    A QUE LLEGA: solo las VMs con esa etiqueta
#
# Sin --target-tags la regla se aplicaria a TODAS las VMs de la red.
# Sin --priority nace con 1000. Cuanto mas bajo el numero, mas manda.


# -----------------------------------------------------------------------------
# 3. Poner y quitar la etiqueta a una VM (para la etapa 6)
# -----------------------------------------------------------------------------
# En caliente, sin reiniciar nada:
#
#   gcloud compute instances add-tags servidor-web-1 --tags=web-server --zone=us-east1-b
#   gcloud compute instances remove-tags servidor-web-1 --tags=web-server --zone=us-east1-b


# =============================================================================
# COMPROBACIONES DE LA ETAPA 5
# =============================================================================
# 1. LA del ejercicio:
#
#   gcloud compute firewall-rules describe ssh-custom --format="value(targetTags,allowed,direction)"
#
#   Esperado: web-server   tcp:22   INGRESS
#
# 2. La vista completa, con la prioridad y el tag:
#
#   gcloud compute firewall-rules list --format="table(name,network,direction,priority,allowed[].map().firewall_rule().list(),targetTags.list())"
#
#   Esperado: las 4 de default en 65534, y ssh-custom en vpc-lab con 1000
# =============================================================================


# -----------------------------------------------------------------------------
# LO QUE FALTA PARA LA ETAPA 6
# -----------------------------------------------------------------------------
# ssh-custom abre el 22. La web va por el 80 y no hay regla, asi que el
# navegador se quedaria CARGANDO hasta expirar (un paquete descartado no
# contesta nada). Lanza esto antes de crear la VM:
#
#   gcloud compute firewall-rules create http-custom --network=vpc-lab --action=allow --direction=ingress --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=web-server


# -----------------------------------------------------------------------------
# LIMPIEZA (etapa 20)
# -----------------------------------------------------------------------------
# Lo creo gcloud, lo borra gcloud: no esta en el estado de Terraform.
#
#   gcloud compute firewall-rules delete ssh-custom
#   gcloud compute firewall-rules delete http-custom
