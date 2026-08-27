#!/usr/bin/env bash
# =============================================================================
# ETAPA 4 - VPC en modo custom
# =============================================================================
# NO es un script ejecutable. Es un cuaderno de copiar y pegar.
# Los comandos van comentados a proposito. Se ejecutan en PowerShell, desde la
# RAIZ del proyecto, quitando el # del principio de la linea.
#
# Entregable: terraform/network.tf
# Coste: 0. Una VPC y una subred no se facturan.
# =============================================================================


# -----------------------------------------------------------------------------
# 0. Ver lo que Google te regalo sin pedirlo
# -----------------------------------------------------------------------------
# Al habilitar la API de Compute en la etapa 1, Google creo una VPC llamada
# 'default' en modo AUTO. Mirala antes de crear la tuya:
#
#   gcloud compute networks list
#
# Y cuenta sus subredes. Son unas 40, una por region del mundo:
#
#   (gcloud compute networks subnets list --filter="network:default" --format="value(name)").Count
#
# Ninguna de esas 40 la pediste, ninguna la vas a usar, y sus rangos los eligio
# Google. Eso es el modo AUTO. En un proyecto de verdad la 'default' se borra.
# Aqui se deja: no cuesta nada y borrarla puede romper ejercicios del video.


# -----------------------------------------------------------------------------
# 1. El ciclo de Terraform
# -----------------------------------------------------------------------------
# Desde la raiz, no desde terraform/. El flag -chdir hace el trabajo.
#
#   terraform -chdir=terraform fmt       # ordena la indentacion
#   terraform -chdir=terraform validate  # sintaxis y referencias
#   terraform -chdir=terraform plan      # que haria, sin tocar nada
#
# El plan tiene que decir exactamente:
#   Plan: 2 to add, 0 to change, 0 to destroy.
#
# Si dice mas de 2, o dice algo de 'destroy', PARA y mira que hay de mas. Las
# 15 APIs de la etapa 1 no deben aparecer: ya estan en el estado.
#
#   terraform -chdir=terraform apply     # lo aplica, pidiendo confirmacion


# =============================================================================
# COMPROBACIONES DE LA ETAPA 4
# =============================================================================
# 1. La red esta en modo CUSTOM, no AUTO. Es LA comprobacion del ejercicio:
#
#   gcloud compute networks describe vpc-lab --format="value(x_gcloud_subnet_mode)"
#
#   Esperado: CUSTOM
#
# 2. Tiene UNA sola subred, la que tu pusiste:
#
#   gcloud compute networks subnets list --filter="network:vpc-lab"
#
#   Esperado: 1 fila -> subred-us-east1, us-east1, 10.10.0.0/24
#
# 3. El contraste con la de fabrica, lado a lado:
#
#   gcloud compute networks list --format="table(name,x_gcloud_subnet_mode,x_gcloud_bgp_routing_mode)"
#
#   Esperado: default AUTO, vpc-lab CUSTOM
# =============================================================================


# -----------------------------------------------------------------------------
# LIMPIEZA (etapa 20)
# -----------------------------------------------------------------------------
# Se destruye con Terraform, no con gcloud: lo que crea Terraform lo borra
# Terraform, o el estado deja de coincidir con la realidad.
#
# En PowerShell el -target VA ENTRECOMILLADO ENTERO, o se come lo que hay
# detras del punto:
#
#   terraform -chdir=terraform destroy '-target=google_compute_subnetwork.subred_us_east1'
#   terraform -chdir=terraform destroy '-target=google_compute_network.vpc_lab'
#
# Orden importante: primero la subred, luego la red. Terraform lo resuelve solo
# si destruyes sin -target, pero con -target vas tu al volante.
