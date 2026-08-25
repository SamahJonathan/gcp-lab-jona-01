#!/usr/bin/env bash
# =============================================================================
# ETAPA 2 - Service account y binding IAM
# =============================================================================
# NO es un script ejecutable. Es un cuaderno de copiar y pegar.
# Los comandos van comentados a proposito. Se ejecutan en PowerShell, desde la
# raiz del proyecto, quitando el # del principio de la linea.
#
# Apuntes: docs/apuntes-etapa-02-service-accounts-iam.md
# Coste: 0
# =============================================================================


# -----------------------------------------------------------------------------
# 0. Ver lo que ya hay antes de crear nada
# -----------------------------------------------------------------------------
# Salen dos cuentas que nadie creo a mano: aparecieron solas al habilitar las
# APIs en la etapa 1. Google crea 'service agents' para que sus propios
# servicios puedan operar en el proyecto.
#
#   gcloud iam service-accounts list
#
# La default de Compute es la identidad que usan POR DEFECTO todas las VMs.
# Y viene con roles/editor, que es crear, modificar y borrar casi todo el
# proyecto. Comprobarlo:
#
#   gcloud projects get-iam-policy gcp-lab-jona-01 --flatten="bindings[].members" --filter="bindings.members:82408893781-compute@developer.gserviceaccount.com" --format="value(bindings.role)"
#
# En un proyecto real se le quita ese rol. Aqui se deja, para no romper los
# ejercicios 6 y 7, que crean VMs con la cuenta por defecto igual que el video.


# -----------------------------------------------------------------------------
# COMO SE LEE UN COMANDO DE gcloud
# -----------------------------------------------------------------------------
# Todos siguen el mismo patron:
#
#   gcloud  GRUPO  SUBGRUPO  VERBO  ARGUMENTO  --flags
#
# El posicional (el que va sin --) es siempre el objeto sobre el que actua el
# verbo. --help funciona a cualquier altura:
#
#   gcloud iam --help
#   gcloud iam service-accounts --help
#   gcloud iam service-accounts create --help
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# 1. Crear la identidad
# -----------------------------------------------------------------------------
# El id es lo que va antes de la @: minusculas, numeros y guiones, de 6 a 30
# caracteres. El email resultante lo compone GCP solo:
#
#   deployer-sa@gcp-lab-jona-01.iam.gserviceaccount.com
#
# --display-name es solo la etiqueta que se ve en la consola web.
#
#   gcloud iam service-accounts create deployer-sa --display-name="Deployer SA" --description="Identidad para despliegues automatizados del lab"
#
#   gcloud  iam  service-accounts  create  deployer-sa  --display-name=...  --description=...
#     |      |          |            |          |              |                   |
#     |      |          |            |          |              |                   texto libre, para quien
#     |      |          |            |          |              |                   lo lea dentro de un ano
#     |      |          |            |          |              etiqueta visible en la consola web,
#     |      |          |            |          |              admite espacios y mayusculas
#     |      |          |            |          EL ID. Posicional, sin --. Minusculas,
#     |      |          |            |          numeros y guiones, de 6 a 30 caracteres
#     |      |          |            el verbo: create, delete, describe, list, update
#     |      |          el tipo de recurso, siempre en plural
#     |      el producto: iam, compute, storage, run, sql, container
#     la CLI


# -----------------------------------------------------------------------------
# 2. Darle UN rol, el mas pequeno que le sirve
# -----------------------------------------------------------------------------
# Principio de minimo privilegio: si el script solo necesita leer instancias,
# se le da compute.viewer y no editor. Si la cuenta se filtra, el atacante
# hereda exactamente lo que se le concedio.
#
# add-iam-policy-binding es ADITIVO: anade este binding y respeta los que ya
# existen. Su hermano set-iam-policy REEMPLAZA la politica entera, y con el es
# facil quitarse a uno mismo el owner sin querer.
#
# El comando termina volcando la politica completa en YAML. No es un error:
# hace leer -> modificar -> escribir y ensena el resultado.
#
#   gcloud projects add-iam-policy-binding gcp-lab-jona-01 --member="serviceAccount:deployer-sa@gcp-lab-jona-01.iam.gserviceaccount.com" --role="roles/compute.viewer"
#
#   gcloud  projects  add-iam-policy-binding  gcp-lab-jona-01  --member=PREFIJO:EMAIL  --role=roles/NOMBRE
#     |        |               |                     |                |   |                    |
#     |        |               |                     |                |   |                    siempre con el prefijo
#     |        |               |                     |                |   |                    roles/ delante
#     |        |               |                     |                |   el email completo, este si entero
#     |        |               |                     |                el prefijo dice QUE TIPO de miembro es
#     |        |               |                     SOBRE QUE recurso se aplica: el proyecto entero
#     |        |               el verbo. Aqui no hay subgrupo: cuelga directo de projects
#     |        el producto
#     la CLI
#
# Asimetria a notar: en el comando 1 el posicional es LA COSA QUE CREAS; en el 2
# es EL SITIO donde aplicas el cambio.
#
# El email de la service account no se escribe en el comando 1: GCP lo compone
# con el id y el proyecto. En el comando 2 si va entero.
#
# Prefijos de miembro:
#   user:            una persona
#   serviceAccount:  una identidad de maquina
#   group:           un grupo de Google Workspace
#   domain:          todo un dominio corporativo


# =============================================================================
# COMPROBACIONES DE LA ETAPA 2
# =============================================================================
# La cuenta existe -> 1 fila, "Deployer SA", DISABLED False
#   gcloud iam service-accounts list --filter="email:deployer-sa"
#
# Su rol -> roles/compute.viewer, y solo ese
#   gcloud projects get-iam-policy gcp-lab-jona-01 --flatten="bindings[].members" --filter="bindings.members:deployer-sa" --format="value(bindings.role)"
#
# --flatten="bindings[].members" convierte la politica anidada (un rol con N
# miembros) en una fila por miembro. Sin eso el --filter no puede buscar dentro
# de la lista. Es un patron que reaparece mucho en gcloud.
# =============================================================================


# -----------------------------------------------------------------------------
# LIMPIEZA (etapa 20)
# -----------------------------------------------------------------------------
# Borrar la cuenta elimina tambien sus bindings.
#
#   gcloud iam service-accounts delete deployer-sa@gcp-lab-jona-01.iam.gserviceaccount.com
