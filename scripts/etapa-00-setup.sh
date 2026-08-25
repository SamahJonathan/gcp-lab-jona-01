#!/usr/bin/env bash
# =============================================================================
# ETAPA 0 - Preparacion del laboratorio
# =============================================================================
# NO es un script ejecutable. Es un cuaderno de copiar y pegar.
# Los comandos van comentados a proposito, para que nadie lo lance entero
# sin querer. Se ejecutan en PowerShell, desde la raiz del proyecto.
#
# Comprobar siempre antes de empezar:
#   pwd    -> debe terminar en ...\gcp-lab-jona-01
# =============================================================================


# -----------------------------------------------------------------------------
# 1. Repositorio git
# -----------------------------------------------------------------------------
# 'git init' crea la carpeta oculta .git, que es donde git guarda el historial.
# El flag -b main nombra 'main' a la rama inicial (sin el, git la llama 'master'
# y GitHub espera 'main', asi que el primer push daria guerra).
#
#   git init -b main
#
# 'remote add origin' guarda la direccion del repositorio remoto bajo el alias
# 'origin'. No conecta ni sube nada todavia: solo apunta la direccion.
# Esta es la forma SSH; necesita una clave subida a GitHub. Si el push falla con
# 'Permission denied (publickey)', se cambia a HTTPS con:
#   git remote set-url origin https://github.com/SamahJonathan/gcp-lab-jona-01.git
#
#   git remote add origin git@github.com:SamahJonathan/gcp-lab-jona-01.git


# -----------------------------------------------------------------------------
# 2. .gitignore
# -----------------------------------------------------------------------------
# Lista de patrones que git NO debe subir. Aqui importa de verdad:
#
#   terraform.tfvars  -> lleva el id del proyecto. Es el unico sitio donde vive
#                        (convencion del lab), y no tiene que acabar en GitHub.
#   *.tfstate         -> el estado de Terraform. Es un JSON con el inventario
#                        completo de la infraestructura y a veces con secretos.
#                        El repo del curso anterior lo tiene subido: mala idea.
#   .terraform/       -> providers descargados. Pesan cientos de MB.
#   __pycache__/      -> bytecode de Python, se regenera solo.
#
# El .terraform.lock.hcl SI se sube: fija la version del provider para que el
# proyecto se comporte igual dentro de seis meses.
#
# En PowerShell se escribe con un here-string de comillas simples (@'...'@).
# El '@ de cierre TIENE que ir pegado al margen izquierdo, columna 0, o
# PowerShell da error de sintaxis. Las comillas simples evitan que expanda
# los $ y los backticks del contenido.
#
#   @'
#   terraform.tfvars
#   .terraform/
#   *.tfstate
#   '@ | Set-Content -Encoding utf8 .gitignore
#
# Verificar que el archivo NO quedo vacio (fallo tipico al pegarlo):
#   Get-Content .gitignore


# -----------------------------------------------------------------------------
# 3. Estructura de carpetas
# -----------------------------------------------------------------------------
# Siete carpetas de golpe. Desglose del pipeline:
#
#   'a','b','c'           -> un array; manda 3 objetos string por la tuberia
#   |                     -> en PowerShell viajan objetos, no lineas de texto
#   ForEach-Object { }    -> ejecuta el bloque una vez por objeto
#   $_                    -> el objeto actual de la vuelta
#   New-Item -ItemType Directory -Force  -> crea la carpeta; -Force es el
#                            equivalente a 'mkdir -p': no falla si ya existe
#   | Out-Null            -> descarta la tabla que New-Item devuelve
#
# Version corta equivalente: mkdir terraform, scripts, ...
# (pero esa si revienta si alguna carpeta ya existe)
#
#   'terraform','scripts','compute-engine','cloud-storage','cloud-run','gke','docs' | ForEach-Object { New-Item -ItemType Directory -Force $_ } | Out-Null
#
# Que va en cada una:
#   terraform/       todo el .tf y un unico terraform.tfstate
#   scripts/         cuadernos de comandos como este, y los .py de IAM
#   compute-engine/  ejercicios 6, 8 y 9
#   cloud-storage/   ejercicio 15
#   cloud-run/       ejercicios 12 y 13
#   gke/             ejercicio 11
#   docs/            apuntes


# -----------------------------------------------------------------------------
# 4. Perfil de gcloud
# -----------------------------------------------------------------------------
# gcloud guarda "configuraciones": conjuntos de cuenta + proyecto + region.
# En este PC hay dos: 'default' (proyecto del curso) y 'lab' (este).
# 'activate' cambia de una a otra, para no crear recursos en el proyecto
# equivocado.
#
#   gcloud config configurations activate lab
#
# Estos tres set escriben dentro de la configuracion activa. project es
# obligatorio; region y zone son valores por defecto que ahorran escribir
# --region y --zone en cada comando despues.
#
#   gcloud config set project gcp-lab-jona-01
#   gcloud config set compute/region us-east1
#   gcloud config set compute/zone us-east1-b
#
# Verificar. Tiene que aparecer una seccion [compute] con region y zone.
# Si solo sale [core], los set no llegaron a ejecutarse:
#   gcloud config list


# -----------------------------------------------------------------------------
# 5. Credenciales
# -----------------------------------------------------------------------------
# Son DOS logins distintos y hacen falta los dos. Es el punto donde el video
# tropieza un par de veces.
#
# 'gcloud auth login' autentica el CLI: es lo que usan los comandos gcloud.
#
#   gcloud auth login
#
# 'application-default login' escribe un JSON en
#   %APPDATA%\gcloud\application_default_credentials.json
# que leen automaticamente Terraform y las librerias cliente de Python.
# Gracias a esto no hay que pegar claves secretas dentro del codigo, que es
# justo la mala practica que enseña a evitar el ejercicio 15.
#
#   gcloud auth application-default login
#
# Verificar (debe imprimir un token largo que empieza por ya29.):
#   gcloud auth application-default print-access-token


# -----------------------------------------------------------------------------
# 6. terraform/terraform.tfvars
# -----------------------------------------------------------------------------
# Unico sitio del proyecto donde se escribe el id. Los .tf lo leen como
# var.project_id. Esta en el .gitignore, asi que no viaja a GitHub.
#
#   @'
#   project_id = "gcp-lab-jona-01"
#   region     = "us-east1"
#   zone       = "us-east1-b"
#   '@ | Set-Content -Encoding utf8 terraform\terraform.tfvars


# -----------------------------------------------------------------------------
# 7. Primer commit
# -----------------------------------------------------------------------------
#   git add .                                   # pasa los cambios al staging
#   git commit -m "fase-0: estructura del lab"  # los fija en el historial local
#   git push -u origin main                     # los sube; -u deja main atada
#                                               # a origin/main para futuros push
#
# 'git status' antes del commit: terraform.tfvars NO debe aparecer en la lista.
# Si aparece, el .gitignore esta mal o vacio.


# =============================================================================
# COMPROBACIONES DE LA ETAPA 0
# =============================================================================
#   git remote -v                                  -> origin, fetch y push
#   git check-ignore -v terraform/terraform.tfvars -> una linea del .gitignore
#                                                     (si no imprime nada, mal)
#   (Get-ChildItem -Directory).Count               -> 7
#   gcloud config list                             -> [core] y [compute]
#   gcloud auth application-default print-access-token -> token ya29...
#   git log --oneline                              -> 1 commit
# =============================================================================
