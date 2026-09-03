# Plan guiado del curso "Google Cloud Engineer desde cero"

Origen: `transcripcion.md` (20 ejercicios, 5 módulos). Adaptado a este lab y a este PC.

- Proyecto GCP: `gcp-lab-jona-01`
- Repo: `git@github.com:SamahJonathan/gcp-lab-jona-01.git`
- Región / zona: `us-east1` / `us-east1-b`

## Cómo trabajamos

1. Te doy **un ejercicio por vez**: teoría en 3 líneas, el archivo a crear y el comando exacto.
2. Tú lo lanzas y me pegas la salida.
3. Corremos la **comprobación** del ejercicio. Si no da el resultado esperado, no avanzamos.
4. Commit `curso-NN` y a por el siguiente.

Yo escribo los `.tf` y los `.sh`. Los `apply` y los `gcloud` los ejecutas tú.

## Definición de "hecho"

Un ejercicio está hecho cuando cumple **las tres**:

| | Criterio |
|---|---|
| 1 | El comando de **comprobación** devuelve el resultado esperado |
| 2 | El archivo del entregable está en el repo y **pusheado** |
| 3 | El recurso queda **apagado o destruido** si el ejercicio lo pide |

Sin las tres, la casilla `[ ]` no se marca.

## Diferencias con el vídeo

| El vídeo hace | Nosotros hacemos | Por qué |
|---|---|---|
| `us-central1` / `us-central1-a` | `us-east1` / `us-east1-b` | es la región del lab |
| project id a mano en cada `.tf` y `.sh` | variable en `terraform/terraform.tfvars` | convención del lab |
| `kubectl` instalado | **no lo tenemos** → ej. 10 y 11 desde **Cloud Shell** | SDK en `Program Files (x86)`, sin admin |
| comandos multilínea con `\` | una sola línea, o backtick de PowerShell | PowerShell no entiende `\` |
| `terraform destroy -target=x.y` | `terraform destroy '-target=x.y'` | PowerShell parte en el punto |
| sube el `terraform.tfstate` a GitHub | ignorado en `.gitignore` | lleva datos del proyecto |
| carpeta `setup-teraform` | `terraform/` | ya decidido en `claude.md` |

---

## Fase 0 — Preparación · coste 0

| # | Paso | Comprobación | Resultado esperado |
|---|---|---|---|
| 0.1 | `git init -b main` + `remote add origin` | `git remote -v` | `origin` apuntando al repo, fetch y push |
| 0.2 | `.gitignore` | `git check-ignore -v terraform/terraform.tfvars` | devuelve la línea que lo ignora |
| 0.3 | 7 carpetas del proyecto | `Get-ChildItem -Directory` | Count = 7 |
| 0.4 | Perfil `lab` de gcloud | `gcloud config list` | account `jona.samah@gmail.com`, project `gcp-lab-jona-01`, region `us-east1` |
| 0.5 | `gcloud auth application-default login` | `gcloud auth application-default print-access-token` | imprime un token, sin error |
| 0.6 | `terraform/terraform.tfvars` | `terraform -chdir=terraform console` → `var.project_id` | `"gcp-lab-jona-01"` |
| 0.7 | Primer push | `git log --oneline` + el repo en GitHub | 1 commit, visible online |

- [x] Fase 0 completa

---

## Módulo 1 — IAM y redes · coste 0

- [x] **1. APIs con Terraform** — `terraform/main.tf`
  - Comprobar: `gcloud services list --enabled`
  - Esperado: **≥ 10 APIs**, entre ellas `compute`, `container`, `run`, `bigquery`, `sqladmin`, `logging`, `monitoring`
  - Además: `terraform -chdir=terraform state list` lista un `google_project_service` por API

- [x] **2. Service account + IAM** — `scripts/etapa-02-service-account-iam.sh`
  - Comprobar: `gcloud iam service-accounts list --filter="email:deployer-sa"` → 1 fila
  - Y el binding: `gcloud projects get-iam-policy gcp-lab-jona-01 --flatten="bindings[].members" --filter="bindings.members:deployer-sa" --format="value(bindings.role)"` → `roles/compute.viewer`

- [x] **3. Rol personalizado con Python** — `scripts/custom_role.py`
  - Comprobar: `gcloud iam roles describe vm_start_stop --project=gcp-lab-jona-01`
  - Esperado: `stage: GA` y `includedPermissions` con **exactamente 2**: `compute.instances.start` y `compute.instances.stop`

- [x] **4. VPC custom mode** — `terraform/network.tf`
  - Comprobar: `gcloud compute networks describe vpc-lab --format="value(x_gcloud_subnet_mode)"` → `CUSTOM` (no `AUTO`)
  - Y: `gcloud compute networks subnets list --filter="network:vpc-lab"` → **1 sola** subred, `subred-us-east1`, `10.10.0.0/24`, `us-east1`

- [x] **5. Firewall + network tags** — `scripts/etapa-05-firewall-network-tags.sh`
  - Comprobar: `gcloud compute firewall-rules describe ssh-custom --format="value(targetTags,allowed,direction)"`
  - Esperado: `web-server`, `tcp:22`, `INGRESS`

---

## Módulo 2 — Compute Engine · ⚠ empieza el coste

- [x] **6. VM con startup script** — `compute-engine/create-instance.sh` + `startup-script.sh`
  - Comprobar 1: `gcloud compute instances list --filter="name:servidor-web-1"` → `RUNNING` + IP externa
  - Comprobar 2: `(Invoke-WebRequest http://IP_EXTERNA).StatusCode` → **200**, con `Welcome to nginx` en el cuerpo
  - Medida real del ejercicio: **el nginx se instaló solo**, sin que entraras por SSH
  - ⚠ La IPv4 externa se cobra **aunque pares la VM**

- [x] **7. MIG** — `terraform/mig.tf`
  - Comprobar: `gcloud compute instance-groups managed list-instances app-mig --region=us-east1` → **2 instancias**, `RUNNING` y `HEALTHY`
  - Prueba de auto-healing (el ejercicio de verdad): borra una instancia a mano, vuelve a listar a los 2 min → siguen siendo **2**
  - ⚠ 2 VMs encendidas: bajar a 0 o destruir al cerrar la sesión

- [ ] **8. Snapshots con Python** — `compute-engine/backup_vm.py`
  - Comprobar: `gcloud compute snapshots list --format="table(name,status,diskSizeGb,storageBytes)"` → `READY` y `storageBytes > 0`
  - Segunda medida: lanza el script otra vez → el 2.º snapshot tarda mucho menos y ocupa mucho menos. **Son incrementales**

- [ ] **9. OS Login + SSH** — `compute-engine/os-login-ssh.sh`
  - Comprobar 1: `gcloud compute project-info describe --format="value(commonInstanceMetadata.items)"` contiene `enable-oslogin` = `TRUE`
  - Comprobar 2: `gcloud compute ssh servidor-web-1 --zone=us-east1-b --command="whoami"` → devuelve `jona_samah_gmail_com`, un usuario derivado de tu cuenta de Google (**no** `jona` ni `root`). Esa es la prueba de que OS Login manda

---

## Módulo 3 — Contenedores · ⚠⚠ el módulo más caro

- [ ] **10. GKE con Terraform** — `terraform/gke.tf`
  - Comprobar: `gcloud container clusters list --format="table(name,status,currentNodeCount,location)"` → `RUNNING` con el nº de nodos esperado
  - Tarda ~5 min (en el vídeo, 5:17). Si a los 10 min no está `RUNNING`, algo va mal
  - ⚠⚠ Control plane ~0,10 USD/h + nodos, **24/7**. Es lo que se quedó una semana encendido en el proyecto anterior

- [ ] **11. Deployment + LoadBalancer** — `gke/create-services.sh` (**desde Cloud Shell**)
  - Comprobar 1: `kubectl get pods` → pod `Running`, `READY 1/1`
  - Comprobar 2: `kubectl get svc nginx-app` → la `EXTERNAL-IP` deja de ser `<pending>` (1-2 min)
  - Comprobar 3: esa IP en el navegador → `Welcome to nginx`
  - ⚠ El LoadBalancer también cuesta. **Cluster destruido el mismo día**

- [ ] **12. Cloud Run** — `cloud-run/deploy.sh`
  - Comprobar: `gcloud run services list --format="value(URL)"`, luego `Invoke-WebRequest` a esa URL
  - Esperado: **200** y `Hello, world!`, sobre **https** y sin haber tocado ningún certificado
  - Coste ~0: scale to zero

- [ ] **13. Cloud Function gen2** — `cloud-run/funcion-prueba/`
  - Comprobar: `gcloud functions describe funcion-prueba --gen2 --region=us-east1 --format="value(state)"` → `ACTIVE`, y su URL devuelve **200** con tu texto
  - Segunda medida: edita `main.py`, redespliega, vuelve a llamar → el texto **cambia**. Ciclo de vida completo

---

## Módulo 4 — Almacenamiento y datos

- [ ] **14. Bucket con lifecycle** — `terraform/storage.tf`
  - Comprobar: `gcloud storage buckets describe gs://gcp-lab-jona-01-autoexpire` → 1 regla, `Delete`, `age = 30`
  - El nombre es **único global**: si el apply falla con `bucket name is not available`, se cambia

- [ ] **15. Subida programática** — `cloud-storage/upload_gcs.py`
  - Comprobar: `gcloud storage ls -l gs://.../archivos/test.txt` → existe, tamaño > 0
  - Y `gcloud storage cat gs://.../archivos/test.txt` devuelve el texto que escribiste

- [ ] **16. Cloud SQL PostgreSQL** — `scripts/cloud-sql-create.sh`
  - Comprobar 1: `gcloud sql instances list` → `RUNNABLE`, `POSTGRES_14`, `us-east1`
  - Comprobar 2 (**la que importa**): tras borrarla, `gcloud sql instances list` devuelve **vacío**
  - ⚠⚠ Caro y no para solo. Crear, mirar y borrar **en la misma sesión**

- [ ] **17. BigQuery** — `terraform/bigquery.tf` + `scripts/bigquery.sql`
  - Comprobar 1: `bq show --schema gcp-lab-jona-01:reportes.resumen_ventas` → 2 columnas, `producto` REQUIRED, `cantidad` NULLABLE
  - Comprobar 2: el INSERT sin `producto` **falla** (es REQUIRED); con las dos columnas funciona
  - Comprobar 3: `bq query --nouse_legacy_sql "SELECT COUNT(*) FROM reportes.resumen_ventas"` → el nº de filas que insertaste

---

## Módulo 5 — Operaciones

- [ ] **18. Uptime check** — `terraform/monitoring.tf`
  - Comprobar: en Monitoring → Uptime checks, a los ~5 min el check está **en verde** y con **varias regiones respondiendo OK**
  - ⚠ En el vídeo este ejercicio **sale en rojo y lo deja así**. Para que salga verde: IP **externa** de la VM del ej. 6 (nunca la interna), puerto 80, y una regla de firewall que abra `tcp:80` (la del ej. 5 solo abre el 22)
  - Segunda medida: para el nginx (`sudo systemctl stop nginx`) → el check pasa a **rojo** en 1-2 min. Ahí se ve que el monitor sirve para algo

- [ ] **19. Log sink a BigQuery** — `scripts/logging-export.sh`
  - Comprobar 1: `gcloud logging sinks describe mi-exportacion-bq --format="value(destination,writerIdentity)"` → dataset correcto + la SA
  - Comprobar 2: esa SA del `writerIdentity` tiene `roles/bigquery.dataEditor`. **El vídeo pasa por encima de este paso y sin él el sink no escribe nada**
  - Comprobar 3 (**la de verdad**): a los pocos minutos aparecen tablas nuevas en el dataset y `bq query "SELECT COUNT(*) ..."` devuelve **> 0**

- [ ] **20. Limpieza total** — `scripts/cleanup.sh`
  - Comprobar, los cinco **vacíos**:
    ```
    gcloud compute instances list
    gcloud container clusters list
    gcloud sql instances list
    gcloud compute addresses list
    gcloud compute forwarding-rules list
    ```
  - Y `terraform -chdir=terraform state list` → **sin líneas**
  - Y en Facturación, el gasto diario cae a **0** al día siguiente

---

## Checklist de apagado (al cerrar cada sesión)

Los mismos cinco comandos del ej. 20. Todo lo que salga y no vayas a usar mañana: apágalo o destrúyelo.

## Lo que el vídeo hace y aquí NO hacemos

- Crear cuenta de Google, cuenta de GCP y activar facturación (hecho).
- Crear el perfil de GitHub e instalar el SDK (hecho).
- Crear un proyecto nuevo por módulo (usamos solo `gcp-lab-jona-01`).
