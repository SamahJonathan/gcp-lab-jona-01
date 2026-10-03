# Etapa 12 — Cloud Run

El entregable es [`cloud-run/deploy.sh`](../cloud-run/deploy.sh).

Coste ~0, y es **la única etapa del módulo 3 que se puede dejar desplegada**: sin
peticiones no hay instancias, y sin instancias no se paga.

## Lo que de verdad se aprende aquí

La pregunta de la etapa: *tengo un contenedor, pero no quiero administrar
Kubernetes*. Cloud Run coge la imagen y devuelve una URL `https` funcionando.

Un solo comando hizo cuatro cosas que en el laboratorio costaron un ejercicio
cada una:

| Lo que montó Google | Dónde lo sufriste antes |
|---|---|
| Balanceador e IP pública | el `Service` LoadBalancer de la etapa 11 |
| **Certificado TLS** | no existió: el nginx de la etapa 6 era solo `http` |
| Escalado de 0 a N instancias | el `target_size` del MIG, a mano |
| Despliegue por revisiones | nada equivalente |

El certificado es el detalle que más dice. La salida fue `https` con certificado
válido —`ssl_verify=0` en `curl`— y nadie generó, instaló ni va a renovar nada.
Para darle HTTPS al nginx de la etapa 6 habrían hecho falta un certificado, un
balanceador delante y acordarse de renovarlo cada 90 días.

### La escalera del módulo 3

| Servicio | Qué gestionas tú |
|---|---|
| GKE Standard (etapa 10) | nodos: los dimensionas y los pagas vacíos o llenos |
| GKE Autopilot | nada de nodos; pagas lo que consumen los pods |
| **Cloud Run** (esta etapa) | **nada**: das un contenedor, te dan una URL |
| Cloud Functions (etapa 13) | ni el contenedor: das una función |

No son cuatro servicios sueltos, es una escalera de cuánto quieres delegar. Y la
pregunta práctica para elegir: *¿tengo varios servicios que deben hablar entre sí
y coordinarse?* → Kubernetes. *¿Tengo una cosa que responde a peticiones?* →
Cloud Run.

## El comando

```powershell
gcloud run deploy hello-lab --image=gcr.io/google-samples/hello-app:1.0 --region=us-east1 --allow-unauthenticated --max-instances=3
```

| Flag | Por qué |
|---|---|
| `--image=...hello-app:1.0` | imagen **ya construida** y pública de Google. Aquí no hay Dockerfile ni build: eso llega en la etapa 13 |
| `--region=us-east1` | **región**, no zona. Sin el flag, `gcloud` abre un menú interactivo y se queda esperando |
| `--allow-unauthenticated` | lo hace público. Ver abajo: es IAM, no una casilla |
| `--max-instances=3` | añadido fuera del vídeo: tope contra un pico o un bucle de peticiones |

🔧 **La API no preguntó nada.** El vídeo se para aquí a habilitar
`run.googleapis.com` sobre la marcha; en este laboratorio ya estaba encendida por
`terraform/main.tf`. Es el pago del criterio de tener las APIs en el código y no
darle a "Habilitar" en la consola.

### `--allow-unauthenticated` es una decisión de IAM

Ese flag le da el rol `roles/run.invoker` al miembro especial **`allUsers`**: o
sea, cualquiera en internet puede llamar al servicio. Es la misma maquinaria de la
[etapa 2](apuntes-etapa-02-service-accounts-iam.md), aplicada a un servicio en vez
de a un proyecto.

```powershell
gcloud run services get-iam-policy hello-lab --region=us-east1
```

Sin el flag, la URL devuelve **403** a quien no tenga el rol, y se llamaría con un
token de identidad:

```powershell
curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" URL
```

Eso es lo normal para un servicio interno. Aquí se abre porque el ejercicio
consiste en verlo en el navegador.

## Lo que se midió

```
HTTP/1.1 200 OK
Server: Google Frontend

Hello, world!
Version: 1.0.0
Hostname: localhost
```

Y la configuración con la que nació el servicio:

| Dato | Valor | Qué significa |
|---|---|---|
| `containerConcurrency` | **80** | peticiones simultáneas **por instancia** |
| CPU / memoria | 1 vCPU / 512 Mi | valores por defecto |
| `maxScale` | 3 | el `--max-instances` aplicado |
| `startup-cpu-boost` | true | CPU extra durante el arranque, para acortar el arranque en frío |
| Revisión | `hello-lab-00001-msg` | cada deploy crea una nueva |

⚠ **Las 80 peticiones por instancia son la diferencia con las funciones
antiguas**, que atendían una cada vez. Y hay que guardarse el dato, porque en la
etapa 13 se verá que una Cloud Function gen2 —que por debajo **es** Cloud Run—
sale con `containerConcurrency: 1`. La teoría del vídeo dice 80 para las dos, y
eso es cierto solo para un servicio desplegado con `gcloud run deploy`.

### Las revisiones

```powershell
gcloud run revisions list --service=hello-lab --region=us-east1
```

Cada despliegue crea una revisión y el tráfico se mueve a ella. Si una sale mal,
se vuelve a la anterior sin volver a construir nada. Es lo que en el módulo 2
habría sido recrear una VM a mano desde un snapshot.

## El dinero

| Concepto | Se paga |
|---|---|
| Instancias | solo mientras **procesan peticiones** |
| El servicio desplegado y sin tráfico | **nada**. Cero instancias |
| La imagen | nada: es pública, de Google, no está en tu registro |

**Scale to zero** y **stateless** son la misma moneda: Google puede permitirse
apagar todas las instancias porque dentro no hay nada que perder. El estado vive
fuera —BigQuery, Cloud Storage, Cloud SQL— y la app es una pieza reemplazable.

La prueba de si algo encaja aquí: *si mato esta instancia y arranco otra limpia,
¿se pierde o se rompe algo?* Si la respuesta es no, va a Cloud Run.

Esto es lo contrario del clúster de la [etapa 10](apuntes-etapa-10-gke.md), que
cobraba estuviera vacío o lleno — y la razón de que ese se destruyera el mismo día
y este se pueda dejar.

### Limpieza

No hace falta por coste. Si se quiere quitar:

```powershell
gcloud run services delete hello-lab --region=us-east1
```

La imagen no se borra porque no es tuya. En la etapa 13 sí se construye una propia,
y esa ocupa sitio en Artifact Registry y se paga.
