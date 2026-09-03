# Contexto del proyecto

Laboratorio propio de GCP de Jonathan, montado desde cero el 25 de agosto de 2026
despues de terminar (casi) el curso "Google Cloud Engineer desde cero".
Responde siempre en espanol.

## Datos fijos

| Dato | Valor |
|---|---|
| Proyecto GCP | `gcp-lab-jona-01` (numero 82408893781) |
| Cuenta | jona.samah@gmail.com |
| Facturacion | `01D9FA-58E398-5AA6F7`, prueba gratuita de 300 USD **compartida** con el proyecto del curso |
| Region / zona | `us-east1` / `us-east1-b` |
| Perfil de gcloud | `lab` (el del curso es `default`) |

Herramientas en este PC: gcloud 581, Terraform 1.15.8, Python 3.12.
**No hay kubectl** y no se puede instalar con `gcloud components install`: el SDK esta en
`C:\Program Files (x86)` y hace falta ser administrador.

Es Windows con PowerShell: los argumentos tipo `-target=recurso.nombre` **hay que
entrecomillarlos** (`terraform destroy '-target=google_container_cluster.primary'`),
o PowerShell se come lo que va detras del punto.

## Estado

Etapas 1 a 6 del `plan.md` hechas y verificadas en GCP:

- **Etapa 1** — `terraform/main.tf` habilita 15 APIs. El `apply` esta hecho: el estado
  tiene 15 `google_project_service`.
- **Etapa 2** — service account `deployer-sa` con `roles/compute.viewer`, y solo ese.
- **Etapa 3** — rol personalizado `vm_start_stop` con dos permisos:
  `compute.instances.start` y `compute.instances.stop`.
- **Etapa 4** — `terraform/network.tf`: VPC `vpc-lab` en modo CUSTOM y una sola subred,
  `subred-us-east1` con `10.10.0.0/24`.
- **Etapa 5** — regla de firewall `ssh-custom` en `vpc-lab`: ingress, `tcp:22`, origen
  `0.0.0.0/0`, destino el network tag `web-server`. Creada con `gcloud`, no con
  Terraform, asi que **no esta en el estado** y se borra con `gcloud`.
- **Etapa 5 bis** — regla `http-custom`, igual pero `tcp:80`. Hizo falta para la etapa 6
  y **tambien para la 7**: por el 80 pasan los sondeos de salud de Google.
- **Etapa 6** — `servidor-web-1` con nginx instalado por un startup script, verificada
  con un 200 y `Welcome to nginx`. **La VM se borro al cerrar la sesion**; el comando
  para rehacerla esta en `compute-engine/create-instance.sh`.

Pendiente inmediato: la **etapa 7**, el MIG. `terraform/mig.tf` ya esta escrito y el
`plan` da `3 to add, 0 to change, 0 to destroy` (plantilla, health check y grupo), pero
**el apply no se ha lanzado**: en GCP no hay ninguna maquina.

En GCP ahora mismo no hay ni un recurso que se facture. Lo que queda son las 15 APIs,
`deployer-sa`, el rol `vm_start_stop`, la red con su subred y las dos reglas de firewall.

El repo tiene remoto `origin` en github.com/SamahJonathan/gcp-lab-jona-01 y varios commits.

**Desde la etapa 6 el coste es real, y la 7 es peor.** Una VM encendida se paga, y su
disco se sigue pagando aunque la pares. El MIG son 2 VMs a la vez, y ademas **borrar sus
instancias a mano no apaga nada**: el grupo las repone. Se apaga bajando `target_size` a
0 o destruyendo el grupo con Terraform.

## Convenciones

- El id del proyecto vive **una sola vez**, en `terraform/terraform.tfvars` (ignorado por git).
  Nunca escribirlo a mano en un `.tf` o en un script.
- Nombres de recursos que viajan a GCP: minusculas, numeros y `-`. El guion bajo solo
  vale para las etiquetas locales de Terraform.
- Comandos de `gcloud` que crean o borran algo: guardarlos comentados con `#` en `scripts/`,
  como cuaderno de copiar y pegar, no como script ejecutable.
- Avisar del coste antes de crear recursos que no paran solos (clusteres, balanceadores,
  discos, VMs). El proyecto anterior se dejo un cluster GKE encendido una semana.
- Mensajes de commit: una linea, formato `curso-NN: descripcion corta`. Con guion, no punto.
  **Sin trailer `Co-Authored-By`**: es un repo de estudio personal y los primeros commits
  no lo llevan.

## De donde viene esto

El proyecto del curso esta en `..\GCP_proyecto\GCP_proyecto_muestra` (repo
github.com/SamahJonathan/GCP_proyecto_muestra). Ahi estan los apuntes de los modulos 0 a 4
en `docs/`, que valen como referencia. De ese curso quedan pendientes los ejercicios 14 a 20;
este laboratorio es aparte y no los sustituye.
