# Cuestionario — etapas 7 y 8

Autoevaluación sobre [el MIG](apuntes-etapa-07-mig.md) y
[los snapshots](apuntes-etapa-08-snapshots.md).

**Cómo usarlo:** responde antes de desplegar la respuesta. Están plegadas en
`<details>`, así que no se ven de reojo.

- 33 preguntas, 5 bloques.
- Las ⚠ son las que distinguen entender de memorizar.
- Tabla de puntuación al final.

Viene detrás de [las etapas 5 y 6](cuestionario-etapas-05-06.md).

---

## Bloque A — Mascotas, ganado y la plantilla (7 preguntas)

**A1.** Las instancias se llaman `app-p144` y `app-s458`. ¿Por qué no tienen un
nombre elegido?

<details><summary>Respuesta</summary>

Porque son **ganado, no mascotas**. El `base_instance_name = "app"` da el prefijo
y GCP añade un sufijo aleatorio.

Si te importara el nombre de cada una, seguirías pensando en máquinas concretas —
y el punto del ejercicio es dejar de hacerlo. Lo que se declara es *cuántas* y
*cómo son*, no *quiénes son*.
</details>

**A2.** ⚠ ¿Por qué el MIG solo funciona **gracias** a la etapa 6?

<details><summary>Respuesta</summary>

Porque el grupo repone máquinas, y una máquina repuesta nace **vacía**. Lo que la
convierte en un servidor web útil es el **startup script**, que se ejecuta solo al
arrancar.

Sin *bootstrapping* automático, el auto-healing te daría una VM en blanco y
tendrías que entrar a instalar nginx a mano cada vez. El ganado solo tiene sentido
si nace ya criado.
</details>

**A3.** ¿Qué es un instance template y qué propiedad lo define?

<details><summary>Respuesta</summary>

Es el **molde**: describe cómo es *una* máquina (tipo, disco, imagen, red, tags,
metadata) y el grupo fabrica copias idénticas a partir de él.

La propiedad que lo define es que es **inmutable**: no se edita, se sustituye.
</details>

**A4.** ⚠ ¿Por qué `name_prefix` y no `name`? ¿Y qué tiene que ver con
`create_before_destroy`?

<details><summary>Respuesta</summary>

Van juntos y los dos salen de la inmutabilidad:

- Como la plantilla no se puede editar, **cualquier cambio la reemplaza**. Con
  `name` fijo, la nueva chocaría con el nombre de la vieja. `name_prefix` deja que
  cada versión tenga su propio nombre.
- Terraform **no puede borrar la plantilla vieja mientras el grupo la usa**. Con
  `create_before_destroy = true` crea primero la nueva y borra la anterior después.

Sin el par, cualquier cambio en la plantilla acaba en error de dependencia.
</details>

**A5.** La plantilla lleva `tags = ["web-server"]`. ¿Qué pasaría si se olvidara?

<details><summary>Respuesta</summary>

Dos cosas, y la segunda es la grave:

1. No entrarías por SSH: `ssh-custom` solo aplica a ese tag.
2. **Los sondeos de salud tampoco llegarían** (van al puerto 80, que abre
   `http-custom`, también por tag). El grupo daría las máquinas por enfermas y las
   mataría **en bucle**, creando y destruyendo sin parar.

Un tag olvidado en la etapa 6 era una molestia; aquí es una máquina de quemar
dinero.
</details>

**A6.** ⚠ El `network_interface` lleva un `access_config {}` vacío. ¿Para qué, si
nadie va a visitar estas máquinas por su IP?

<details><summary>Respuesta</summary>

Un bloque vacío significa **IP externa efímera**, y hace falta para la **salida**,
no para la entrada: sin ruta a internet, el `apt-get` del startup script no puede
descargar nginx. La máquina nunca pasaría el health check y el grupo la recrearía
sin parar.

La alternativa correcta en un proyecto real es un **Cloud NAT**: salida a internet
sin IP pública en cada VM. Aquí no se monta porque son más recursos y más coste
para el laboratorio.
</details>

**A7.** La plantilla usa `file("${path.module}/../compute-engine/startup-script.sh")`.
¿Qué ventaja tiene sobre copiar el script dentro del `.tf`?

<details><summary>Respuesta</summary>

**Un solo archivo, un solo sitio donde corregirlo.** Es literalmente el mismo
script que la etapa 6 pasó por `--metadata-from-file`.

Si estuviera copiado, el día que arregles un bug tendrías que acordarte de los dos
sitios — y es el tipo de duplicación que ya se evitó con el `project_id` en
`terraform.tfvars`.
</details>

---

## Bloque B — El grupo regional (6 preguntas)

**B1.** ¿Qué diferencia hay entre un MIG zonal y uno regional? ¿Cuál es este?

<details><summary>Respuesta</summary>

- **Zonal:** todas las instancias en una zona. Si la zona cae, cae el grupo entero.
- **Regional:** las reparte entre las zonas de la región.

Este es **regional**: `google_compute_region_instance_group_manager`. Es la
respuesta al problema que dejó abierto la etapa 6, donde la VM era zonal y no
había nada dentro de ella capaz de arreglarlo.
</details>

**B2.** Tus dos instancias están en `us-east1-c` y `us-east1-d`. ¿Quién decidió eso?

<details><summary>Respuesta</summary>

**El grupo, solo.** En el `mig.tf` no hay ninguna zona escrita: solo
`region = var.region`.

Y fíjate en que ninguna cayó en `us-east1-b`, la zona de la VM de la etapa 6. El
reparto no lo controlas tú, y ese es el punto.
</details>

**B3.** ⚠ ¿Cuál es la línea del `mig.tf` que cuesta dinero?

<details><summary>Respuesta</summary>

```hcl
target_size = 2
```

Todo lo demás —la plantilla, el health check, el propio grupo— es **gratis**. Son
definiciones. Lo que se factura son las instancias que el número manda levantar.

De ahí que bajarlo a `0` sea una forma válida de apagar sin destruir nada.
</details>

**B4.** ⚠ Quieres ahorrar y borras las dos instancias a mano. ¿Qué pasa?

<details><summary>Respuesta</summary>

Que **vuelven en un par de minutos**. Para el grupo, dos instancias borradas son
dos instancias que faltan respecto a `target_size = 2`.

Es el error clásico de este ejercicio. Las dos formas que sí funcionan son bajar
`target_size` a 0, o destruir el grupo.
</details>

**B5.** Tus dos instancias se crearon con 7 minutos y 43 segundos de diferencia.
¿Qué te dice eso?

<details><summary>Respuesta</summary>

Que **una fue repuesta**. Si el grupo hubiera levantado las dos al aplicar,
tendrían marcas de tiempo casi idénticas.

Esa diferencia es la huella del auto-healing funcionando, y queda registrada en
los metadatos de la instancia aunque no estuvieras mirando.
</details>

**B6.** ¿Para qué sirve `base_instance_name`?

<details><summary>Respuesta</summary>

Para dar el **prefijo** de los nombres generados: con `"app"` salen `app-p144`,
`app-s458`, etc.

No eliges el nombre completo, solo la familia. Es útil para reconocer de un vistazo
a qué grupo pertenece una instancia cuando hay varios.
</details>

---

## Bloque C — Health check y auto-healing (7 preguntas)

**C1.** ⚠ Sin health check, el grupo ya repone máquinas borradas. ¿Qué añade
entonces el sondeo?

<details><summary>Respuesta</summary>

Sin health check el grupo solo sabe **contar**: mira cuántas instancias existen.

Con health check además **pregunta** si cada una sigue sirviendo, y sustituye a la
que está **viva pero rota**: nginx caído, proceso colgado, disco lleno. Son dos
definiciones distintas de "funciona", y la segunda es la que importa en
producción.
</details>

**C2.** ¿Qué significan `healthy_threshold = 2` y `unhealthy_threshold = 3`?

<details><summary>Respuesta</summary>

- **2 respuestas buenas seguidas** → la máquina se considera sana.
- **3 fallos seguidos** → enferma, y el grupo la sustituye.

Que hagan falta varios intentos evita reaccionar a un fallo puntual de red. Y que
el umbral de enfermar sea más alto que el de sanar es deliberado: más caro
equivocarse matando que esperando.
</details>

**C3.** ⚠ ¿Qué es `initial_delay_sec = 300` y qué pasa si se queda corto?

<details><summary>Respuesta</summary>

Es el margen que el grupo da a una instancia **recién nacida** antes de empezar a
juzgarla.

Si es demasiado corto, el plazo expira mientras el startup script todavía está
haciendo `apt-get update` e instalando nginx. El grupo la declara enferma y **la
mata mientras arrancaba bien**, crea otra, y entra en un bucle de crear-matar que
cuesta dinero y no da ninguna pista de por qué.

300 segundos es generoso a propósito.
</details>

**C4.** ¿Desde dónde llegan los sondeos y por qué pasan el firewall?

<details><summary>Respuesta</summary>

Desde `130.211.0.0/22` y `35.191.0.0/16`, rangos fijos de la infraestructura de
Google.

Pasan porque `http-custom` abre `tcp:80` desde `0.0.0.0/0` al tag `web-server`. O
sea: **pasan de rebote**, porque la regla es más ancha de lo necesario.
</details>

**C5.** ⚠ ¿Cómo se escribiría eso bien en un proyecto serio?

<details><summary>Respuesta</summary>

Con una regla dedicada solo a los sondeos:

```powershell
gcloud compute firewall-rules create allow-health-checks --network=vpc-lab --action=allow --direction=ingress --rules=tcp:80 --source-ranges=130.211.0.0/22,35.191.0.0/16 --target-tags=web-server
```

Así el puerto 80 puede quedar cerrado al público y el auto-healing sigue
funcionando. Es la aplicación del principio de menor privilegio de la etapa 3, esta
vez a la red.
</details>

**C6.** El health check es `http_health_check` al puerto 80 con `request_path = "/"`.
¿Qué está comprobando de verdad?

<details><summary>Respuesta</summary>

Que **nginx responde HTTP en la raíz**. No que la máquina esté encendida: eso ya lo
sabe el grupo por otras vías.

En una aplicación real se apunta a un endpoint propio (`/healthz`) que compruebe lo
que de verdad importa: que la base de datos contesta, que las dependencias están
arriba. Un `/` que devuelve 200 puede convivir con una app rota por dentro.
</details>

**C7.** `list-instances` te devuelve la columna `HEALTH_STATE` vacía. ¿Significa
que el auto-healing no funciona?

<details><summary>Respuesta</summary>

No necesariamente, y hay que comprobarlo en vez de suponerlo. En este laboratorio:

- `describe` muestra la política con su health check y su `initialDelaySec: 300`,
  así que **está configurada**.
- El grupo está `isStable: true` y las instancias llevan semanas vivas, así que
  **nadie las está matando**.

La columna vacía es un cabo suelto del listado, no una avería. Lo que nunca hay que
hacer es dar por bueno un `HEALTHY` que no has visto.
</details>

---

## Bloque D — Snapshots (8 preguntas)

**D1.** ⚠ Un disco es zonal y un snapshot es global. ¿Qué te permite hacer esa
diferencia?

<details><summary>Respuesta</summary>

**Mover datos entre regiones**, que es lo que el vídeo llama "cambiar una máquina
de continente":

```
disco en us-east1  →  snapshot (global)  →  disco nuevo en europe-west1
```

No se mueve nada: se fotografía el disco y se revela la foto en otro sitio.

La señal de ese cambio de alcance está en los comandos: `disks list` necesita zona,
`snapshots list` no.
</details>

**D2.** ¿Por qué se puede sacar un snapshot sin apagar la máquina?

<details><summary>Respuesta</summary>

Porque **el disco no está dentro de la máquina**: es almacenamiento en red
conectado a ella. GCP puede leerlo por su cuenta.

De la misma propiedad sale que el disco **sobreviva** a la instancia.
</details>

**D3.** ⚠ ¿Qué significa que los snapshots sean incrementales, y qué **no**
significa?

<details><summary>Respuesta</summary>

Significa que el primero copia los bloques escritos del disco y los siguientes
solo guardan **lo que cambió** desde el anterior.

Lo que **no** significa: que dependas de la cadena para restaurar. Cada snapshot se
restaura **por sí solo**. Por dentro comparten bloques; por fuera cada uno es una
copia completa. Es la diferencia con los backups incrementales clásicos, donde
necesitas el completo más todos los incrementos.
</details>

**D4.** Tu primer snapshot ocupó 677 MB y el segundo 423 MB, solo un 37% menos.
¿Por qué no fue "una fracción"?

<details><summary>Respuesta</summary>

Porque entre los dos pasaron **26 días con la VM encendida**. Esos 423 MB son los
bloques que el sistema tocó: logs, actualizaciones, caché de apt.

La lección: un snapshot incremental no mide el tiempo transcurrido, mide **cuánto
ha cambiado el disco**. Dos snapshots seguidos en la misma sesión dan una
diferencia enorme; dos separados por un mes de uso, no.
</details>

**D5.** ⚠ El disco es de 10 GB y el snapshot ocupa 677 MB. ¿Dónde están los otros
9 GB?

<details><summary>Respuesta</summary>

No existen. Un disco de 10 GB recién instalado está **casi vacío**: el snapshot
copia solo los **bloques escritos** (el sistema operativo y nginx), y además los
comprime.

Se factura por lo que ocupa, no por el tamaño del disco.
</details>

**D6.** En el script, ¿por qué `source_disk` va por `self_link` y no por el nombre
del disco?

<details><summary>Respuesta</summary>

Porque el `self_link` es la URL completa:

```
https://www.googleapis.com/compute/v1/projects/gcp-lab-jona-01/zones/us-east1-c/disks/app-p144
```

El snapshot vive fuera de la zona, así que necesita la dirección exacta de su
origen. Un nombre suelto sería ambiguo: podría haber un `app-p144` en cada zona.
</details>

**D7.** ⚠ ¿Por qué el nombre del snapshot lleva la fecha y la hora dentro?

<details><summary>Respuesta</summary>

Porque los nombres de snapshot son **únicos y globales**. Con un nombre fijo, la
segunda ejecución fallaría con un **409 Conflict** — y la segunda ejecución es
justo la medida del ejercicio.

Con la marca de tiempo, el script se puede lanzar las veces que haga falta.
</details>

**D8.** ⚠ Borras el primer snapshot para ahorrar. ¿Se libera todo su espacio?
¿Pierdes datos?

<details><summary>Respuesta</summary>

**No pierdes datos nunca**, y **no se libera todo el espacio**.

Si el segundo snapshot depende de bloques del primero, GCP los mueve al segundo
antes de borrar. El resultado es que el que queda crece y la factura baja menos de
lo esperado.

Y el aviso de fondo: **los snapshots no caducan solos**. Se quedan para siempre si
nadie los borra, y son una de las líneas que más aparece en facturas que nadie
entiende. Lo correcto en producción es una *resource policy* con retención — la
misma idea que la `lifecycle_rule` del bucket de la etapa 14.
</details>

---

## Bloque E — Coste y transversales (5 preguntas)

**E1.** ⚠ ¿Qué se está pagando exactamente con el MIG arriba?

<details><summary>Respuesta</summary>

| Concepto | Mientras... |
|---|---|
| 2 × vCPU y RAM `e2-micro` | estén encendidas |
| 2 × disco de 10 GB | existan |
| 2 × IP externa efímera | estén asignadas a instancias encendidas |

Del orden de 12-14 USD al mes. Y el nivel gratuito cubre **un** `e2-micro` por
cuenta de facturación, que además está compartida con el proyecto del curso: en la
práctica no cubre nada.
</details>

**E2.** ⚠ El `mig.tf` tiene el aviso de coste en un recuadro y el `plan.md` tiene
un checklist de apagado. Aun así el grupo estuvo 26 días encendido. ¿Qué se
aprende de eso?

<details><summary>Respuesta</summary>

Que **el aviso escrito no apaga nada**. El apagado hay que hacerlo **el mismo
día**, al cerrar la sesión, porque después nada te lo recuerda: GCP no avisa, el
grupo no caduca y la factura llega a fin de mes.

Es la única parte del laboratorio donde el error no es técnico sino de hábito.
</details>

**E3.** Etapas 6, 7 y 8. ¿Qué hilo las cose?

<details><summary>Respuesta</summary>

**La máquina deja de importar, y lo que importa se mueve de sitio:**

| Etapa | Qué dice |
|---|---|
| 6 | la máquina **nace configurada** (startup script) |
| 7 | si nace configurada, **da igual que muera**: el grupo repone |
| 8 | lo único que **no** se puede reponer son los **datos** → snapshots |

Una VM se rehace con el comando de la etapa 6. Su disco, no. Ahí está el orden.
</details>

**E4.** El ejercicio 8 necesitaba un disco vivo. ¿De dónde salió?

<details><summary>Respuesta</summary>

De una instancia del MIG (`app-p144`, en `us-east1-c`), porque la VM de la etapa 6
ya se había destruido.

Detalle práctico: las instancias del grupo llevan **sufijo aleatorio**, así que si
el grupo repone alguna, el nombre del disco cambia. Hay que sacarlo de
`gcloud compute disks list` en el momento, no de los apuntes.
</details>

**E5.** ¿Cuáles son las dos formas correctas de apagar el MIG, y cuándo usar cada
una?

<details><summary>Respuesta</summary>

```powershell
# a) target_size = 0 en mig.tf, y aplicar. Conserva grupo y plantilla (gratis).
terraform -chdir=terraform apply

# b) destruir el grupo.
terraform -chdir=terraform destroy '-target=google_compute_region_instance_group_manager.app_mig'
```

- **(a)** si vuelves mañana y quieres el grupo listo para subir a 2 otra vez.
- **(b)** si cierras el laboratorio; rehacerlo es un `apply`.

Y las comillas del `-target` no son opcionales en PowerShell: sin ellas parte el
argumento en el punto.
</details>

---

## Puntuación

| Aciertos | Lectura |
|---|---|
| 30–33 | Módulo 2 cerrado. El salto a contenedores te va a parecer natural. |
| 23–29 | Bien. Repasa las ⚠ que hayas fallado. |
| 16–22 | Relee el bloque donde se concentren los fallos antes de seguir. |
| < 16 | Vuelve a los dos apuntes; el cuestionario después cunde más. |

Las ⚠ son catorce: A2, A4, A6, B3, B4, C1, C3, C5, D1, D3, D5, D7, D8, E1 y E2. Si
fallas más de tres, el problema no es de memoria sino de modelo mental.

Y la que no es una pregunta: **el MIG sigue encendido mientras lees esto**, si no
lo has apagado ya.
