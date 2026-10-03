#!/usr/bin/env bash
# =============================================================================
# ETAPA 13 - Cloud Function gen2, orientada a eventos
# =============================================================================
# NO es un script ejecutable. Es un cuaderno de copiar y pegar: los comandos van
# comentados y se lanzan en PowerShell quitando el # del principio.
#
# Entregables: main.py (el codigo) y requirements.txt (sus dependencias).
# Apuntes:     docs/apuntes-etapa-13-cloud-functions.md
#
# Mientras Cloud Run sirve para una aplicacion entera, una Cloud Function es un
# trozo de codigo que reacciona a un EVENTO: un archivo subido a Storage, un
# mensaje en Pub/Sub o -como aqui- una llamada HTTP. Se despierta, procesa y se
# vuelve a dormir; no hay servidor encendido esperando.
#
# La gen2 por debajo ES Cloud Run. Se vera en las comprobaciones.
#
# COSTE: la funcion escala a cero igual que el servicio de la etapa 12, asi que
# sin trafico no cobra. Lo que SI ocupa y se paga es la imagen que construye el
# despliegue, en Artifact Registry. Ver la limpieza del final.
# =============================================================================


# -----------------------------------------------------------------------------
# 1. El despliegue
# -----------------------------------------------------------------------------
# HAY QUE ESTAR DENTRO DE ESTA CARPETA: el --source=. es "el codigo que hay
# donde estoy", no donde esta este archivo.
#
#   cd C:\Users\Joony\OneDrive\Documentos\proyectos_programacion\gcp-lab-jona-01\cloud-run\funcion-prueba
#
# En UNA SOLA LINEA:
#
#   gcloud functions deploy funcion-prueba --gen2 --runtime=python312 --region=us-east1 --source=. --entry-point=hello_http --trigger-http --allow-unauthenticated --max-instances=3
#
#   functions                 EN PLURAL. "gcloud function deploy" no existe
#   funcion-prueba            nombre de la funcion. Igual que la carpeta
#   --gen2                    la generacion nueva: mas tiempo de ejecucion, mas
#                             memoria, y Cloud Run por debajo
#   --runtime=python312       el video usa python310, DEPRECADO desde octubre de
#                             2026. Avisa al desplegar
#   --region=us-east1         REGION, no zona. Con us-east1-b da un 403:
#                             "Location us-east1-b is not found"
#   --source=.                el codigo de esta carpeta: main.py + requirements
#   --entry-point=hello_http  la FUNCION dentro de main.py. Tiene que coincidir
#   --trigger-http            el evento que la despierta es una peticion web
#   --allow-unauthenticated   publica, como en la etapa 12: es IAM, da
#                             roles/run.invoker a allUsers
#   --max-instances=3         tope de seguridad, fuera del video
#
# Las cuatro APIs que hacen falta (cloudfunctions, cloudbuild, artifactregistry
# y run) ya estan habilitadas por terraform/main.tf, asi que el comando NO se
# para a preguntar como en el video.
#
# TARDA UN PAR DE MINUTOS, y la razon es el ejercicio: Google no ejecuta tu .py
# directamente. Cloud Build EMPAQUETA el codigo, CONSTRUYE una imagen de
# contenedor con el runtime de Python dentro y la despliega como servicio de
# Cloud Run. De ahi que hagan falta las cuatro APIs.
#
# ### SI FALLA LA PRIMERA VEZ CON UN ERROR DE PERMISOS ###
#
#   OperationError: code=7, message=Could not build the function due to missing
#   permissions ... please retry in accordance with access-change-propagation
#
# No esta roto: al habilitar las APIs, Google crea por detras sus cuentas de
# servicio (agentes) y sus permisos tardan en propagarse. Se espera 3-5 minutos
# y se relanza el MISMO comando, sin cambiar nada. Para distinguirlo de un
# permiso que de verdad falta:
#
#   gcloud iam service-accounts list
#   gcloud projects get-iam-policy gcp-lab-jona-01 --flatten="bindings[].members" --filter="bindings.members:gcf-admin-robot OR bindings.members:cloudbuild" --format="value(bindings.role,bindings.members)"
#
# Si las cuentas existen, es propagacion: esperar. Si no existen, hay otro
# problema.


# =============================================================================
# 2. COMPROBACIONES DE LA ETAPA 13
# =============================================================================
# 2.1 Que esta viva:
#
#   gcloud functions describe funcion-prueba --gen2 --region=us-east1 --format='value(state)'
#
#   Esperado: ACTIVE
#
# 2.2 LA del ejercicio - que responde con tu texto:
#
#   gcloud functions describe funcion-prueba --gen2 --region=us-east1 --format='value(serviceConfig.uri)'
#   Invoke-WebRequest LA_URI_QUE_DEVOLVIO
#
#   Esperado: 200 y "Hola mundo, desde una Cloud Function gen2 en us-east1."
#
#   Y con parametro, para ver que recibe la peticion de verdad:
#
#   Invoke-WebRequest "LA_URI?nombre=jonathan"
#
# 2.3 QUE GEN2 ES CLOUD RUN. Esta es la comprobacion bonita de la etapa:
#
#   gcloud run services list --region=us-east1
#
#   Esperado: aparece funcion-prueba AL LADO de hello-lab, el servicio de la
#   etapa 12. La funcion no es otra cosa: es un servicio de Cloud Run con otra
#   cara. Y por eso tiene DOS URLs que devuelven lo mismo:
#
#     https://us-east1-gcp-lab-jona-01.cloudfunctions.net/funcion-prueba   (cara de Functions)
#     https://funcion-prueba-XXXXXXXX.us-east1.run.app                     (cara de Run)
#
# 2.4 LA CONTRADICCION CON LA TEORIA DEL VIDEO:
#
#   gcloud run services describe funcion-prueba --region=us-east1 --format='value(spec.template.spec.containerConcurrency)'
#
#   Esperado: 1
#
#   El video dice que una instancia atiende hasta 80 peticiones a la vez. Eso es
#   cierto para un servicio desplegado con "gcloud run deploy" -hello-lab salio
#   con 80, medido en la etapa 12- pero las Cloud Functions salen con
#   concurrencia 1: una peticion por instancia, como las funciones antiguas. Si
#   se quisiera el comportamiento de la teoria, hay que subirlo a mano.
#
# 2.5 Donde acabo tu codigo (dos artefactos que no pediste):
#
#   gcloud storage ls
#   gcloud artifacts repositories list --location=us-east1
#
#   Veras un bucket gcf-v2-sources-... con tu codigo en un .zip, y un repositorio
#   gcf-artifacts con la imagen construida. Guardalo para la etapa 14: cuando
#   abras Cloud Storage y veas buckets que "no creo nadie", son estos.


# -----------------------------------------------------------------------------
# 3. SEGUNDA MEDIDA: el ciclo de vida completo
# -----------------------------------------------------------------------------
# Edita el texto del return en main.py, guarda, y vuelve a lanzar EL MISMO
# comando de despliegue. Luego llama otra vez a la URL: el texto ha cambiado.
#
# Eso es el ciclo entero -codigo, build, despliegue, trafico- sin que hayas
# tocado un servidor, un contenedor ni un balanceador. Y por debajo Cloud Run
# creo una REVISION nueva y movio el trafico a ella, igual que en la etapa 12.


# -----------------------------------------------------------------------------
# 4. LIMPIEZA
# -----------------------------------------------------------------------------
# La funcion no cuesta nada sin trafico, igual que hello-lab. Lo que si ocupa es
# lo que construyo el despliegue:
#
#   gcloud functions delete funcion-prueba --gen2 --region=us-east1
#
# Y si se quiere dejar el proyecto limpio de verdad, los artefactos:
#
#   gcloud artifacts repositories delete gcf-artifacts --location=us-east1
#   gcloud storage rm -r gs://gcf-v2-sources-82408893781-us-east1
#
# Son centimos al mes, pero son el tipo de resto que nadie recuerda haber creado
# -el mismo goteo que los snapshots de la etapa 8-.
