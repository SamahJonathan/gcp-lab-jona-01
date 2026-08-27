# Cuestionario — etapas 1 y 2

Autoevaluación sobre [Terraform y APIs](apuntes-etapa-01-terraform-apis.md) y
[service accounts e IAM](apuntes-etapa-02-service-accounts-iam.md).

**Cómo usarlo:** responde en voz alta o por escrito *antes* de desplegar la
respuesta. Las respuestas están plegadas en `<details>`; GitHub y la vista previa
de VS Code las muestran como un desplegable, así que no se ven de reojo.

- 40 preguntas, 4 bloques.
- Las marcadas con ⚠ son las que en un examen real separan al que ha entendido
  del que ha memorizado.
- Al final hay una tabla de puntuación.

---

## Bloque A — Terraform: los archivos (10 preguntas)

**A1.** Acabas de crear un proyecto de GCP y lanzas `gcloud compute instances create`.
Falla. ¿Por qué, y por qué lo hace Google así?

<details><summary>Respuesta</summary>

La API del servicio (`compute.googleapis.com`) no está habilitada. Un proyecto
nuevo es una caja fuerte cerrada: hay que habilitar la API de cada producto antes
de poder usarlo. Google lo hace por seguridad —reduce la superficie de ataque— y
para no saturar la interfaz con servicios que no usas.
</details>

**A2.** ¿Por qué habilitar las APIs desde Terraform y no con clics en la consola?

<details><summary>Respuesta</summary>

Reproducibilidad. Con clics, dentro de un mes nadie recuerda cuáles se activaron
ni en qué orden. Con Terraform, un solo `apply` deja el proyecto listo desde
cero, y el código sirve de documentación.
</details>

**A3.** Empareja cada archivo con su papel: `variables.tf`, `terraform.tfvars`,
el bloque `terraform { }`, `main.tf`. ¿Cuáles viajan a git?

<details><summary>Respuesta</summary>

| Archivo | Papel | ¿A git? |
|---|---|---|
| `variables.tf` | las **declaraciones**: nombre, tipo, `description` | sí |
| `terraform.tfvars` | los **valores** (`project_id = "gcp-lab-jona-01"`) | **no**, `.gitignore` |
| bloque `terraform { }` | configura la herramienta: versión y providers | sí |
| `main.tf` | `locals.apis` + el recurso `google_project_service` | sí |

Tampoco viajan las credenciales ADC. En este repo el bloque `terraform { }` y el
`provider` viven dentro de [main.tf](../terraform/main.tf), aunque los apuntes
los describen como un `versions.tf` aparte.
</details>

**A4.** ¿Por qué el bloque `terraform { }` es distinto de todos los demás?

<details><summary>Respuesta</summary>

Es el único que **no crea nada en GCP**. Configura la propia herramienta:
versión mínima de Terraform y qué providers descargar.
</details>

**A5.** ¿Qué acepta y qué rechaza `version = "~> 6.0"`? ¿Cómo se llama ese operador?

<details><summary>Respuesta</summary>

*Pessimistic constraint operator*. Acepta 6.1, 6.50, 6.99… y **rechaza 7.0**.
Los saltos de versión mayor traen cambios que rompen. El vídeo del curso no fija
versión, y por eso su código puede fallarle a alguien dentro de seis meses.
</details>

**A6.** ⚠ En el bloque `provider "google" { }` no hay ninguna clave ni ningún
`credentials = "..."`. ¿De dónde saca entonces las credenciales?

<details><summary>Respuesta</summary>

De las **Application Default Credentials**, el JSON que escribió
`gcloud auth application-default login` en
`%APPDATA%\gcloud\application_default_credentials.json`.

Meter una clave dentro del `.tf` sería la mala práctica exacta que el ejercicio
15 enseña a evitar: las credenciales no viajan al repo.
</details>

**A7.** ⚠ Ninguna variable del proyecto lleva `default`. ¿Es un descuido?

<details><summary>Respuesta</summary>

No, es deliberado. Un `default = "gcp-lab-jona-01"` parece cómodo y es justo así
como se acaban creando recursos en el **proyecto equivocado**. Sin default, si
falta el `tfvars` Terraform se para y pregunta.
</details>

**A8.** Escribes `projet_id = "gcp-lab-jona-01"` (con typo) en el `.tfvars`.
¿Terraform falla, avisa o lo ignora?

<details><summary>Respuesta</summary>

Avisa y lo **ignora**:

```
Warning: Value for undeclared variable
  The root module does not declare a variable named "projet_id" but a value
  was found in file "terraform.tfvars".
```

Es solo un warning, no un error. Y como `project_id` sí está declarado pero se
queda sin valor y sin default, Terraform te lo preguntará por teclado.
</details>

**A9.** ¿Qué hace `toset()` en `for_each = toset(local.apis)` y por qué no se pasa
la lista directamente?

<details><summary>Respuesta</summary>

`for_each` espera un **conjunto** (o un mapa), no una lista. `toset()` convierte
la lista de APIs en conjunto. Cada elemento genera su propia entrada en el
estado, así que añadir o quitar una API es tocar una línea, en vez de repetir el
bloque `google_project_service` quince veces como hace el vídeo.
</details>

**A10.** ⚠ `disable_on_destroy = false`. ¿Qué pasaría con el valor por defecto, y
por qué importa justo en el ejercicio 20?

<details><summary>Respuesta</summary>

El valor por defecto es `true`: un `terraform destroy` **deshabilitaría las
APIs**. Eso rompe cualquier recurso que siga vivo fuera de Terraform. El
ejercicio 20 es la limpieza total, así que ahí es donde el efecto colateral
saltaría.

Su compañero `disable_dependent_services = false` evita además que Terraform
intente apagar también las APIs que dependen de esta.
</details>

---

## Bloque B — Terraform: el ciclo de trabajo (10 preguntas)

**B1.** Ordena el ciclo y di cuál es el único comando que escribe en GCP:
`apply`, `fmt`, `plan`, `validate`, `init`.

<details><summary>Respuesta</summary>

`init` → editar → `fmt` → `validate` → `plan` → leer → `apply`.

**`apply` es el único que escribe.** `init` descarga plugins, `fmt` y `validate`
son locales, `plan` llama a la API de Google pero **solo para leer**.

`init` va antes de todo y solo una vez por carpeta (o al cambiar de provider).
</details>

**B2.** ¿Qué tres fuentes de verdad compara `plan`?

<details><summary>Respuesta</summary>

1. El **código** `.tf` — lo que quieres.
2. El **estado** `terraform.tfstate` — lo que Terraform cree que creó.
3. **GCP** — lo que hay de verdad.

Y dice qué haría para que las tres coincidan.
</details>

**B3.** ⚠ Alguien crea una regla de firewall a mano desde la consola web.
¿Cómo se entera Terraform, y qué moraleja tiene?

<details><summary>Respuesta</summary>

Lo real deja de coincidir con el estado, y el siguiente `plan` lo delata. Esa es
la razón de **no mezclar clics de consola con infraestructura gestionada por
Terraform**: cada clic es una divergencia que alguien tendrá que reconciliar.
</details>

**B4.** ¿Qué significan `+`, `-`, `~` y `-/+` en un plan? ¿Cuál da miedo?

<details><summary>Respuesta</summary>

| Símbolo | Significa |
|---|---|
| `+` | crear |
| `-` | destruir |
| `~` | modificar en sitio |
| `-/+` | **destruir y recrear** — el peligroso |

`-/+` implica que el recurso se borra y se vuelve a hacer: IPs nuevas, discos
nuevos, datos perdidos si no estaban fuera.
</details>

**B5.** ⚠ ¿Qué detecta `validate` y qué no puede detectar?

<details><summary>Respuesta</summary>

**Sí:** sintaxis HCL, que los tipos de recurso existan en el provider (un
`google_projet_service` mal escrito salta aquí) y que las referencias resuelvan
(`var.project_id` sin su bloque `variable`, `local.apis` sin su `locals`).

**No:** nada que requiera hablar con GCP —si el proyecto existe, si tienes
permisos, si el nombre de un bucket está libre—. Para eso hace falta `plan` o
`apply`. Salida esperada: `Success! The configuration is valid.`
</details>

**B6.** Lanzas `fmt` y no imprime nada. ¿Ha fallado?

<details><summary>Respuesta</summary>

No: imprime **los archivos que ha cambiado**. Si no imprime nada, ya estaban en
el formato canónico (2 espacios, `=` alineados dentro de cada bloque). Es el
`gofmt` de Terraform: el estilo no se discute, se ejecuta el comando.
</details>

**B7.** ¿Qué hace `-chdir=terraform` y qué alternativa hay?

<details><summary>Respuesta</summary>

Le dice a Terraform "trabaja en la carpeta `terraform/`, pero yo estoy fuera".
La alternativa es `cd terraform` y lanzar sin el flag: hace lo mismo, pero deja
la terminal dentro de esa carpeta y luego hay que acordarse de salir para los
`gcloud`.
</details>

**B8.** De estos tres, ¿cuál va a git y por qué?
`.terraform/`, `.terraform.lock.hcl`, `terraform.tfstate`.

<details><summary>Respuesta</summary>

| Archivo | ¿A git? | Por qué |
|---|---|---|
| `.terraform/` | no | providers descargados, cientos de MB |
| `.terraform.lock.hcl` | **sí** | fija versión exacta y hashes del provider |
| `terraform.tfstate` | no | inventario de la infra, a veces con secretos |

El repo del curso anterior tiene el `tfstate` subido a GitHub: error común que
conviene no repetir.
</details>

**B9.** `description` en un bloque `variable`, ¿es un comentario elegante?

<details><summary>Respuesta</summary>

No, es un **argumento real**: sale en `terraform console`, en los mensajes de
error y en la documentación que generan herramientas como `terraform-docs`. Un
`#` solo lo lee quien abre el archivo.

Regla práctica: qué *es* la variable → `description`. Por qué está escrita *así*
→ `#`.
</details>

**B10.** Pegas `# terraform -chdir=terraform apply` en PowerShell y no pasa nada,
tampoco error. ¿Qué ha ocurrido?

<details><summary>Respuesta</summary>

Te has dejado el `#` de delante: PowerShell lo lee como comentario y no ejecuta
nada. Los `.sh` de [scripts/](../scripts/) son **cuadernos de copiar y pegar**,
con los comandos comentados a propósito para que no pase nada si alguien lanza el
archivo entero por error. Al pegarlos hay que quitar el `#` inicial.
</details>

---

## Bloque C — IAM y service accounts (13 preguntas)

**C1.** ¿Qué dos preguntas responde IAM, y qué puede ser el "quién"?

<details><summary>Respuesta</summary>

**Quién** accede y **qué** puede hacer. El quién puede ser una persona (cuenta de
Google) o una **service account**: una identidad para máquinas y scripts, no para
humanos.
</details>

**C2.** Descompón el email `deployer-sa@gcp-lab-jona-01.iam.gserviceaccount.com`.

<details><summary>Respuesta</summary>

```
deployer-sa @ gcp-lab-jona-01 .iam.gserviceaccount.com
└─ el id ─┘   └─ project id ─┘  └── dominio fijo ──┘
```

El id lo eliges tú; el resto lo compone GCP.
</details>

**C3.** ⚠ "Una service account es identidad y recurso a la vez." Explícalo.

<details><summary>Respuesta</summary>

Como **identidad**, recibe roles: es el miembro de un binding.
Como **recurso**, otros pueden tener permisos *sobre ella* —por ejemplo
`iam.serviceAccountUser` para suplantarla—.

Es la única entidad de IAM que juega en los dos lados del tablero.
</details>

**C4.** ⚠ La mayoría imagina la política IAM como "un usuario con su lista de
roles". ¿Cómo es de verdad?

<details><summary>Respuesta</summary>

Al revés. La política es una **lista de bindings**, y cada binding es
**un rol con N miembros**:

```yaml
bindings:
- role: roles/editor
  members:
  - serviceAccount:82408893781-compute@developer.gserviceaccount.com
  - user:jona.samah@gmail.com
- role: roles/compute.viewer
  members:
  - serviceAccount:deployer-sa@gcp-lab-jona-01.iam.gserviceaccount.com
etag: BwZZ5bQoRwY=
```

El rol es la clave, no el usuario.
</details>

**C5.** ¿Por qué un `--filter="bindings.members:deployer-sa"` **sin** `--flatten`
no sirve?

<details><summary>Respuesta</summary>

`--filter` trabaja sobre registros, y sin flatten hay **un solo registro**: la
política entera. No sabe mirar dentro del segundo nivel de lista.

`--flatten="bindings[].members"` recorre `bindings` (`[]` = todos) y dentro de
cada uno abre `members`, dejando **una fila por miembro**. Entonces el filtro sí
puede buscar. Es un patrón que reaparece mucho en `gcloud`
(`--flatten="tags.items[]"`, `--flatten="allowed[].ports[]"`…).
</details>

**C6.** ¿Para qué sirven `user:`, `serviceAccount:`, `group:` y `domain:`?

<details><summary>Respuesta</summary>

Son los **prefijos de miembro**: dicen qué tipo de identidad es la que va detrás.

| Prefijo | Para |
|---|---|
| `user:` | una persona |
| `serviceAccount:` | una identidad de máquina |
| `group:` | un grupo de Google Workspace |
| `domain:` | todo un dominio corporativo |

Sin prefijo, el comando falla.
</details>

**C7.** ⚠ Tienes `roles/viewer` en la organización y `roles/editor` en el
proyecto. ¿Qué puedes hacer en ese proyecto?

<details><summary>Respuesta</summary>

Las dos cosas: **los permisos son aditivos**. No existe un "denegar" que reste lo
concedido en otro nivel, y un rol amplio concedido arriba **no se puede recortar
abajo**.

(Existen las *deny policies*, pero son un mecanismo aparte y poco habitual.)
</details>

**C8.** ⚠ Diferencia entre `add-iam-policy-binding` y `set-iam-policy`, y qué
puede salir mal.

<details><summary>Respuesta</summary>

| | Qué hace | Riesgo |
|---|---|---|
| `add-iam-policy-binding` | **añade** un binding y respeta los demás | ninguno |
| `set-iam-policy` | **reemplaza** la política entera con un fichero | quitarte a ti mismo el `owner` sin querer |

Y quedarte sin `owner` en tu propio proyecto es un problema serio de arreglar.
</details>

**C9.** ¿Qué es el `etag` y qué problema resuelve?

<details><summary>Respuesta</summary>

Identifica la **versión** de la política. Si dos personas la modifican a la vez,
la segunda escritura falla porque su etag ya caducó, en vez de pisar el cambio de
la primera. Es **control de concurrencia optimista**, y es lo que hace seguro
`add-iam-policy-binding` frente a editar un volcado a mano.
</details>

**C10.** `add-iam-policy-binding` termina escupiendo un YAML enorme. ¿Es un error?

<details><summary>Respuesta</summary>

No. Hace **leer → modificar → escribir** y te enseña el resultado: la política
completa tal como ha quedado.
</details>

**C11.** ⚠ El hallazgo de la etapa: ¿qué rol trae de fábrica la service account
por defecto de Compute, y por qué es un problema?

<details><summary>Respuesta</summary>

**`roles/editor`**: crear, modificar y borrar casi cualquier cosa del proyecto
—buckets, bases de datos, clusters—.

Es la identidad que usan **por defecto todas las VMs**. Si alguien compromete el
nginx de una de ellas, hereda todo eso. Nadie la creó a mano: Google la generó
sola al habilitar las APIs en la etapa 1, junto a otras *service agents*.
</details>

**C12.** Si es un problema, ¿por qué no se le quita el `editor` en este lab?

<details><summary>Respuesta</summary>

Porque los ejercicios 6 y 7 crean VMs con la cuenta por defecto, igual que el
vídeo, y quitarle el rol los rompería. **En un proyecto real, quitárselo es de
las primeras cosas que se hacen.**
</details>

**C13.** Describe el contraste del principio de mínimo privilegio con el ejemplo
de esta etapa.

<details><summary>Respuesta</summary>

❌ De fábrica: `VM → default compute SA → roles/editor` (medio proyecto).
✅ El ejercicio: `script de despliegue → deployer-sa → roles/compute.viewer`
(solo leer instancias).

Si la identidad se ve comprometida, el atacante hereda **exactamente** lo que le
diste.
</details>

---

## Bloque D — Leer y escribir comandos (7 preguntas)

**D1.** ¿Cuál es el patrón general de un comando de `gcloud`?

<details><summary>Respuesta</summary>

```
gcloud  GRUPO  SUBGRUPO  VERBO  ARGUMENTO  --flags
```

El posicional (el que va sin `--`) es siempre el objeto sobre el que actúa el
verbo. `--help` funciona a cualquier altura: `gcloud iam --help`,
`gcloud iam service-accounts --help`, `gcloud iam service-accounts create --help`.
</details>

**D2.** ⚠ En estos dos comandos el posicional significa cosas distintas. ¿Cuáles?

```
gcloud iam service-accounts create deployer-sa ...
gcloud projects add-iam-policy-binding gcp-lab-jona-01 ...
```

<details><summary>Respuesta</summary>

En el primero es **la cosa que creas** (la service account).
En el segundo es **el sitio** donde aplicas el cambio (el proyecto entero).

Esa asimetría es la que hace que el segundo comando se lea mal la primera vez.
Nota además que en `add-iam-policy-binding` **no hay subgrupo**: el verbo cuelga
directo de `projects`.
</details>

**D3.** ¿Por qué en el comando 1 no se escribe el email de la cuenta y en el 2 sí?

<details><summary>Respuesta</summary>

Al crearla, GCP **compone el email solo** con el id y el proyecto. Al asignar el
rol, la cuenta ya existe y hay que identificarla entera, con prefijo incluido:
`--member="serviceAccount:deployer-sa@gcp-lab-jona-01.iam.gserviceaccount.com"`.
</details>

**D4.** Reglas del id de una service account, y diferencia con `--display-name`.

<details><summary>Respuesta</summary>

El **id** (lo que va antes de la `@`): minúsculas, números y guiones, de **6 a 30
caracteres**. El **`--display-name`** es solo la etiqueta que se ve en la consola
web: admite espacios y mayúsculas ("Deployer SA"). El `--description` es texto
libre para quien lo lea dentro de un año.
</details>

**D5.** ⚠ ¿Qué está mal en cada uno de estos tres?

```powershell
gcloud iam service-accounts create deployer-sa \
  --display-name="Deployer SA"

gcloud projects add-iam-policy-binding gcp-lab-jona-01 --member="deployer-sa@gcp-lab-jona-01.iam.gserviceaccount.com" --role="compute.viewer"

gcloud projects get-iam-policy gcp-lab-jona-01 --flatten=bindings[].members
```

<details><summary>Respuesta</summary>

1. El `\` de continuación es sintaxis de **bash**. En PowerShell, cada comando en
   una sola línea, o backtick al final.
2. Faltan dos prefijos: **`serviceAccount:`** en el `--member` y **`roles/`** en
   el `--role`.
3. El valor del `--flatten` va **sin comillas** y PowerShell interpreta los
   corchetes. Hay que escribir `--flatten="bindings[].members"`.

(Trampa hermana, del `CLAUDE.md`: en `terraform destroy` los flags tipo
`-target=google_container_cluster.primary` se entrecomillan enteros, o PowerShell
se come lo que va detrás del punto.)
</details>

**D6.** Escribe de memoria las dos comprobaciones de la etapa 2 y su resultado
esperado.

<details><summary>Respuesta</summary>

```powershell
gcloud iam service-accounts list --filter="email:deployer-sa"
gcloud projects get-iam-policy gcp-lab-jona-01 --flatten="bindings[].members" --filter="bindings.members:deployer-sa" --format="value(bindings.role)"
```

Esperado: **1 fila** con `Deployer SA` y `DISABLED: False`, y
`roles/compute.viewer` como **único** rol. Coste de la etapa: 0, no hay nada que
apagar.
</details>

**D7.** Y las de la etapa 1.

<details><summary>Respuesta</summary>

```powershell
terraform -chdir=terraform state list
(gcloud services list --enabled --format="value(config.name)").Count
```

Esperado: **una línea por API** en el estado (un `google_project_service` por
cada una) y **≥ 10** APIs habilitadas, entre ellas `compute`, `container`, `run`,
`bigquery`, `sqladmin`, `logging` y `monitoring`.
</details>

---

## Puntuación

| Aciertos | Lectura |
|---|---|
| 36–40 | Etapas cerradas. A por el ejercicio 3: rol personalizado con Python. |
| 28–35 | Bien. Repasa solo las ⚠ que hayas fallado. |
| 20–27 | Relee el bloque donde se concentren los fallos antes de seguir. |
| < 20 | Vuelve a los dos apuntes; el cuestionario después funciona mejor. |

Las ⚠ son doce: A6, A7, A10, B3, B5, C3, C4, C7, C8, C11, D2 y D5. Si fallas más
de tres de esas, el problema no es de memoria sino de modelo mental.
