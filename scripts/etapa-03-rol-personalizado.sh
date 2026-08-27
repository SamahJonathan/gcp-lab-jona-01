#!/usr/bin/env bash
# =============================================================================
# ETAPA 3 - Rol personalizado con Python
# =============================================================================
# NO es un script ejecutable. Es un cuaderno de copiar y pegar.
# Los comandos van comentados a proposito. Se ejecutan en PowerShell, desde la
# raiz del proyecto, quitando el # del principio de la linea.
#
# La excepcion es scripts/custom_role.py, que ESE SI se ejecuta.
#
# Coste: 0. Un rol personalizado no cobra nada y no hay nada que apagar.
# =============================================================================


# -----------------------------------------------------------------------------
# 0. Por que un rol personalizado
# -----------------------------------------------------------------------------
# La etapa 2 dio a deployer-sa un rol PREDEFINIDO (roles/compute.viewer), que
# es lo normal. Los predefinidos los mantiene Google y cubren el 90% de los
# casos.
#
# Pero para "solo arrancar y parar VMs" no hay ninguno que encaje. El mas
# pequeno que sirve es roles/compute.instanceAdmin.v1, y ese TAMBIEN permite
# borrar instancias, cambiarles el disco y reconfigurarlas. Darlo entero para
# que un script pueda apagar una maquina de noche es exactamente el exceso que
# ataca el principio de minimo privilegio.
#
# Un rol personalizado se arma permiso a permiso. Aqui, dos:
#   compute.instances.start
#   compute.instances.stop
#
# Ver de que permisos se compone un rol predefinido, para comparar:
#
#   gcloud iam roles describe roles/compute.instanceAdmin.v1 --format="value(includedPermissions)"
#
# Buscar permisos por nombre cuando no sabes como se llaman:
#
#   gcloud iam list-testable-permissions //cloudresourcemanager.googleapis.com/projects/gcp-lab-jona-01 --filter="name:compute.instances" --format="value(name)"


# -----------------------------------------------------------------------------
# 1. Instalar la libreria de Python
# -----------------------------------------------------------------------------
# google-api-python-client es el cliente generico: sirve para cualquier API de
# Google, incluida iam v1. google-auth es la que lee las Application Default
# Credentials, las mismas que usa Terraform. Por eso el script no lleva ninguna
# clave dentro.
#
#   pip install google-api-python-client google-auth
#
# Comprobar que quedo instalado:
#   python -c "import googleapiclient, google.auth; print('ok')"


# -----------------------------------------------------------------------------
# 2. Crear el rol
# -----------------------------------------------------------------------------
# Este si se ejecuta. Lee el project id de terraform/terraform.tfvars, asi que
# no hay ningun id escrito a mano en el codigo.
#
#   python scripts/custom_role.py
#
# Es idempotente: lanzarlo dos veces no falla. La segunda vez detecta el 409
# (ya existe) y hace un patch en lugar de un create.
#
# Reglas del id del rol, que NO son las de una service account:
#   service account -> minusculas, numeros y GUION, 6-30 caracteres
#   rol custom      -> letras, numeros, GUION BAJO y punto, 3-64 caracteres
# El guion normal no vale en un rol. De ahi 'vm_start_stop'. Y es inmutable.
#
# El campo 'stage' (ALPHA / BETA / GA / DISABLED) es una etiqueta informativa
# para quien lea el rol. La unica que hace algo es DISABLED: ese deja de
# conceder permisos sin necesidad de borrar el rol.


# =============================================================================
# COMPROBACION DE LA ETAPA 3
# =============================================================================
#   gcloud iam roles describe vm_start_stop --project=gcp-lab-jona-01
#
# Esperado: stage GA y includedPermissions con EXACTAMENTE dos entradas,
# compute.instances.start y compute.instances.stop.
#
# Contarlos sin leer a ojo:
#   (gcloud iam roles describe vm_start_stop --project=gcp-lab-jona-01 --format="value(includedPermissions)").Split(';').Count
#
# Verlo en la lista de roles personalizados del proyecto:
#   gcloud iam roles list --project=gcp-lab-jona-01
# =============================================================================


# -----------------------------------------------------------------------------
# 3. Opcional: usarlo de verdad
# -----------------------------------------------------------------------------
# El ejercicio no lo pide, pero un rol sin asignar a nadie no demuestra nada.
# Para atarlo a deployer-sa, el binding se escribe igual que en la etapa 2 y
# solo cambia el formato del --role: los personalizados llevan la ruta entera
# en vez del prefijo roles/.
#
#   predefinido -> roles/compute.viewer
#   custom      -> projects/gcp-lab-jona-01/roles/vm_start_stop
#
#   gcloud projects add-iam-policy-binding gcp-lab-jona-01 --member="serviceAccount:deployer-sa@gcp-lab-jona-01.iam.gserviceaccount.com" --role="projects/gcp-lab-jona-01/roles/vm_start_stop"
#
# Si lo haces, deployer-sa pasa a tener DOS roles y la comprobacion de la
# etapa 2 devolvera dos lineas en vez de una. Es correcto: los permisos son
# aditivos.


# -----------------------------------------------------------------------------
# LIMPIEZA (etapa 20)
# -----------------------------------------------------------------------------
# Borrar un rol personalizado no es inmediato: queda 7 dias en la papelera y su
# id sigue reservado. Si lo borras y quieres volver a crearlo el mismo dia, el
# create falla con 409 y hay que recuperarlo en vez de recrearlo.
#
#   gcloud iam roles delete vm_start_stop --project=gcp-lab-jona-01
#   gcloud iam roles undelete vm_start_stop --project=gcp-lab-jona-01
