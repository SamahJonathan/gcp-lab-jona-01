# Contexto del proyecto

Laboratorio propio de GCP de Jonathan, montado desde cero el 25 de agosto de 2026
despues de terminar (casi) el curso "Google Cloud Engineer desde cero".
Responde siempre en espanol.

## Datos fijos

| Dato | Valor |
|---|---|
| Proyecto GCP | `gcp-lab-jona-01` (numero 82408893781) |
| Cuenta | jona.samah@gmail.com |
| Facturacion | `01D9FA-58E398-5AA6F7`, prueba gratuita de 300 USD |
| Region / zona | `us-east1` / `us-east1-b` |
| Zona del cluster GKE | `us-east1-c` (variable `gke_zone`, aparte a proposito) |
| Perfil de gcloud | `lab` (el `default` apuntaba al proyecto del curso, ya borrado) |

Herramientas en este PC, verificadas el 3 de octubre de 2026:

| Herramienta | Version |
|---|---|
| gcloud | 581.0.0 |
| Terraform | 1.15.8 |
| Python | 3.12.10 |
| kubectl | v1.37.1, en `C:\Users\Joony\bin` (gana en el PATH; el del SDK tambien esta) |
| gke-gcloud-auth-plugin | v0.1.0-gke.3, en el SDK |

**Ya se puede usar Kubernetes desde este PC**; hasta el 3 de octubre no habia kubectl y
las etapas 10 y 11 se hicieron desde Cloud Shell. Lo que sigue necesitando una ventana de
PowerShell **como administrador** es cualquier `gcloud components ...`, porque el SDK esta
en `C:\Program Files (x86)`.

Es Windows con **PowerShell 5.1** (el antiguo), y de ahi tres cosas:

- Los argumentos tipo `-target=recurso.nombre` **hay que entrecomillarlos**
  (`terraform destroy '-target=google_container_cluster.primary'`), o PowerShell parte el
  argumento en el punto.
- En los `--format` conviene usar **comillas simples**: al pegar con dobles, la consola a
  veces se queda en `>>` esperando (se sale con `Ctrl+C`).
- No existe `&&`: los comandos van de uno en uno.

Pendiente opcional: instalar PowerShell 7 (`winget install --id 9MZ1SNWT0N5D --source
msstore`, sin admin), que arregla las tres.

## Estado

Etapas **1 a 12** del `plan.md` cerradas, cada una con su comprobacion verificada, sus
entregables pusheados y sus recursos destruidos. Los apuntes de cada etapa estan en `docs/`.

La siguiente es la **13**, Cloud Function gen2 (`cloud-run/funcion-prueba/`).

En GCP ahora mismo lo unico desplegado es el servicio de Cloud Run `hello-lab`
(etapa 12), que **no cuesta nada sin trafico**: escala a cero. No hay instancias, discos,
clusteres ni balanceadores. Lo demas que queda son las APIs, `deployer-sa`, el rol
`vm_start_stop`, la red `vpc-lab` con su subred, las dos reglas de firewall, dos snapshots
y la metadata `enable-oslogin=TRUE`.

El MIG de la etapa 7 esta declarado con **`target_size = 0`** a proposito: el grupo, la
plantilla y el health check son gratis, y asi ningun `apply` de una etapa posterior levanta
dos VMs sin que nadie lo pida.

## Lo que costo tiempo y conviene no repetir

- **Un recurso creado fuera del estado.** Si un `apply` muere a medias (corte de red, por
  ejemplo), el recurso puede existir en GCP y no estar en el estado. Lo primero es
  **comprobar que se creo de verdad**, no reintentar: se arregla con `terraform import`.
  Y despues, el `plan` tiene que salir limpio; si no, queda drift (al cluster le quedo
  `deletion_protection = true`, que habria hecho fallar el destroy).
- **Zona sin capacidad.** `us-east1-b` se quedo sin `e2-medium` libres. No es un error de
  configuracion, es inventario de Google, y el cluster fallido **queda en estado ERROR**,
  listado y facturando, hasta que se destruye.
- **El orden al apagar GKE**: primero `kubectl delete service`, despues el cluster. Al
  reves, el balanceador queda huerfano facturando.
- **Las cosas se quedan encendidas.** El MIG estuvo 26 dias arriba y el cluster casi 3
  horas, con el aviso ya escrito en los dos `.tf`. El apagado se hace **el mismo dia**.

## Convenciones

- El id del proyecto vive **una sola vez**, en `terraform/terraform.tfvars` (ignorado por git).
  Nunca escribirlo a mano en un `.tf` o en un script.
- Nombres de recursos que viajan a GCP: minusculas, numeros y `-`. El guion bajo solo
  vale para las etiquetas locales de Terraform.
- Comandos de `gcloud` que crean o borran algo: guardarlos comentados con `#` en un cuaderno
  (`scripts/`, o la carpeta del recurso), no como script ejecutable. Los `.py` si se ejecutan.
- Claude escribe los `.tf`, los `.sh` y los apuntes; los `apply` y los `gcloud` los lanza
  Jonathan, salvo que pida otra cosa.
- Avisar del coste antes de crear recursos que no paran solos (clusteres, balanceadores,
  discos, VMs).
- Mensajes de commit: **una linea**, formato `curso-NN: descripcion corta`. Con guion, no
  punto. **Sin trailer `Co-Authored-By`**: es un repo de estudio personal.

## De donde viene esto

El primer intento del curso esta en `..\GCP_proyecto\GCP_proyecto_muestra` (repo
github.com/SamahJonathan/GCP_proyecto_muestra). Llego al ejercicio 13 y **su proyecto de GCP
se borro el 29 de septiembre de 2026**; el repo sigue, y sus apuntes de los modulos 0 a 4
valen como referencia de la primera vuelta.
