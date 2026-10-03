# Etapa 13 — Cloud Functions gen2

Los entregables son [`cloud-run/funcion-prueba/main.py`](../cloud-run/funcion-prueba/main.py),
su [`requirements.txt`](../cloud-run/funcion-prueba/requirements.txt) y el cuaderno
[`deploy.sh`](../cloud-run/funcion-prueba/deploy.sh).

Coste ~0: escala a cero como el servicio de la [etapa 12](apuntes-etapa-12-cloud-run.md).
Lo único que ocupa es la imagen que construye el despliegue.

## Lo que de verdad se aprende aquí

Mientras Cloud Run sirve una **aplicación entera**, una Cloud Function es un trozo
de código que reacciona a un **evento**: un archivo subido a Storage, un mensaje en
Pub/Sub, o —como aquí— una llamada HTTP. Se despierta, procesa y se vuelve a
dormir; no hay servidor encendido esperando.

El ejemplo canónico: cada vez que alguien sube una imagen a un bucket, generar una
miniatura. No tendrías una VM encendida 24 horas por si acaso.

**Y el remate del módulo: la gen2 es Cloud Run por debajo.** No es una analogía,
es literal, y se comprueba en una línea:

```powershell
gcloud run services list --region=us-east1
```

| NAME | CONCURRENCIA | RAM |
|---|---|---|
| `funcion-prueba` | 1 | 256M |
| `hello-lab` | 80 | 512Mi |

La función aparece **en la lista de servicios de Cloud Run**, al lado del servicio
de la etapa 12. Por eso tiene dos URLs que devuelven exactamente lo mismo:

```
https://us-east1-gcp-lab-jona-01.cloudfunctions.net/funcion-prueba   ← cara de Functions
https://funcion-prueba-drpvg5j5fq-ue.a.run.app                        ← cara de Cloud Run
```

Y por eso la salida del despliegue dice `service: .../services/funcion-prueba`: lo
que se creó fue un servicio de Cloud Run.

La diferencia no está en la tecnología, está en **cuánto le das a Google**:

| | Etapa 12 | Etapa 13 |
|---|---|---|
| Qué entregas | una **imagen** ya construida | un **archivo .py** |
| Quién construye el contenedor | nadie, ya existía | **Cloud Build**, al desplegar |
| Qué sabes del contenedor | lo elegiste tú | no te enteras de que existe |

## ⚠ La corrección a la teoría del vídeo

El vídeo dice que una instancia atiende **hasta 80 peticiones a la vez**, como
ventaja sobre las funciones antiguas. La salida del despliegue dice otra cosa:

```
maxInstanceRequestConcurrency: 1
```

Las dos cosas son ciertas, pero no para lo mismo:

- Un servicio desplegado con `gcloud run deploy` sale con **80** — medido en
  `hello-lab`.
- Una **Cloud Function** sale con **1**: una petición por instancia, igual que las
  funciones antiguas.

Si se quisiera el comportamiento de la teoría, hay que subirlo a mano. Es el tipo
de detalle que el vídeo cuenta de forma que se puede entender mal, y la única
manera de saberlo fue leer la configuración real.

## El código

```python
@functions_framework.http
def hello_http(request):
    nombre = request.args.get("nombre", "mundo")
    return f"Hola {nombre}, desde una Cloud Function gen2 en us-east1.\n"
```

Tres cosas que saber:

**El decorador `@functions_framework.http`** es lo que convierte una función de
Python normal en algo que recibe peticiones web. Por debajo monta un Flask, y el
`request` es un objeto Request de Flask.

**Devolver un `str` es el atajo** para un 200 con `text/html`. Para controlar
código y cabeceras se devuelve una tupla:
`return ("no encontrado", 404, {"Content-Type": "text/plain"})`.

**El nombre de la función es un contrato.** `hello_http` tiene que coincidir exacto
con `--entry-point=hello_http`. Si renombras una, renombras la otra.

🔧 **El `?nombre=` no está en el vídeo.** Lo añadí para que la comprobación sea más
fuerte: un texto fijo solo demuestra que la función **responde**; leer un parámetro
demuestra que **recibe** la petición. `?nombre=jonathan` devolvió *Hola jonathan*.

🔧 **El `requirements.txt` no va vacío.** El vídeo lo deja en blanco y funciona,
porque el buildpack de Google instala `functions-framework` por su cuenta. Aquí se
declara `functions-framework~=3.8`: lo que el código importa debe estar escrito, o
el día que Google cambie su buildpack el despliegue se rompe sin que nadie haya
tocado nada. El `~=` acepta parches y menores pero no salta a la 4.x — misma idea
que el `~> 6.0` del proveedor en `terraform/main.tf`.

## El comando, y los tres errores que evita

```powershell
gcloud functions deploy funcion-prueba --gen2 --runtime=python312 --region=us-east1 --source=. --entry-point=hello_http --trigger-http --allow-unauthenticated --max-instances=3
```

| Error fácil | Qué pasa |
|---|---|
| `gcloud function deploy` | no existe. El grupo es **`functions`**, en plural |
| `--region=us-east1-b` | **403** `Location us-east1-b is not found`. Cloud Functions pide **región**, no zona |
| `--runtime=python310` | deprecado desde octubre de 2026; avisa al desplegar |

El de la región es **el reverso exacto** del tropiezo del snapshot en la
[etapa 8](apuntes-etapa-08-snapshots.md): allí se puso una región donde iba una
zona. La regla:

| Recurso | Pide |
|---|---|
| VM, disco, snapshot | **zona** (`us-east1-b`) |
| Subred, MIG, Cloud Run, Cloud Function | **región** (`us-east1`) |
| Clúster GKE | las dos valen: zonal o regional |

Y hay que lanzarlo **dentro de la carpeta de la función**: el `--source=.` es "el
código que hay donde estoy".

## Lo que se midió

El despliegue tardó **45 segundos** y salió a la primera.

🔧 **No hubo fallo de propagación de IAM**, que en la primera vuelta del curso
costó un rato: ahí las APIs se habilitaron en ese mismo momento y los permisos de
los agentes de servicio no habían propagado todavía, así que el build falló con
*Could not build the function due to missing permissions*. Aquí las cuatro APIs
(`cloudfunctions`, `cloudbuild`, `artifactregistry`, `run`) llevaban semanas
encendidas por `terraform/main.tf`. **Es el pago del criterio de declarar las APIs
en el código** en vez de aceptar el "¿la habilito?" del comando.

Si alguna vez sale ese error: no está roto, se espera 3-5 minutos y se relanza el
mismo comando. Para distinguirlo de un permiso que de verdad falta, el criterio
está en el `deploy.sh`.

Configuración con la que nació:

| Dato | Valor |
|---|---|
| `state` | ACTIVE |
| CPU / memoria | **0,1666 vCPU** / 256 M |
| `timeoutSeconds` | 60 |
| `maxInstanceCount` | 3 (el `--max-instances`) |
| `maxInstanceRequestConcurrency` | **1** |
| Revisión | `funcion-prueba-00001-fad` |

Una sexta parte de una CPU y 256 MB: mucho más pequeña que el servicio de la etapa
12 (1 vCPU, 512 Mi). Tiene sentido — una función está pensada para despertarse,
hacer una cosa y dormirse.

### Dónde acabó el código

```
bucket:           gcf-v2-sources-82408893781-us-east1   ← tu main.py, en un .zip
dockerRepository: .../repositories/gcf-artifacts         ← la imagen construida
```

Dos artefactos que no pediste. **Guárdalo para la etapa 14:** cuando abras Cloud
Storage y veas buckets que "no creó nadie", son estos.

## El dinero y la limpieza

Sin tráfico no cobra: escala a cero. Lo que sí ocupa es lo que construyó el
despliegue — el `.zip` del código y la imagen en Artifact Registry. Son céntimos
al mes, pero son el tipo de resto que nadie recuerda haber creado, el mismo goteo
que los snapshots de la etapa 8.

```powershell
gcloud functions delete funcion-prueba --gen2 --region=us-east1

# y si se quiere dejar limpio de verdad
gcloud artifacts repositories delete gcf-artifacts --location=us-east1
gcloud storage rm -r gs://gcf-v2-sources-82408893781-us-east1
```

## Lo que se lleva del módulo 3

Cuatro etapas que son **una escalera de delegación**, no cuatro servicios sueltos:

| Etapa | Qué gestionas | Qué cuesta en reposo |
|---|---|---|
| 10 — GKE Standard | los nodos, y los pagas vacíos o llenos | **todo** |
| 11 — Service LoadBalancer | el balanceador, que tampoco para solo | **todo** |
| 12 — Cloud Run | nada: das un contenedor | **nada** |
| 13 — Cloud Functions | ni el contenedor: das una función | **nada** |

Y la pregunta práctica para elegir: *¿varios servicios que deben hablar entre sí y
coordinarse?* → Kubernetes. *¿Una aplicación que responde a peticiones?* → Cloud
Run. *¿Un trozo de código que reacciona a algo?* → Cloud Functions.

El contraste de coste explica por qué las dos primeras se destruyeron el mismo día
y estas dos se pueden dejar desplegadas.
