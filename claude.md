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

Etapas 1 a 5 del `plan.md` hechas y verificadas en GCP:

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

Pendiente inmediato: la **etapa 6**, la primera VM. Los entregables ya estan escritos
(`compute-engine/create-instance.sh` y `compute-engine/startup-script.sh`), pero el
comando no se ha lanzado y en GCP todavia no hay ninguna maquina.

Antes de dar por buena la etapa 6 hace falta una segunda regla de firewall,
`http-custom`, que abra `tcp:80` al mismo tag: `ssh-custom` solo abre el 22 y el nginx
no responderia desde el navegador. El comando esta al final de
`scripts/etapa-05-firewall-network-tags.sh`.

El repo tiene remoto `origin` en github.com/SamahJonathan/gcp-lab-jona-01 y varios commits.

**A partir de la etapa 6 empieza el coste.** Hasta la 5 no hay en GCP ni un recurso que
se facture: APIs, una identidad, un rol, una red y una regla de firewall son gratis. Una
VM encendida no lo es, y su disco se sigue pagando aunque la pares.

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
