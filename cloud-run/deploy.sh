#!/usr/bin/env bash
# =============================================================================
# ETAPA 12 - Cloud Run, de contenedor a URL
# =============================================================================
# NO es un script ejecutable. Es un cuaderno de copiar y pegar: los comandos van
# comentados y se lanzan en PowerShell quitando el # del principio.
#
# Apuntes: docs/apuntes-etapa-12-cloud-run.md
#
# La pregunta que responde esta etapa: tengo un contenedor, pero no quiero
# administrar Kubernetes. Cloud Run coge tu imagen y te devuelve una URL https
# con certificado, sin que toques un balanceador, un certificado ni un nodo.
#
# COSTE ~0, y es la unica etapa del modulo 3 que se puede dejar desplegada:
# SCALE TO ZERO. Sin peticiones no hay instancias, y sin instancias no se paga.
# Compara con el cluster de la etapa 10, que cobraba estuviera vacio o lleno.
# =============================================================================


# -----------------------------------------------------------------------------
# 1. El despliegue
# -----------------------------------------------------------------------------
# En UNA SOLA LINEA (el \ del video es de bash):
#
#   gcloud run deploy hello-lab --image=gcr.io/google-samples/hello-app:1.0 --region=us-east1 --allow-unauthenticated --max-instances=3
#
#   hello-lab                 nombre del servicio. Forma parte de la URL
#   --image=...hello-app:1.0  imagen YA construida, publica, de Google. Aqui no
#                             hay Dockerfile ni build: eso llega en la etapa 13
#   --region=us-east1         REGION, no zona. Cloud Run es regional
#   --allow-unauthenticated   lo hace PUBLICO (ver el aviso de abajo)
#   --max-instances=3         tope de instancias. El video no lo pone; es la red
#                             de seguridad contra una factura por un pico o un
#                             bucle de peticiones
#
# La API run.googleapis.com ya esta habilitada por terraform/main.tf, asi que NO
# te va a preguntar si quieres encenderla. En el video si pregunta, porque alli
# se habilitan a mano sobre la marcha.
#
# Sin --region, gcloud abre un menu interactivo y se queda esperando.
#
# ### QUE SIGNIFICA --allow-unauthenticated ###
# Da el rol roles/run.invoker al miembro especial allUsers, o sea: cualquiera en
# internet puede llamar al servicio. Es lo que el ejercicio quiere -abrirlo en el
# navegador- pero es una decision de IAM, la misma maquinaria de la etapa 2, no
# una casilla de Cloud Run. Sin ese flag, la URL devuelve 403 a quien no tenga el
# rol, y se llamaria con un token:
#
#   curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" URL


# =============================================================================
# 2. COMPROBACIONES DE LA ETAPA 12
# =============================================================================
# 2.1 La URL que te dio el despliegue:
#
#   gcloud run services list --format="value(URL)"
#
# 2.2 LA del ejercicio - que responde, y por https:
#
#   Invoke-WebRequest https://LA_URL
#
#   Esperado: StatusCode 200 y "Hello, world!" en el cuerpo.
#
#   EL DETALLE QUE HAY QUE VER: la URL es https y el certificado es valido, y tu
#   no has generado, instalado ni renovado ningun certificado. Compara con la
#   etapa 6, donde el nginx de la VM solo hablaba http por el puerto 80.
#
#   Si prefieres ver solo el codigo:
#
#     (Invoke-WebRequest https://LA_URL).StatusCode
#
# 2.3 La configuracion con la que nacio, que es lo interesante:
#
#   gcloud run services describe hello-lab --region=us-east1 --format="yaml(spec.template.spec.containerConcurrency,spec.template.spec.containers[0].resources)"
#
#   Esperado: containerConcurrency 80, 1 CPU y 512Mi de memoria.
#
#   Esas 80 peticiones POR INSTANCIA son la diferencia con las funciones
#   antiguas, que atendian una cada vez. Apuntalo, porque en la etapa 13 vas a
#   ver que una Cloud Function gen2 -que por debajo ES Cloud Run- sale con
#   containerConcurrency 1, al contrario de lo que promete la teoria del video.
#
# 2.4 Quien puede llamarlo (el efecto real del flag):
#
#   gcloud run services get-iam-policy hello-lab --region=us-east1
#
#   Esperado: allUsers con roles/run.invoker.


# -----------------------------------------------------------------------------
# 3. Lo que pasa por debajo y no se ve
# -----------------------------------------------------------------------------
# Esta etapa parece magia porque Google hace cuatro cosas que en el modulo 2
# costaron un ejercicio cada una:
#
#   balanceador + IP publica   lo del Service de la etapa 11, aqui gratis
#   certificado TLS            no existio en el modulo 2: la VM era solo http
#   escalado                   de 0 a N instancias segun trafico
#   despliegue por revisiones  cada deploy crea una revision nueva y mueve el
#                              trafico; si falla, se vuelve a la anterior
#
# Ver las revisiones:
#
#   gcloud run revisions list --service=hello-lab --region=us-east1


# -----------------------------------------------------------------------------
# 4. LIMPIEZA
# -----------------------------------------------------------------------------
# No hace falta por coste: sin trafico no cobra nada. Dejarlo desplegado es una
# decision razonable, y de hecho es la prueba viva del ejercicio.
#
# Si lo quieres quitar:
#
#   gcloud run services delete hello-lab --region=us-east1
#
# La imagen no se borra porque no es tuya: vive en el registro publico de Google.
# En la etapa 13 si se construye una imagen propia, y esa SI ocupa sitio en
# Artifact Registry y se paga.
