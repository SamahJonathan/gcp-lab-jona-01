# Etapa 10 — Clúster de GKE con Terraform

El entregable es [`terraform/gke.tf`](../terraform/gke.tf).

**El recurso más caro del curso.** Un nodo `e2-medium` ronda los 25 USD/mes y se
paga esté vacío o lleno, 24/7. Las etapas 10 y 11 se hacen seguidas y el clúster
se destruye el mismo día.

## Lo que de verdad se aprende aquí

Kubernetes es el reparto de trabajo entre muchas máquinas; **GKE es Kubernetes con
el cerebro gestionado por Google**. El reparto de responsabilidades es el
concepto de la etapa:

| Pieza | Qué es | Quién la gestiona |
|---|---|---|
| **Control plane** | decide qué corre, dónde y cuándo; vigila que todo esté como pediste | **Google** |
| **Nodos** | las VMs donde se ejecutan los contenedores | **tú** |

Y los nodos son literalmente máquinas de Compute Engine: el que creó este clúster
aparece en `gcloud compute instances list` como una `e2-medium` normal, con su
disco y su IP. La diferencia es quién manda sobre ella.

### Lo que lo separa del MIG de la etapa 7

| | MIG | Clúster de Kubernetes |
|---|---|---|
| Qué agrupa | máquinas idénticas | máquinas **+ un cerebro que reparte trabajo** |
| Qué le pides | *«quiero 2 máquinas»* | *«quiero 2 copias de esta app»* |
| Si algo falla | repone la **máquina** | mueve la **app** a otra máquina |
| Qué corre dentro | lo que diga la plantilla | cualquier contenedor, cambiable en caliente |

El MIG sabe contar máquinas. El clúster sabe repartir aplicaciones entre las
máquinas que tenga. Es un escalón más de abstracción.

### Los dos modos, que es la decisión de dinero

- **Standard** — eliges las máquinas y las pagas estén vacías o no. Control total.
- **Autopilot** — Google gestiona también los nodos y pagas la CPU y RAM que
  consumen los pods. Más caro por unidad, pero sin desperdicio.

Este laboratorio usa Standard, como el vídeo, porque es el que enseña las piezas.

## Las decisiones del `gke.tf`

**`network` y `subnetwork` declarados.** Es *la* línea que faltó en el proyecto
anterior: sin ellas GKE se va a la red `default` —la de modo auto que la
[etapa 4](apuntes-etapa-04-vpc-custom.md) decidió no usar— y el clúster acaba
fuera de tu red, con sus reglas de firewall colgando de otra VPC. No se arregla
editando: la red de un clúster es **inmutable** y cambiarla obliga a recrearlo.

La prueba de que esta vez entró bien: el nodo nació con IP **`10.10.0.9`**, dentro
de `subred-us-east1`.

**Zonal, no regional.** Dos ahorros: el control plane zonal entra en la exención
de un clúster por cuenta de facturación, y en un clúster regional
`initial_node_count` se crea **por zona** — con 1 saldrían 3 nodos y 3 facturas.
Para producción se querría regional, justo por lo contrario: sobrevivir a la caída
de una zona.

**Tres rangos de IP, no uno.** Un clúster VPC-native necesita, aparte del rango de
los nodos, uno para los pods y otro para los servicios:

```hcl
ip_allocation_policy {
  cluster_ipv4_cidr_block  = "/16"   # pods
  services_ipv4_cidr_block = "/22"   # servicios
}
```

Pedirlos **por tamaño**, sin direcciones concretas, deja que GKE busque huecos
libres y cree los rangos secundarios en la subred. Que cada pod tenga IP propia de
la VPC es lo que hace que un pod sea enrutable como si fuera una VM.

**Disco de 30 GB `pd-standard`** en vez de los 100 GB `pd-balanced` por defecto:
la diferencia entre ~1,20 y ~10 USD al mes.

**`deletion_protection = false`.** Viene en `true` y con `true` el
`terraform destroy` **falla**. Es el atasco que se ve al final del vídeo, cuando
intenta limpiar y el clúster se niega a morir.

## 🔧 Lo que salió al ejecutarlo: tres fallos distintos

Ninguno fue un error de configuración, y distinguirlos es más útil que el propio
ejercicio.

### 1. La zona sin capacidad

```
Error waiting for creating GKE cluster: Try a different location, or try again
later: Google Compute Engine does not have enough resources available to fulfill
request: us-east1-b.
```

Google **no tenía `e2-medium` libres** en esa zona en ese momento. Es inventario
físico, no permisos ni sintaxis, y la única salida es otra zona u otro momento. Es
el mismo muro que el `ZONE_RESOURCE_POOL_EXHAUSTED` que en la primera vuelta del
curso obligó a mudarse de `us-central1` a `us-east1`, solo que con un tipo de
máquina más grande, que escasea antes.

De ahí sale la variable `gke_zone`, separada de `var.zone` a propósito: las VMs del
laboratorio siguen en `us-east1-b`, que funciona para `e2-micro`; solo el clúster
se movió a `us-east1-c`.

⚠ **Y el efecto colateral que importa:** un clúster que falla al crearse **no se
queda sin crear, se queda en estado `ERROR`**, listado por `gcloud` y con su
control plane facturando. Hay que destruirlo antes de reintentar, o acumulas
clústeres zombis.

### 2. El corte de red

```
Error waiting for creating GKE cluster: error while retrieving operation: ...
wsarecv: An existing connection was forcibly closed by the remote host.
```

Esto **no es un fallo de GCP**: es la conexión del PC cayéndose mientras Terraform
esperaba el resultado. La operación siguió su curso en Google, el clúster se creó
perfectamente — pero Terraform no llegó a anotarlo en su estado.

> **La lección de método:** cuando un `apply` muere por red, lo primero no es
> reintentar, es **comprobar qué se creó de verdad**. Un segundo `apply` habría
> intentado crear un clúster que ya existía y habría fallado con *already exists*.

El arreglo es el mismo `terraform import` de la primera vuelta del curso:

```powershell
terraform -chdir=terraform import google_container_cluster.primary projects/gcp-lab-jona-01/locations/us-east1-c/clusters/cluster-lab
```

### 3. El drift que quedó después del import

El `plan` posterior no salió limpio: `deletion_protection = true -> false`. El
corte pilló al provider **antes** de aplicar ese campo, así que el clúster vivía
con la protección puesta. Un `apply` de tres segundos lo arregló.

Si no se hubiera mirado, el `destroy` de esa misma tarde habría fallado — y ahí sí
se habría quedado el clúster encendido toda la noche. **El arreglo no termina hasta
que el `plan` sale limpio.**

## Comprobaciones de la etapa

```powershell
gcloud container clusters list --format="table(name,status,currentNodeCount,location)"
```

Esperado: `cluster-lab`, `RUNNING`, 1 nodo, `us-east1-c`. Tarda ~5 minutos; si a
los 10 no está, algo va mal.

```powershell
gcloud compute instances list
```

Esperado: una `e2-medium` llamada `gke-cluster-lab-default-pool-XXXX`, con IP
interna del `10.10.0.x`. Esa línea demuestra las dos cosas a la vez: que los nodos
son VMs, y que están en tu VPC.

## El dinero

| Concepto | Se paga |
|---|---|
| Nodo `e2-medium` | por segundo mientras exista, vacío o lleno |
| Su disco de 30 GB | mientras exista |
| Control plane | 0,10 USD/h, con **un clúster zonal exento** por cuenta de facturación |
| Balanceador de la etapa 11 | aparte, y no lo gestiona Terraform |

> 🔧 **Este clúster estuvo casi 3 horas encendido** — se creó en el intento que se
> cortó y no se detectó hasta un rato después. El `AGE` del nodo (`168m`) lo
> delató. No es dinero importante, pero es la segunda vez en el laboratorio que
> algo se queda arriba por despiste, después de los 26 días del MIG.

### Apagado, en este orden

```bash
# 1. EN CLOUD SHELL: el Service de la etapa 11 primero
kubectl delete service nginx-app
kubectl delete deployment nginx-app
```

```powershell
# 2. EN EL PC: el clúster después
terraform -chdir=terraform destroy '-target=google_container_cluster.primary'
```

El orden importa: el balanceador lo creó `kubectl`, no Terraform, así que destruir
el clúster primero lo deja **huérfano**, facturando sin que nada lo reclame.
Haciéndolo bien, el `forwarding-rules list` queda vacío solo.
