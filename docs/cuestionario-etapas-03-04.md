# Cuestionario — etapas 3 y 4

Autoevaluación sobre [el rol personalizado](apuntes-etapa-03-rol-personalizado.md)
y [la VPC en modo custom](apuntes-etapa-04-vpc-custom.md).

**Cómo usarlo:** responde antes de desplegar la respuesta. Están plegadas en
`<details>`, así que no se ven de reojo.

- 34 preguntas, 4 bloques.
- Las ⚠ son las que distinguen entender de memorizar.
- Tabla de puntuación al final.

Viene detrás de [las etapas 1 y 2](cuestionario-etapas-01-02.md).

---

## Bloque A — Roles y permisos (9 preguntas)

**A1.** Con la analogía de las llaves: ¿qué es un permiso, qué es un rol y qué es
un rol personalizado?

<details><summary>Respuesta</summary>

Un **permiso** es una llave suelta (`compute.instances.start` enciende una
máquina). Un **rol** es un manojo: varias llaves en una anilla, que se entrega de
una vez. Un **rol personalizado** es un manojo que montas tú, llave por llave, en
vez de coger uno de los que Google trae hechos.
</details>

**A2.** ⚠ Quieres que un script pueda encender y apagar VMs, nada más. ¿Por qué
no vale ningún rol predefinido?

<details><summary>Respuesta</summary>

Porque el más pequeño que sirve, `roles/compute.instanceAdmin.v1`, **también
permite borrarlas** —y cambiarles el disco, la identidad y los metadatos—.
Dárselo entero a un script que solo apaga máquinas de noche es exactamente el
exceso que ataca el principio de mínimo privilegio de la etapa 2.
</details>

**A3.** Sobre las instancias existen 54 permisos y el rol coge 2. Nombra tres de
los peligrosos que quedan fuera y por qué lo son.

<details><summary>Respuesta</summary>

| Permiso | Por qué es peligroso |
|---|---|
| `compute.instances.delete` | borra la máquina |
| `compute.instances.setMetadata` | permite meter una clave SSH o un script de arranque → **root dentro de la VM** |
| `compute.instances.setServiceAccount` | cambia la identidad de la VM |

Los dos últimos son escalada de privilegios: enganchando a la VM la cuenta de
fábrica (la del `roles/editor` de la etapa 2), desde dentro se hereda medio
proyecto.
</details>

**A4.** ⚠ El nombre del rol es `vm_start_stop`, con guion bajo. Pero la norma del
laboratorio dice que lo que viaja a GCP lleva guion normal. ¿Quién se equivoca?

<details><summary>Respuesta</summary>

Nadie: es una **excepción real**. Los roles personalizados **no admiten guion**.
Aceptan letras, números, guion bajo y punto, de 3 a 64 caracteres.

Contraste con la etapa 2:

| | Qué admite | Longitud |
|---|---|---|
| id de service account | minúsculas, números y **guion** | 6-30 |
| id de rol personalizado | letras, números, **guion bajo** y punto | 3-64 |

Los dos son inmutables una vez creados.
</details>

**A5.** ¿Qué es el campo `stage` y cuál de sus valores hace algo de verdad?

<details><summary>Respuesta</summary>

Dice en qué punto de su vida está el rol: `ALPHA`, `BETA`, `GA` (terminado) o
`DISABLED`. Las tres primeras son **etiquetas informativas** para quien lo lea y
no cambian lo que el rol permite.

La única que hace algo es **`DISABLED`**: un rol así deja de conceder permisos
sin necesidad de borrarlo. Es el interruptor para desactivar sin destruir.
</details>

**A6.** ¿Qué significa que un script sea **idempotente** y cómo lo consigue
`custom_role.py`?

<details><summary>Respuesta</summary>

Que da igual lanzarlo una vez o diez: el resultado es el mismo y no revienta.

Lo consigue capturando el error **409** (*ya existe algo que se llama así*). En
lugar de morir, pregunta cómo está el rol que ya hay y lo corrige para dejarlo
como dice el código.
</details>

**A7.** ⚠ Un 409 tiene dos causas distintas. ¿Cuáles, y por qué el script hace un
`get` antes de corregir?

<details><summary>Respuesta</summary>

| Causa | Qué hay que hacer |
|---|---|
| El rol existe y está vivo | corregirlo con `patch` |
| El rol está **borrado, en la papelera** | **recuperarlo**; el `patch` no sirve |

Un rol personalizado borrado no desaparece: pasa **siete días en la papelera** y
su nombre sigue ocupado. Por eso el script consulta el estado antes de decidir, y
si está en la papelera te da el comando:

```powershell
gcloud iam roles undelete vm_start_stop --project=gcp-lab-jona-01
```
</details>

**A8.** ¿Qué es `updateMask` y con qué idea de la etapa 2 emparenta?

<details><summary>Respuesta</summary>

Le dice a la API **qué campos tocar** —`title,description,includedPermissions,stage`—
en vez de mandar el objeto entero para que lo sustituya.

Emparenta con el `etag` y con la diferencia entre `add-iam-policy-binding` y
`set-iam-policy`: cambiar lo justo, quirúrgicamente, en lugar de reemplazar todo
y arriesgarse a pisar algo que no era tuyo.
</details>

**A9.** ¿Cómo se escribe un rol personalizado en un `--role`, comparado con uno
predefinido?

<details><summary>Respuesta</summary>

```
predefinido -> roles/compute.viewer
custom      -> projects/gcp-lab-jona-01/roles/vm_start_stop
```

El predefinido lleva el prefijo `roles/`; el personalizado, **la ruta completa**
con el proyecto donde vive. Tiene sentido: uno es de Google y es el mismo en todo
el mundo, el otro existe solo en tu proyecto.
</details>

---

## Bloque B — El script de Python (8 preguntas)

**B1.** ¿Cuáles son las dos funciones propias del script y qué hace cada una?

<details><summary>Respuesta</summary>

- **`leer_project_id()`** — devuelve el nombre del proyecto leyéndolo de
  `terraform/terraform.tfvars`.
- **`main()`** — el guion: pide el proyecto, coge las credenciales, se conecta,
  intenta crear, decide qué hacer si falla e imprime el resultado.

Todo lo demás son funciones prestadas de librerías.
</details>

**B2.** ⚠ ¿Por qué el script no lleva el `gcp-lab-jona-01` escrito dentro?

<details><summary>Respuesta</summary>

Por la norma del laboratorio: **el id del proyecto vive una sola vez**, en
`terraform/terraform.tfvars`, que además está en el `.gitignore`. Si algún día
cambia, se toca un sitio y no diez. Y no acaba publicado en GitHub.
</details>

**B3.** ¿Qué hace `Path(__file__).resolve().parent.parent` y qué problema resuelve?

<details><summary>Respuesta</summary>

`Path(__file__)` es la ruta de este mismo script; `.resolve()` la convierte en
absoluta; cada `.parent` sube una carpeta. De `scripts/custom_role.py` sube a
`scripts/` y de ahí a la raíz del proyecto.

Resuelve que el script funcione **desde cualquier carpeta**: no busca el `tfvars`
"donde estés tú", sino a partir de dónde está él mismo.
</details>

**B4.** ⚠ Este código no crea nada. ¿Por qué?

```python
roles.create(parent=padre, body={"roleId": ROL_ID, "role": ROL})
```

<details><summary>Respuesta</summary>

Le falta **`.execute()`**. Los métodos `create()`, `get()` y `patch()` solo
**preparan la petición**; hasta que no se llama a `.execute()` no sale nada hacia
Google.

Y es un fallo silencioso de los malos: el script correría entero, sin error, sin
crear nada.
</details>

**B5.** ¿Por qué `main()` devuelve un número y no un texto?

<details><summary>Respuesta</summary>

Porque es el **código de salida** del proceso: `0` es éxito, cualquier otro
número es un problema. Es la convención de los sistemas operativos, y sirve para
que otro script encadenado detrás sepa si continuar. Aquí devuelve `1` cuando el
rol está en la papelera.

Se comprueba con `$LASTEXITCODE` en PowerShell.
</details>

**B6.** ⚠ ¿Para qué sirve la última línea, y qué pasaría sin ella?

```python
if __name__ == "__main__":
    raise SystemExit(main())
```

<details><summary>Respuesta</summary>

Distingue **ejecutar** el archivo de **importarlo** desde otro script para
reutilizar sus funciones. Sin ese `if`, el simple hecho de importarlo crearía el
rol sin que nadie lo pidiera.

Y `raise SystemExit(...)` es lo que convierte el `0` o el `1` que devuelve
`main()` en el código de salida real que ve PowerShell.
</details>

**B7.** ¿De dónde saca el script las credenciales? ¿Hay alguna clave dentro?

<details><summary>Respuesta</summary>

De las **ADC**, las mismas que usa Terraform, que `google.auth.default()` busca
en `%APPDATA%\gcloud\application_default_credentials.json`.

**No hay ninguna clave en el código.** Es la buena práctica que el ejercicio 15
enseña a respetar: las credenciales no viajan al repo.
</details>

**B8.** `discovery.build("iam", "v1", ...)` — ¿qué tiene de particular, y qué
precio se paga?

<details><summary>Respuesta</summary>

La librería **no lleva escritas** las órdenes de IAM: se descarga la descripción
del servicio y las fabrica en tiempo de ejecución.

- **Ventaja:** una sola librería sirve para todas las APIs de Google.
- **Precio:** como las órdenes no existen hasta que el script corre, VS Code no
  puede avisarte si escribes una mal. Sin autocompletado, y el fallo aparece al
  ejecutar.
</details>

---

## Bloque C — La red (12 preguntas)

**C1.** ¿Qué diferencia hay entre una VPC en modo **auto** y una en modo
**custom**?

<details><summary>Respuesta</summary>

La **auto** nace con una subred en cada región del mundo, con rangos que eligió
Google. La **custom** nace **vacía**: tú decides cuántas subredes hay, dónde y
con qué rango.

En este proyecto, la `default` tiene **42 subredes**; `vpc-lab` tiene **1**.
</details>

**C2.** ⚠ Esas 42 subredes no cuestan dinero. Entonces, ¿qué problema hay?

<details><summary>Respuesta</summary>

Tres:

1. **Los rangos los eligió Google.** El día que conectes esta red con otra, es
   fácil que **choquen**. Y el rango de una subred no se puede cambiar después.
2. **Superficie que no controlas.** Cada subred es un sitio donde alguien puede
   arrancar una máquina.
3. **No es reproducible.** Si Google añade una región, tu red crece sola.
</details>

**C3.** ⚠ ¿Qué línea del `network.tf` es el ejercicio entero, y qué pasaría con
el otro valor?

<details><summary>Respuesta</summary>

```hcl
auto_create_subnetworks = false
```

Con `true` —el valor por defecto— tendrías las 42 subredes de Google en vez de la
tuya. Es la única línea que separa una red custom de una auto.
</details>

**C4.** ⚠ ¿Qué es global y qué es regional en una VPC?

<details><summary>Respuesta</summary>

| Objeto | Alcance |
|---|---|
| la **red** | **global** — no vive en ninguna región |
| las **subredes** | **regionales** — reparten direcciones a las VMs |
| las reglas de **firewall** | globales, cuelgan de la red |
| las **rutas** | globales, cuelgan de la red |

Consecuencia: una regla de firewall afecta a **todas** las subredes de esa red. Y
dos máquinas en continentes distintos, dentro de la misma red, se hablan por
dirección interna sin salir a internet.
</details>

**C5.** `10.10.0.0/24`. ¿Cuántas direcciones son y cuántas puedes usar?

<details><summary>Respuesta</summary>

El `/24` dice que 24 de los 32 bits están fijos. Quedan 8 libres → 2⁸ = **256
direcciones**, de la `.0` a la `.255`.

Usables: **252**. Google se queda con cuatro:

| Dirección | Para qué |
|---|---|
| `10.10.0.0` | identifica la red |
| `10.10.0.1` | la puerta de salida, el gateway |
| `10.10.0.254` | reservada para uso futuro |
| `10.10.0.255` | difusión, el broadcast |
</details>

**C6.** ⚠ ¿Qué red es más grande, un `/16` o un `/24`?

<details><summary>Respuesta</summary>

El **`/16`**, y por mucho: 65.536 direcciones frente a 256.

**Cuanto más grande el número, más pequeña la red**, porque el número dice
cuántos bits están *fijos*. Es al revés de lo que parece, y es un error clásico.
</details>

**C7.** Te quedas corto de direcciones en la subred. ¿Tiene arreglo?

<details><summary>Respuesta</summary>

Sí, hacia arriba: **el rango se puede agrandar, nunca encoger**. Hay un comando
para ampliarlo. Si te pasaste, en cambio, hay que crear otra subred.

Por eso se empieza pequeño.
</details>

**C8.** ⚠ Al crear la red, Google añadió dos rutas que no pediste. ¿Cuáles y para
qué sirve cada una?

<details><summary>Respuesta</summary>

```
0.0.0.0/0       default-internet-gateway   prioridad 1000
10.10.0.0/24    (dentro de la red)         prioridad 0
```

- La de la **subred** dice "lo que vaya a `10.10.0.0/24` se queda dentro".
  Prioridad `0`, la máxima. Aparece y desaparece con la subred.
- La de **internet** dice "todo lo demás, a la salida". `0.0.0.0/0` significa
  *cualquier destino*, y por eso su prioridad es baja: es la última opción,
  cuando ninguna otra ruta encaja.

Se puede evitar la segunda con `delete_default_routes_on_create` si quieres una
red sin salida a internet.
</details>

**C9.** ⚠ ¿Cuántas reglas de firewall tiene `vpc-lab` recién creada, y qué
implica?

<details><summary>Respuesta</summary>

**Cero.** La `default` trae cuatro (`default-allow-icmp`, `default-allow-internal`,
`default-allow-rdp`, `default-allow-ssh`); una red custom no trae ninguna.

| Tráfico | Qué pasa |
|---|---|
| **entrante** | **todo bloqueado**, incluido el SSH |
| **saliente** | todo permitido |

No es un descuido: es el diseño. Una VM arrancada hoy en `vpc-lab` no la podrías
ni tocar. De eso va la etapa 5.
</details>

**C10.** En el `.tf` aparecen `vpc-lab` y `vpc_lab`. ¿Se contradicen?

<details><summary>Respuesta</summary>

No, son dos cosas distintas:

- **`vpc-lab`** — el `name`, el nombre que viaja a Google. Con guion.
- **`vpc_lab`** — la **etiqueta local** de Terraform, la que usas para
  referenciar el recurso desde otros bloques. Con guion bajo, y solo existe
  dentro de los `.tf`.

Es la norma del laboratorio, y aquí se ven las dos en el mismo archivo.
</details>

**C11.** ⚠ ¿Por qué la subred no necesita un `depends_on` que apunte a la red?

<details><summary>Respuesta</summary>

Porque ya la **referencia**:

```hcl
network = google_compute_network.vpc_lab.id
```

No pone `"vpc-lab"` en texto, apunta al recurso. Terraform deduce solo el orden.
Por eso en el `plan` ese campo salía como `(known after apply)`: el identificador
aún no existía.

El `depends_on` que sí hay, el de las APIs, es otra cosa — ahí no hay ninguna
referencia que Terraform pueda seguir.
</details>

**C12.** ¿Cuáles son las dos comprobaciones de la etapa y qué deben devolver?

<details><summary>Respuesta</summary>

```powershell
gcloud compute networks describe vpc-lab --format="value(x_gcloud_subnet_mode)"
gcloud compute networks subnets list --filter="network:vpc-lab"
```

`CUSTOM` (no `AUTO`), y **una sola** subred: `subred-us-east1`, `us-east1`,
`10.10.0.0/24`.
</details>

---

## Bloque D — Transversales (5 preguntas)

**D1.** ⚠ Etapas 2, 3 y 4. ¿Qué idea las atraviesa?

<details><summary>Respuesta</summary>

**Dar lo mínimo, y solo lo que pediste.**

| Etapa | Lo cómodo | Lo que hiciste |
|---|---|---|
| 2 | dejar el `roles/editor` de fábrica | `roles/compute.viewer`, y solo ese |
| 3 | `compute.instanceAdmin.v1`, que además borra | dos permisos, ni uno más |
| 4 | la red `default` con sus 42 subredes | una red vacía y una subred tuya |

En las tres, lo que viene de fábrica es más ancho de lo necesario.
</details>

**D2.** El `plan` de la etapa 4 empezó con quince líneas de `Refreshing state...`
y luego no mencionó ninguna API. ¿Qué estaba pasando?

<details><summary>Respuesta</summary>

Es el paso previo del `plan`: Terraform le pregunta a GCP cómo está **cada
recurso que ya tiene en el estado**, para detectar si alguien lo tocó a mano
desde la consola.

Como ninguna de las 15 APIs había cambiado, no apareció en la lista de acciones.
Son las tres fuentes de verdad de la etapa 1 comparándose en silencio.
</details>

**D3.** ⚠ ¿Qué avisa esta nota al final del `plan`, y cuándo importa de verdad?

> *You didn't use the `-out` option, so Terraform can't guarantee to take exactly
> these actions if you run "terraform apply" now.*

<details><summary>Respuesta</summary>

Que el plan que acabas de leer es **una foto**, y entre esa foto y el `apply`
puede haber cambiado algo en GCP. No es un error.

En un laboratorio de una sola persona da igual: el `apply` recalcula y te lo
vuelve a enseñar antes de pedir el `yes`. Importa en equipo, y ahí lo formal es:

```powershell
terraform -chdir=terraform plan -out=tfplan
terraform -chdir=terraform apply tfplan
```

Así se aplica exactamente lo revisado. Es lo que hacen las tuberías de CI.
</details>

**D4.** ¿Qué está mal en cada línea?

```powershell
terraform -chdir=terraform destroy -target=google_compute_network.vpc_lab
python custom_role.py
gcloud iam roles describe vm-start-stop --project=gcp-lab-jona-01
```

<details><summary>Respuesta</summary>

1. El `-target` **sin comillas**: PowerShell parte en el punto y se come
   `vpc_lab`. Va entrecomillado entero:
   `'-target=google_compute_network.vpc_lab'`.
2. Ruta mal: el script está en `scripts/`. Desde la raíz es
   `python scripts/custom_role.py`.
3. El rol se llama `vm_start_stop`, con **guion bajo**. Los roles personalizados
   no admiten guion normal.
</details>

**D5.** Coste de las etapas 3 y 4. ¿Hay que apagar algo al cerrar la sesión?

<details><summary>Respuesta</summary>

**Cero y cero.** Un rol personalizado no se factura, y una VPC con su subred
tampoco. No hay nada que apagar.

Lo que cuesta dinero son las **direcciones IP externas** y el **tráfico de
salida**, y eso empieza en el módulo 2 con la primera VM. A partir de ahí sí toca
el checklist de apagado en cada sesión.
</details>

---

## Puntuación

| Aciertos | Lectura |
|---|---|
| 31–34 | Etapas cerradas. A por la 5: firewall y network tags. |
| 24–30 | Bien. Repasa las ⚠ que hayas fallado. |
| 17–23 | Relee el bloque donde se concentren los fallos antes de seguir. |
| < 17 | Vuelve a los dos apuntes; el cuestionario después cunde más. |

Las ⚠ son quince: A2, A4, A7, B2, B4, B6, C2, C3, C4, C6, C8, C9, C11, D1 y D3.
Si fallas más de cuatro, el problema no es de memoria sino de modelo mental.
