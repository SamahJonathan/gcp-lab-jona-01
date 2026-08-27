# Cuestionario — etapas 5 y 6

Autoevaluación sobre [el firewall y los network tags](apuntes-etapa-05-firewall-network-tags.md)
y [la VM con startup script](apuntes-etapa-06-vm-startup-script.md).

**Cómo usarlo:** responde antes de desplegar la respuesta. Están plegadas en
`<details>`, así que no se ven de reojo.

- 35 preguntas, 5 bloques.
- Las ⚠ son las que distinguen entender de memorizar.
- Tabla de puntuación al final.

Viene detrás de [las etapas 3 y 4](cuestionario-etapas-03-04.md).

---

## Bloque A — El firewall (8 preguntas)

**A1.** `vpc-lab` no tiene ninguna regla escrita. ¿Qué pasa entonces con el
tráfico, y por qué?

<details><summary>Respuesta</summary>

Toda VPC tiene dos reglas **implícitas**, que no salen en los listados y no se
pueden borrar:

| Dirección | Acción | Prioridad |
|---|---|---|
| ingress | **deny** | 65535 |
| egress | **allow** | 65535 |

Así que entrante todo bloqueado, saliente todo permitido. Prioridad 65535 es la
más baja posible: son la última palabra, cuando ninguna regla tuya ha encajado.
</details>

**A2.** ⚠ ¿Por qué se dice que el firewall de GCP "se escribe en positivo"?

<details><summary>Respuesta</summary>

Porque la regla implícita ya prohíbe todo lo entrante. No listas lo que quieres
bloquear —eso ya está hecho—, listas **lo poco que quieres permitir**.

Es lo contrario del modelo mental de "voy a cerrar los puertos peligrosos": aquí
los puertos nacen todos cerrados y tú abres agujeros de uno en uno.
</details>

**A3.** El firewall es **stateful**. ¿Qué significa y qué te ahorra?

<details><summary>Respuesta</summary>

Que recuerda las conexiones que ha dejado pasar, y **la respuesta a una conexión
permitida se permite sola**, sin mirar ninguna regla.

Te ahorra la regla de vuelta: para tener SSH funcionando basta **una regla de
entrada**. No hay que abrir nada de salida ni "los puertos altos" de retorno.
</details>

**A4.** ⚠ Si el firewall es stateful y solo escribiste una regla de entrada,
¿cómo consigue la VM hacer `apt-get update`, que va hacia fuera?

<details><summary>Respuesta</summary>

Por la regla implícita de **egress allow**, no por la de entrada.

Lo stateful cubre la **respuesta** a una conexión que ya pasó. Cuando es la VM
quien **inicia** la conexión, eso es tráfico saliente nuevo y lo autoriza la
regla de salida, que por defecto permite todo.

Son dos mecanismos distintos y es fácil mezclarlos.
</details>

**A5.** ¿Qué prioridad tiene `ssh-custom` y qué significa el número?

<details><summary>Respuesta</summary>

**1000**, el valor por defecto, porque no se puso ninguno.

El rango es `0`–`65535` y **cuanto más bajo, más manda**. Se evalúan de menor a
mayor y la primera que encaja decide. Si dos empatan en prioridad, **gana el
`deny`**.

1000 por defecto deja sitio a los dos lados: un bloqueo con 500 tapa esta regla,
y una emergencia con 100 tapa aquella.
</details>

**A6.** ⚠ En una regla ingress, ¿qué diferencia hay entre `--source-ranges` y
`--target-tags`?

<details><summary>Respuesta</summary>

- **`--source-ranges`** = **de dónde viene** el tráfico. `0.0.0.0/0` es "de
  cualquier sitio de internet".
- **`--target-tags`** = **a qué llega**, qué máquinas protege la regla. Solo las
  que lleven esa etiqueta.

Una regla ingress necesita las dos: origen y destino. Es la confusión más común
de todo el ejercicio.
</details>

**A7.** ⚠ La regla abre `tcp:22` desde `0.0.0.0/0`. ¿Qué tiene eso de malo y
cuáles son las dos alternativas serias?

<details><summary>Respuesta</summary>

Es **abrir el SSH a todo internet**, el hallazgo número uno de cualquier
auditoría: hay bots barriendo el rango de GCP buscando exactamente eso.

```powershell
--source-ranges=TU.IP.PUBLICA/32     # solo desde tu casa
--source-ranges=35.235.240.0/20      # solo por IAP TCP forwarding
```

El segundo es el rango fijo del túnel de Google. Con él la VM ni siquiera
necesita IP externa, y quien decide si pasas es **IAM**, no una lista de
direcciones.
</details>

**A8.** ¿Una regla de firewall se cuelga de la red o de la subred? ¿Cuesta dinero?

<details><summary>Respuesta</summary>

De la **red**. Es un objeto global, como se vio en la etapa 4, y aplica a todas
las subredes que tenga esa red.

Coste **0**. Lo único que se factura es el **logging** de reglas
(`--enable-logging`), porque va a Cloud Logging y eso son bytes guardados.
</details>

---

## Bloque B — Network tags (7 preguntas)

**B1.** ¿Qué problema resuelven los network tags?

<details><summary>Respuesta</summary>

Escribir las reglas por dirección IP no escala: con 100 servidores web y 50 bases
de datos harían falta 150 reglas, y una más por cada máquina nueva.

Con etiquetas la regla apunta a `web-server` en vez de a IPs concretas: se
escribe **una vez** y las máquinas entran y salen de su alcance solo con ponerse
o quitarse el tag.
</details>

**B2.** Creas hoy una VM nueva con el tag `web-server`. ¿Hay que tocar la regla?

<details><summary>Respuesta</summary>

**No.** La regla ya la cubre desde el primer segundo. Ese es todo el punto.

Y al revés: quitarle el tag a una máquina la saca del alcance de la regla, en
caliente y sin reiniciar nada.

```powershell
gcloud compute instances remove-tags servidor-web-1 --tags=web-server --zone=us-east1-b
```
</details>

**B3.** ⚠ ¿Por qué un network tag **no** es un mecanismo de seguridad de verdad?

<details><summary>Respuesta</summary>

Porque es **solo un texto**, no una credencial. No hay nada que verificar.

Quien tenga `compute.instances.setTags` sobre una VM puede ponerle `web-server` y
con eso se ha metido dentro del alcance de tu regla. Es el mismo tipo de problema
que los permisos peligrosos de la etapa 3.
</details>

**B4.** ⚠ ¿Cuál es la alternativa robusta a las etiquetas como destino de una
regla, y por qué es mejor?

<details><summary>Respuesta</summary>

Apuntar a la **service account** con la que corre la VM:

```powershell
--target-service-accounts=deployer-sa@gcp-lab-jona-01.iam.gserviceaccount.com
```

Es mejor porque cambiar la identidad de una VM exige `iam.serviceAccountUser`
sobre esa cuenta, mucho más difícil de conseguir que escribir un texto. Enlaza
directo con la etapa 2.

**No se pueden mezclar** tags y service accounts en la misma regla.
</details>

**B5.** ¿Qué caracteres admite un network tag?

<details><summary>Respuesta</summary>

Minúsculas, números y **guion**; hasta 63 caracteres; máximo 64 etiquetas por
instancia.

Coincide con la convención del laboratorio, así que `web-server` va con guion —a
diferencia del rol `vm_start_stop` de la etapa 3, que era la excepción.
</details>

**B6.** ¿Qué devuelve la comprobación de la etapa y qué debe salir?

<details><summary>Respuesta</summary>

```powershell
gcloud compute firewall-rules describe ssh-custom --format="value(targetTags,allowed,direction)"
```

Esperado: `web-server`, `tcp:22`, `INGRESS`.
</details>

**B7.** Sin mirar: escribe el comando que crea la regla.

<details><summary>Respuesta</summary>

```powershell
gcloud compute firewall-rules create ssh-custom --network=vpc-lab --action=allow --direction=ingress --rules=tcp:22 --source-ranges=0.0.0.0/0 --target-tags=web-server
```

En **una sola línea**: el `\` de continuación del vídeo es de bash y PowerShell
no lo entiende.
</details>

---

## Bloque C — La máquina virtual (8 preguntas)

**C1.** ⚠ Ordena por alcance: la VM, la subred y la red. ¿Qué consecuencia tiene?

<details><summary>Respuesta</summary>

| Objeto | Alcance |
|---|---|
| `vpc-lab` | **global** |
| `subred-us-east1` | **regional** (`us-east1`) |
| `servidor-web-1` | **zonal** (`us-east1-b`) |

Consecuencia: si la zona `us-east1-b` se cae, tu máquina se cae con ella y no hay
nada dentro de la VM que lo evite. La resiliencia se arregla con **varias**
máquinas en **varias** zonas — el MIG de la etapa 7.

Y una restricción práctica: la zona de la VM tiene que estar en la región de su
subred.
</details>

**C2.** ¿Qué pasa si se te olvida el `--subnet` en el comando de creación?

<details><summary>Respuesta</summary>

La VM va a la red **`default`**, la de modo auto con sus 42 subredes que tanto
trabajo costó no usar en la etapa 4.

Y peor: allí la regla `ssh-custom` no existe —vive en `vpc-lab`—, pero sí existen
las cuatro reglas de fábrica de la `default`, así que la máquina quedaría
expuesta por reglas que tú no escribiste.
</details>

**C3.** ⚠ ¿Qué pasa si se te olvida el `--tags=web-server`?

<details><summary>Respuesta</summary>

La máquina arranca perfectamente y **no puedes entrar**.

`ssh-custom` solo protege a las máquinas con esa etiqueta. Sin tag, para esa VM
manda la implícita de ingress deny y el SSH muere ahí.

Tiene arreglo en caliente, sin reiniciar:

```powershell
gcloud compute instances add-tags servidor-web-1 --tags=web-server --zone=us-east1-b
```
</details>

**C4.** ¿Qué es un `e2-micro`?

<details><summary>Respuesta</summary>

El tipo de máquina: **2 vCPU compartidas y 1 GB de RAM**. Lo mínimo razonable, de
sobra para servir una página de nginx.

El tipo de máquina se puede cambiar después, pero con la VM **parada**.
</details>

**C5.** ⚠ El comando no lleva `--image-family`. ¿Funciona? ¿Debería llevarlo?

<details><summary>Respuesta</summary>

Funciona: gcloud elige una imagen de Debian por su cuenta.

Pero **debería llevarlo**:

```powershell
--image-family=debian-12 --image-project=debian-cloud
```

Si mañana Google cambia el valor por defecto, tu comando crea una máquina con
otro sistema operativo sin que tú hayas tocado nada. Es la misma idea de
reproducibilidad que llevó a elegir una red custom en la etapa 4.
</details>

**C6.** ¿Para qué sirve `--no-address` y por qué **no** se usa aquí?

<details><summary>Respuesta</summary>

Arranca la VM **sin IP externa**. Es lo correcto para cualquier cosa que no tenga
que ser pública: más barato y sin superficie expuesta.

Aquí no se usa porque el ejercicio consiste justo en abrir la web desde tu
navegador. Con `--no-address` habría que entrar por IAP.
</details>

**C7.** La VM aparece como `RUNNING` pero la web no carga. ¿Qué dos cosas pueden
estar pasando?

<details><summary>Respuesta</summary>

1. **El startup script todavía no ha terminado.** `RUNNING` significa que el
   sistema operativo arrancó, **no** que tu script acabara. El `apt-get` tarda.
2. **El puerto 80 no está abierto.** Es lo que pasa de verdad en esta etapa: solo
   existe `ssh-custom`, que abre el 22.

La forma de distinguirlas: entra por SSH y mira `systemctl status nginx`. Si el
nginx está activo y desde fuera no responde, es el firewall.
</details>

**C8.** ⚠ ¿Por qué el navegador se queda "cargando" en vez de dar un error rápido
de conexión rechazada?

<details><summary>Respuesta</summary>

Porque un paquete descartado por el firewall **no contesta nada**. No hay un "no"
que devolver, simplemente se tira el paquete, y el navegador espera hasta que
expira el tiempo.

Un "conexión rechazada" inmediato significaría otra cosa: que el paquete llegó a
la máquina y allí no había nadie escuchando en ese puerto.
</details>

---

## Bloque D — Startup scripts (7 preguntas)

**D1.** ¿Cuál es la medida real de este ejercicio?

<details><summary>Respuesta</summary>

**Que el nginx se instaló solo, sin que entraras por SSH.**

Crear una VM se hace con tres clics. Lo que se aprende aquí es el
*bootstrapping*: la máquina nace configurada. De ahí sale todo lo demás — si la
máquina se configura sola, da igual que muera y nazca otra, y eso es el MIG de la
etapa 7.
</details>

**D2.** ¿Cómo llega el script a la máquina y quién lo ejecuta?

<details><summary>Respuesta</summary>

Con `--metadata-from-file=startup-script=compute-engine/startup-script.sh`: el
contenido del archivo se copia a la **metadata** de la instancia bajo la clave
`startup-script`.

Lo ejecuta el **agente de Google** dentro de la VM, al arrancar, **como root**.
Por eso el script no lleva ningún `sudo`.
</details>

**D3.** ⚠ El vídeo dice que el script corre "cuando la máquina arranca por
primera vez". ¿Es cierto?

<details><summary>Respuesta</summary>

**No.** Corre en **cada arranque**. Si paras y enciendes la VM, se ejecuta entero
otra vez.

Por eso tiene que ser **idempotente**, el mismo concepto que el `custom_role.py`
de la etapa 3: `apt-get install -y` sobre un paquete ya instalado no hace nada, y
`systemctl start` sobre un servicio ya arrancado tampoco.

Un script con `echo algo >> /etc/fichero` acabaría con la línea repetida veinte
veces.
</details>

**D4.** ⚠ ¿Por qué no se pueden poner contraseñas en un startup script?

<details><summary>Respuesta</summary>

Porque la metadata la puede leer **cualquier proceso dentro de la VM**, sin
permisos especiales:

```bash
curl -H "Metadata-Flavor: Google" http://169.254.169.254/computeMetadata/v1/instance/attributes/startup-script
```

Para secretos está Secret Manager.

Y el reverso: escribir metadata es escribir un startup script, y eso es **root
dentro de la máquina**. Por eso `compute.instances.setMetadata` era uno de los
permisos peligrosos de la etapa 3.
</details>

**D5.** ¿Por qué el `-y` de `apt-get install -y` no es opcional?

<details><summary>Respuesta</summary>

Sin él, `apt-get` se para a preguntar si continúas — y no hay nadie al otro lado
para contestar. El script se quedaría colgado para siempre.

Todo lo que corre desatendido tiene que ser no interactivo.
</details>

**D6.** ⚠ El startup script no hizo lo que esperabas. ¿Dónde miras?

<details><summary>Respuesta</summary>

Entras por SSH y lees el log del agente:

```bash
sudo journalctl -u google-startup-scripts.service
```

Sale tu script línea a línea. Como corre sin nadie delante, es **el único sitio**
donde ver qué pasó: no hay terminal, no hay mensaje de error en pantalla.
</details>

**D7.** ¿Qué otros scripts de metadata existen?

<details><summary>Respuesta</summary>

- **`shutdown-script`** — se ejecuta al apagar, para vaciar buffers, avisar a
  algún sitio o desregistrarse.
- **`windows-startup-script-ps1`** — el equivalente si la máquina fuera Windows,
  en PowerShell.
</details>

---

## Bloque E — Coste y transversales (5 preguntas)

**E1.** ⚠ Este es el primer ejercicio que cuesta dinero. ¿Qué se paga exactamente?

<details><summary>Respuesta</summary>

| Concepto | Se paga mientras... |
|---|---|
| vCPU y RAM del `e2-micro` | la VM esté **encendida** |
| disco de arranque, 10 GB | la VM **exista**, encendida o parada |
| IP externa efímera | esté asignada a una VM **encendida** |
| tráfico de salida | lo haya |

La trampa es la segunda fila: **parar la VM no la borra** y el disco sigue
contando.
</details>

**E2.** ⚠ El `plan.md` dice que la IPv4 externa se cobra aunque pares la VM. ¿Es
exacto para esta máquina?

<details><summary>Respuesta</summary>

**No para esta.** Ese aviso vale para una IP **estática reservada**, que se
factura —y más cara— precisamente cuando *no* está enganchada a nada, porque
estás ocupando una dirección escasa sin usarla.

La de este ejercicio es **efímera**: al parar la máquina se libera, no se cobra,
y al volver a encenderla **te dan otra distinta**. Ese cambio de IP es el precio
que pagas, no dinero.
</details>

**E3.** Terminas la sesión. ¿`stop` o `delete`?

<details><summary>Respuesta</summary>

- **`stop`** si sigues mañana o vas directo a la etapa 7, que empieza parando
  esta máquina. Dejas de pagar CPU y RAM, conservas el disco y los datos.
- **`delete`** si cierras el laboratorio. No queda nada, ni el disco. El comando
  de creación está guardado y rehacerla cuesta un minuto.

```powershell
gcloud compute instances stop servidor-web-1 --zone=us-east1-b
gcloud compute instances delete servidor-web-1 --zone=us-east1-b
```
</details>

**E4.** ⚠ Etapas 4, 5 y 6. ¿Qué hilo las cose?

<details><summary>Respuesta</summary>

El comando de creación de la VM lleva los tres ejercicios dentro:

| Flag | De dónde viene |
|---|---|
| `--subnet=subred-us-east1` | la red custom de la **etapa 4** |
| `--tags=web-server` | la etiqueta de la regla de la **etapa 5** |
| `--metadata-from-file=startup-script=...` | la **etapa 6** |

Quita cualquiera de los tres y algo se rompe: la VM acaba en la red `default`, o
no puedes entrar, o nace vacía y hay que instalar a mano.
</details>

**E5.** ¿Qué error del vídeo se arrastra hasta el ejercicio 18 y cómo se corrige?

<details><summary>Respuesta</summary>

**Falta la regla del puerto 80.** El vídeo solo crea `ssh-custom` (`tcp:22`), así
que la web nunca es accesible desde fuera — y en el ejercicio 18 el uptime check
le sale en rojo y lo deja así.

```powershell
gcloud compute firewall-rules create http-custom --network=vpc-lab --action=allow --direction=ingress --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=web-server
```

Aquí el `0.0.0.0/0` **sí** tiene sentido: un servidor web público está para que
entre cualquiera. Era en el 22 donde resultaba discutible.
</details>

---

## Puntuación

| Aciertos | Lectura |
|---|---|
| 32–35 | Módulo 1 cerrado y la primera VM entendida. A por el MIG. |
| 25–31 | Bien. Repasa las ⚠ que hayas fallado. |
| 18–24 | Relee el bloque donde se concentren los fallos antes de seguir. |
| < 18 | Vuelve a los dos apuntes; el cuestionario después cunde más. |

Las ⚠ son dieciséis: A2, A4, A6, A7, B3, B4, C1, C3, C5, C8, D3, D4, D6, E1, E2 y
E4. Si fallas más de cuatro, el problema no es de memoria sino de modelo mental.

Y una advertencia que no es una pregunta: a partir de aquí **el reloj corre**.
Antes de cerrar, los cinco comandos del checklist de apagado del `plan.md`.
