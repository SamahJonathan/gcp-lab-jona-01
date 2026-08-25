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

- `terraform/` tiene la base escrita y validada: APIs, `vpc-lab` y `subred-us-east1`.
- **Aun no se ha hecho `terraform apply`**: en GCP el proyecto esta vacio.
- El repo git esta iniciado pero sin ningun commit ni remoto.

## Convenciones

- El id del proyecto vive **una sola vez**, en `terraform/terraform.tfvars` (ignorado por git).
  Nunca escribirlo a mano en un `.tf` o en un script.
- Nombres de recursos que viajan a GCP: minusculas, numeros y `-`. El guion bajo solo
  vale para las etiquetas locales de Terraform.
- Comandos de `gcloud` que crean o borran algo: guardarlos comentados con `#` en `scripts/`,
  como cuaderno de copiar y pegar, no como script ejecutable.
- Avisar del coste antes de crear recursos que no paran solos (clusteres, balanceadores,
  discos, VMs). El proyecto anterior se dejo un cluster GKE encendido una semana.

## De donde viene esto

El proyecto del curso esta en `..\GCP_proyecto\GCP_proyecto_muestra` (repo
github.com/SamahJonathan/GCP_proyecto_muestra). Ahi estan los apuntes de los modulos 0 a 4
en `docs/`, que valen como referencia. De ese curso quedan pendientes los ejercicios 14 a 20;
este laboratorio es aparte y no los sustituye.
