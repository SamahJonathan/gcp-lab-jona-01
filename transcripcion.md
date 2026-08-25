 Cómo aprobar el examen ACE
0:00
¿Quieres trabajar como ingeniero en la nube Cloud Engineer de Google Cloud, pero no tienes experiencia para
0:07
demostrar en las entrevistas? En este curso gratuito vas a construir tu portfolio en GitHub con ejemplos
0:13
prácticos y proyectos reales. No es teoría, es experiencia real lista para
0:19
que muestres en tu currículum y en tus entrevistas. Son cinco módulos, todo
0:25
paso a paso. Y en cada módulo lo que vamos a hacer es explicar la teoría.
0:30
realizar un ejercicio y servirlo a nuestro perfil de GitHub. Así vas a poder enseñar todo el trabajo que vas
0:36
haciendo en tus entrevistas. Cuando un técnico de selección entra en tu perfil y ve que has construido proyectos reales
0:43
en Google Cloud, entiende perfectamente que vas a poder construir soluciones, no solo estudiarlas teóricamente. Tu
0:51
carrera como Cloud Engineer empieza aquí. ¿Listo para crear tu portfolio, vamos con el primer módulo. En este
0:58
primer módulo, lo que vamos a hacer va a ser preparar el setup inicial para poder trabajar eh a lo largo de este curso.
1:06
Este setup nos va a permitir trabajar en proyectos reales en Google Cloud y subir
1:13
estos proyectos reales a nuestro portafolio en GitHub. Por lo tanto, el primer paso va a ser crear una cuenta de
1:18
Google, enlazarla a una cuenta de Google Cloud y activar la facturación. Pero no
1:24
te preocupes, tiene un free tirer de $300 y además al terminar cada módulo, vamos
1:32
a eliminar los proyectos para evitar los cargos imprevistos. Además, te enseñaré a cerrar la cuenta de facturación para
1:39
que te olvides completamente de cualquier gasto. El segundo paso es crear el perfil en GitHub. crear el
1:46
repositorio y clonarlo en local. Luego crearemos nuestro primer proyecto ver
1:51
Google Cloud para empezar a levantar servicios. Y por último vamos a instalar la línea de comandos de Google Cloud
1:58
para trabajar en local, lo que se conoce como GCloud Cli. Empezar vamos a crear
2:05
un nuevo perfil en Google, una cuenta de Google. Para ello le vamos a dar a añadir perfil
2:11
de Chrome en Google Chrome
2:19
y le damos a añadir. Damos a iniciar sesión
Requisitos previos (SDK, Terraform, Cuenta GCP)
2:26
y crear cuenta. Podemos darle para mi uso personal.
2:33
Introducimos nombre y apellidos.
2:43
Fecha de nacimiento
2:57
y le pedimos crear una nueva dirección de correo electrónico.
3:07
Le damos contraseña y la confirmamos.
3:23
Le damos siguiente y nos pide un número de teléfono.
3:33
Vale, ahora una vez que tenemos creada la cuenta
3:42
y confirmado el número de teléfono, pues ya vamos a poder empezar a trabajar.
3:49
Nos vamos a cloud.google.com, le damos a empezar gratis
3:58
y aquí es donde vamos a crear nuestra cuenta de Google Cloud. Como bien dice, $300 en crédito gratuito
4:06
y sin cargos automáticos, solo como empezas a pagar si activar una cuenta completa de pago. Entonces introduces
4:13
todos estos datos y luego
4:21
introduces todos estos datos. GDP data engineer.
4:33
Le vamos a llevar así a la organización y luego, bueno, hay que introducir aquí todas estas
4:41
todos estos cajones.
4:51
Código postal Ciudad Madrid y provincia Madrid
5:02
y guardamos. Y ahora nos faltaría añadir una forma de
5:09
pago para poder comenzar gratis. Añadimos tarjeta de crédito
5:15
y le daríamos a guardar tarjeta. Pero bueno, como os decía, no va a haber cargos hasta que
5:22
no hay cargos automáticos si tú no quieres, solamente te lo pueden introducir.
5:28
¿Vale? Entonces, ahora una vez que ya tenemos la cuenta lista, vamos a crear
5:35
un proyecto nuevo y lo vamos a llamar GCP data engineer
5:46
curso y lo creamos. Vemos que el proyecto se está ahí
5:51
creando y le damos a seleccionar proyecto. Y
5:56
listo, ya tenemos nuestro primer proyecto creado.
6:11
Aquí vamos al billing a crear a ver la cuenta de facturación y lo vamos a a la
6:16
forma de pago. Si le damos ahí administración de cuentas,
6:22
eh, podemos cerrar la cuenta de facturación, cerrar y así ya nos aseguramos de que no vamos a tener
6:27
cobros a futuro. Pero bueno, primero por el curso vamos a dejarlo activado.
6:39
El siguiente paso es crear el perfil de GitHub, que es lo que se utilizará para que los para que los reclutadores
6:48
eh puedan comprobar tu experiencia en Google Cloud.
6:53
Lo podemos lo vinculamos a la cuenta de Google, link account.
7:10
nuevo repositorio
7:16
y creamos un repositorio que sea GTP Engineer Curso. Y aquí es donde vamos a
7:22
tener todos los archivos del curso.
7:30
Lo dejamos como público para que los reclutadores puedan verlo. Podemos añadir un ritmi y le damos a crear
7:37
repositorio. Y listo, nuestro repositorio ya está creado.
7:44
Ahora tenemos que crear una carpeta en la que meter localmente los archivos del
7:50
repositorio que lo podemos llamar también GCP data engineer
7:55
curse con el mismo nombre en el escritorio
8:06
y abrimos Visual Studio Code, que si no lo tenéis eh lo podéis instalar muy
8:11
fácilmente. Seleccionamos el la carpeta y ahora clonamos un
8:19
repositorio de y clonamos desde GitHub.
8:27
Y así de sencillo vais a ver qué es.
8:35
Y ahora abrimos Visual Studio, le damos el repo y seleccionamos la carpeta que
8:41
que acabamos de de crear.
8:49
Añadimos al workspace y ahí tenemos nuestro
8:54
nuestro repositorio. Vamos a abrir el de nuevo carpeta porque la tenemos dentro
9:01
y así ya nos quedamos limpio.
9:07
Aquí vamos a guardar el workpace.
9:13
Creo que no es necesario. Vamos a dar nuevo abrir y vamos a darle
9:19
a no guardar el workspace. Seleccionamos la carpeta que está dentro
9:31
y listo. Ya tenemos nuestro nuestro repositor conectado GitHub.
9:38
Aquí es donde haremos los ejercicios del curso y lo subiremos a al repositorio para que esté público de manera online y
9:46
que los reclutadores puedan verlo.
10:00
Vamos a crear un primer archivo para comprobar que se suben
10:07
y le ponemos sinit.p.
10:23
Lo guardamos y bueno, esto lo dejamos comentado para
10:29
que no de errores y vamos a subir este primer archivo.
10:42
Para ello nos vamos a aquí en la barra de la izquierda so control escribimos un
10:48
mensaje de comit
10:53
manual primer cómic manual
10:59
comiteamos le decimos queas
11:04
porque así ya nos lo meten staging automáticamente
11:11
nos da error porque no hemos configurado el username y el user email.
11:17
Entonces,
11:35
vamos a buscar dónde están loss del error para ver qué es lo que pasa.
11:49
Open git log. Y bueno, aquí ya nos dice que tenemos
11:56
que añadir el username y el user email y cómo se añade. Entonces, nos copiamos estas dos líneas
12:05
y aquí creamos una nueva terminal Visual Studio Code y vamos a definir user email
12:11
y user username.
12:21
Amos esto, ponéis vuestro nombre
12:31
y ahora ener email
12:37
vuestro email.
12:43
Entonces, ahora subimos los cambios, nos pide
12:48
loguearnos de nuevo. Vamos a utilizar Git ecosystem.
12:56
Autenticación exitosa.
13:10
Y ahí nos sale primer comit. Y si nos vamos a git y refrescamos,
13:16
vamos a ver el archivo que hemos creado. Ahora vamos a ver lo último, que es
13:22
instalar el el SDK de Google Cloud para poder
13:29
trabajar en local con las herramientas de línea de comandantes de Google Cloud.
13:34
Entonces, buscamos instalar Google Cloud SDK y aquí nos ven instrucciones de la
13:40
de la página de Google Cloud. tenemos que descargar un instalador. En este caso voy a hacerlo con Windows
13:46
porque es el más el más transversal, yo creo que suelo trabajar con con Linux.
13:55
Entonces nada, estará pues este programa.
14:09
Este programa va a ser muy útil para para hacer las para tareas de Google
14:15
Cloud en automático, como por ejemplo eh levantar instancias, crear backets,
14:22
eh subir archivos, etcétera.
14:39
instalar y se puede setear las credenciales.
14:49
Vale, ahora una vez que ha terminado, pues ya vamos a poder hacer un headcloud init para para
14:57
setear el entorno de Google Cloud en la terminal de
15:05
le damos a finalizar y llamamos que se nos abre
15:13
y que hay que hacer un sentimiento y nada cuenta. de Google, pues es muy
15:20
fácil bloquearse en la línea de comandos y ya está. Ya os dije que estamos
15:26
ificados en la línea de comandos de Google Cloud y ya vamos a poder trabajar. Módulo uno, configuración IAM y redes.
Automatizando el Setup con Terraform (APIs)
15:36
Ejercicio uno, jerarquía de recursos y API. Todo en Google Cloud comienza con
15:41
la jerarquía de recursos. Puedes imaginarte como un árbol. La raíz de este árbol es la organización. o sea, tu
15:49
empresa. Aquí se definen las políticas globales. El siguiente nivel son las carpetas o folders. Permite agropar por
15:56
departamentos, recursos humanos, ventas, marketing o también puedes agrupar por
16:02
entornos desarrollo, producción, staging, etcétera. Es como si fuesen
16:08
cada una de las ramas de ese árbol. Y por último están los proyectos. La unidad base serían como las hojas de ese
16:15
árbol. Todos los recursos que se levantan en Google Cloud, máquinas virtuales,
16:21
contenedores, data lakes, data workhouses, todos ellos pertenecen a
16:26
proyectos, no a usuarios. Y lo más importante, la facturación se configura
16:31
a nivel de proyecto. Por defecto, un proyecto nuevo cuando lo acabas de crear es como una caja fuerte.
16:38
No puedes empezar a levantar máquinas virtuales ni cláusters de cubernetes hasta que habilites sus APIs
16:45
correspondientes, como por ejemplo la de compute engine para máquinas virtuales,
16:50
que es compute.googleapis.com. Esto se hace por seguridad y para no
16:55
saturar la interfaz. En la práctica vamos a utilizar Terrafone para levantar esta estructura base y activar las APIs
17:03
programáticamente, asegurando que nuestro entorno sea reproducible.
17:08
Vale, pues el primer paso va a ser crear un proyecto nuevo. Le vamos a dar de nombre CCP
17:16
Cloud Engineer curso
17:24
01 y lo creamos.
17:36
Y como vamos a trabajar con infraestructura, pues el primer paso y el primer
17:42
entregable que vamos a crear va a ser el de habilitar la API de TAR.
17:48
Entonces, para ello nos venimos a al editor,
17:53
creamos un nuevo archivo que le vamos a llamar
18:02
main.tf TF. De hecho,
18:08
vamos a crear una carpeta que sea
18:16
curso uno o lo vamos a llamar mejor
18:22
setup terraform y metemos ahí el main punter y el código
18:31
es el siguiente.
18:37
en el que tenemos provider Google como project ID. Vamos a poner
18:47
el que hemos puesto que sería GCP Cloud Engineer curso 01P
19:00
curso 01 Central
19:06
y le vamos a a decir que habilite estas API.
19:15
Y bueno, service key yelon destroy false.
19:22
Entonces ahora aquí abrimos una nueva terminal
19:29
y hacemos primero headcloud out
19:35
application default log.
19:42
Lo hacemos con un command prompt y hacemos cloud application default login.
19:49
Entonces aquí ya seleccionamos nuestro usuario, le damos a continuar
19:56
y ya nos dice que estamos autenticados la click de GCloud.
20:03
Entonces ahora aquí sí que podríamos hacer un terraform
20:10
init. nos dice esto. Y lo bueno de trabajar
20:17
con antigravity es que le vamos a decir lo que nos está
20:22
pasando.
20:31
Está verificando la sif está instalada o no.
20:45
nos dice que tenemos que hacer un choco menos vernos version o un we terreform.
20:51
Le damos a aceptar y a aceptar.
20:59
ha confirmado que no tenemos reform instalado
21:08
y nos va a pedir aquí lanzar un winat menos version. coge la versión de Windows.
21:25
Ya ha creado un implementation, un plan
21:31
en el que nos pide lanzar primero esto.
21:40
Estoy instalando Terreform.
21:55
Vale, ahora hacemos un perform.
22:06
Vemos que está instalado y nos vamos a
22:11
la carpeta que tenemos el setup terform y hacemos terformit
22:29
que hay un error en el código
22:34
que va a ser que es una cómoda.
23:02
Y de nuevo se lo podríamos pasar a a Yemini para que nos confirme cuál es el
23:08
error.
23:32
Y claro, nos faltaba ahí un retorno de carro. Ahora volvemos a realizzar el terfón init.
23:52
Ya nos dice que ha sido eh inicializado exitosamente y hacemos un terform apply
24:06
y nos dice todos los cambios que se van producir va a habilitar esta API, esta API y esta
24:12
API. Le damos a yes,
24:22
está habilitando las APIs. Y si nos venimos aquí a nuestro proyecto
24:32
y vamos a pisoteca.
24:55
y buscar una compute
25:10
y no estoy seguro de si sería esta en concreto. comput.googleapis.com
25:15
nos dice que pulsemos en habilitar. Entonces, una vez que esté creada, ya
25:22
debería ya debería salir.
25:31
Habilitar un API sobre tardar unos minutos, entonces hay que tener paciencia. Ahora nos dice que terminado
25:37
y si refrescamos ya vemos que ya está la API habilitada
25:45
y en eso consiste esta primera práctica con TF. Ejercicio dos, service accounts e IAM.
Service Accounts y IAM con Bash
25:53
IAM son las siglas de Identity Access Management. Gestionamos el quién, los
25:59
usuarios que van a acceder y el qué, los servicios a los que pueden acceder. El quién pueden ser usuarios humanos de
26:06
verdad o pueden ser service accounts, cuentas de servicio. Una service account es especial, es una identidad para tus
26:14
aplicaciones, pero también es un recurso. El concepto vital sobre esto es el principio de menor privilegio. Si
26:21
tienes un script que necesite subir archivos a un bucket, jamás le debes dar el rol de owner o editor sobre el propio
26:29
bucket. Si esa cuenta se ve comprometida, tendrán las llaves de todo el árbol. Además, hay que recordar que
26:35
los permisos en NGCP son aditivos. Si te doy permiso de lectura en la organización y permiso de escritura en
26:42
el proyecto, al final tienes los dos a la vez. En el ejercicio que vamos a subir al portfolio, vamos a crear una
26:48
cuenta de servicio para una unidad digital que haga el despliegue de una máquina virtual en Computine. Para ello
26:55
le vamos a dar un rol muy específico utilizando la línea de comandos de Google Cloud.
27:02
Vale, pues nos abrimos el la consola de Google Cloud en el
27:07
proyecto que ya habíamos creado y ahora nos vamos al editor de texto
27:13
y vamos a crear una nueva carpeta que se va a llamar Setup
27:20
IM.
27:25
Y aquí vamos a crear un archivo que se va a llevar setup iam.sh.
27:33
Y lo que vamos a hacer va a ser lanzar comandos de GCloud
27:39
que van a ser el primero.
27:54
van a ser el primero, un create eh una service account que se va a llamar de Developer y que se va a visualizar en la
28:01
consola como deployer SA. Tenemos que añadir el nombre del
28:07
proyecto que va a ser
28:13
GCP Cloud Engineer Curse 01
28:22
y aquí debajo igual gradingir curs 01.
28:30
Y en este segundo comando lo que se hace es eh linkar una una IAM policy
28:38
en este proyecto a esta service account, que es la que acabamos de crear en el paso anterior con el rol de compute
28:45
viewer, que le va a permitir visualizar los recursos de compute engine que se levanten en el proyecto.
28:54
Entonces aquí hacemos un GC Cloud Init.
29:09
Seleccionamos la cuenta y seleccionamos el proyecto
29:16
y le decimos aquí que no. Y ahora hacemos un cloud
29:21
application default
29:26
log.
29:36
Default log.
29:42
Iniciamos la sesión.
29:49
Vale, entonces aquí si venimos a IAM.
30:07
y nos vamos a las cuentas de servicio.
30:13
Vamos a ver que solamente nos sale esta que es la que se crea al habilitar la P
30:18
de computing que hicimos en el ejercicio anterior.
30:24
Entonces ahora ya sí vamos a lanzar los comandos.
30:35
Nos dice create service account. Entonces actualizamos y aquí nos sale.
30:41
Y si vamos a m y actualizamos aquí
30:50
todavía no nos va a aparecer porque todavía no tiene permisos ningunos esta
30:55
service account que se lo vamos a dar ahora.
31:11
Tenemos que pegarlo como una línea.
31:30
Y ahora ya nos dice que se ha hecho un update de la IM policy para ese
31:36
proyecto. Ahora aquí si si refrescamos
31:44
efectivamente vemos que tiene el RAL de visualizador de computamos
31:50
añadirle otros permisos como
31:57
si buscamos por almacenamiento,
32:04
le podríamos dar el de visualizador Aunque esto es un rol
32:11
predefinido o si buscamos Cloud Storage
32:24
y podemos buscar aquí diferentes roles.
32:31
Adador deo de cloud de storage, visualizador de backets de storage, visualizador de de objetos de storage.
32:39
Vamos a darle este, guardamos y ahí lo tenemos.
32:48
Y aquí podemos agregar agregar otro rol y pues sería el
32:57
visualizador de computer
33:13
de compute guardar y ahí tendría dos y se podrían ir añadiendo.
33:19
Por último, vamos a subir esto al repositorio.
33:26
Hacemos curso dos, comiteamos, sincronizamos cambios
33:38
y ahí está subido. Y si ahora venimos a GitHub
33:47
y nos vamos al repositorio de Cloud Engineer. Ahí vemos que tenemos ya el
33:52
curso dos con el script. Ejercicio 3, roles personalizados.
Creando Roles Personalizados con Python
34:00
Custom roles. Google Cloud ofrece tres tipos de roles: primitivos o básicos.
34:05
Owner, editor and viewer. Son de la vieja escuela. Evitadlos en producción siempre que podáis. Predefinidos, como
34:13
por ejemplo compute admin o storage owner, son desarrollados por Google y se
34:19
autogestionan. Son los más utilizados, personalizados, custom rols. A veces el
34:24
rol predefinido es demasiado amplio. Imagina una auditoría de seguridad. Necesitas que un operador pueda detener
34:32
una máquina virtual que se ha vuelto loca, pero que no pueda borrarla ni ver su contenido. No existe un rol de Google
34:39
para eso. Tienes que crearlo tú combinando permisos individuales, como por ejemplo el de compute instances stop
34:47
para parar las máquinas virtuales. En la práctica que vamos a subir a GitHub, utilizaremos Python para seguir una
34:55
cirugía muy fina. Vamos a crear un rol que solo permite realizar un par de acciones concretas. ¿Vale? Pues en esta
35:01
práctica vamos a ver cómo se crea un rol
35:08
custom, o sea, un rol personalizado.
35:14
Entonces, pues por eso vamos otra vez a M.
35:20
Y si nos venimos aquí a la parte de los roles, pues vemos que son todos de tipo
35:29
predefinidos. Luego personalizado,
35:34
pues hay este, pero que está en estado borrado.
35:39
Entonces vamos a crearlo a través de Python. nos venimos al editor y aquí en setup AM vamos a crear un archivo que
35:49
ser custom.p Y aquí a este archivo
35:57
le vamos a añadir el siguiente código.
36:26
Lo que hace este código es utilizando la librería de Python de Google Cloud con IAM admin.
36:33
Eh, se coloca en el proyecto y en el rol vamos a crear un rol de
36:39
virtual marching starter stopper que va a poder iniciar y parar las
36:45
comput instances. Entonces, para ello vamos a lanzar el
36:50
script con un Python 3
36:59
custom roll.p. Nos dice que tenemos que instalar la
37:06
librería y se instala con Pip Instal Google Cloud IAM.
37:18
Y ahora que está instalada, si lanzamos el script,
37:25
no nos dice nada porque realmente no está leyendo los parámetros si no tiene
37:30
un if name, entonces aquí al al agente de antigravity le podemos decir,
37:37
no sé, están leyendo parámetros
37:42
en la función crear R pun crea el código necesario para
37:54
asignar parámetros vía línea de comandos.
38:04
Vamos a poner virtual machine iniciar y detener.
38:09
Le decimos que corrija el código en customroll.p. Importe
38:28
el agruparse. Aceptamos los cambios.
38:34
Entonces ahora si lanzamos el Python 3 Custom RLE,
38:39
ya nos dice que tenemos que añadir project ID y RID ID.
38:45
Y si lanzamos con el menos menos help, ya nos dice cómo tiene que ser.
38:52
Entonces, pro ID es GCP Cloud Engineer
38:57
curso 01 y de nombre le vamos a dar virtual
39:02
machine iniciar detener.
39:11
Ya nos dice rol creado. sobre si venimos aquí a los roles y refrescamos
39:19
aquí nos sale virtual el maching inicial y detener que es custom y que está habilitado.
39:25
Entonces, ahora si venimos aquí a la a las cuentas
39:31
y editamos nuestra service account que creamos en el ejercicio anterior, le damos agregar otro rol, buscamos virtual
39:39
machine, iniciar detener
39:44
y aquí estaría y lo podíamos agregar, pero lo podemos hacer también vía línea
39:49
de comandos con el ZP que vimos antes. Pegamos el comando de Google Cloud y
39:55
aquí en roles le ponemos la ruta del rol que acabamos
40:01
de crear, que está a nivel de proyectos.
40:09
Vemos que se que termina correctamente. Entonces, ahora aquí si actualizamos
40:18
ya nos dice que tiene la de virtual machine, iniciar y detener.
40:41
Y por último comiteamos el código curso 3.
40:52
Sincronizamos cambios.
40:58
Y ahora si utilizamos aquí el perfil, ya nos sale el curso 3 con el custom,
41:05
con el código del custom row. Ejercicio 4, VPCs y el mito del auto
Desplegando una VPC Segura (No default)
41:13
mode. Pasamos a redes. La VPC Virtual Private Cloud es la red privada global.
41:19
Sí, global. Una sola VPC puede abarcar Londres, China y Estados Unidos. Sin
41:26
embargo, las subredes son regionales. Cuando se crea un proyecto nuevo, Google proporciona la red default en automote.
41:34
Esta red crea una subred en cada región del mundo automáticamente. Esto es un riesgo de seguridad y un desastre de
41:40
gestión de IPs en entornos corporativos. La solución idónea casi siempre implica
41:45
utilizar el custom mode, donde el ingeniero explícitamente define qué rangos de IP va a utilizar y
41:52
en qué regiones. En la práctica de este ejercicio vamos a borrar la red por defecto y diseñar una arquitectura de
42:00
red segura desde cero con Terraffor. En este cu en este cuarto ejercicio vamos a
42:06
crear una subred personalizada para nuestro proyecto. Si venimos aquí a las
42:12
redes de VPC, vemos que la red del proyecto actual es la default y las subredes son también
42:19
todas las default. Podíamos aquí crear una red de VPC, pero vamos a hacerlo con terraform.
42:30
Entonces, aquí dentro de Setup Terraform vamos a crear un nuevo archivo que va a
42:37
ser Network TF y que va a tener el siguiente código.
42:43
En el recurso Google Comput Network VPC Network, vamos a crear una VPC para
42:49
nuestro curso y con el Autocreate Subnetworks a false.
42:58
Y luego vamos a crear un subnet en US que le vamos a llamar subred US con esta
43:05
con este rango de IPS, con esta región y en esta red.
43:12
Entonces si ahora aquí nos vamos hacia atrás,
43:19
vamos a ter a setup terraform
43:26
y hacemos terraform apply.
43:44
nos dice que va a realizar las siguientes acciones, va a crear una network
43:50
y también una subnetwork que lo vamos a llamar subnets.
43:59
Le decimos yes y ya está creando la red. Steel
44:14
creating.
44:25
Vale, ya se creó la red. Entonces aquí si actualizamos ya nos
44:33
sale la red que tiene una subred.
44:48
Vale, ahora ya creado las subredes también. Entonces si aquí actualizamos
44:53
nos dice que tiene una única subred.
45:05
Y aquí está esa subred que es la que tiene US central 1 subreduce mi VPC
45:11
que es lo que le indicamos aquí en Trafo.
45:17
Por último, como siempre, vamos a comitear curso 04
45:25
y sincronizamos C.
45:32
Entonces, ahora aquí si refrescamos y vemos que nos sale el curso 04 en
45:38
setup Terrafom y en el network.tf está el código de esta práctica.
Firewalls y Network Tags
45:45
Ejercicio 5, firewall stateful y network tax. El firewall de Google es stateful.
45:52
Esto significa que si permites una conexión de entrada ingress, la respuesta de salida e se permite
45:59
automáticamente. No tienes que abrir puertos en ambas direcciones. Por defecto, todo el tráfico entrante está
46:06
bloqueado. Entonces, tienes que abrir los agujeros. El problema clásico,
46:11
tienes 100 servidores web y 50 bases de datos. ¿Vas a escribir 150 reglas de
46:17
fireball por cada IP? No. Para eso existen los network tags. Tú etiquetas
46:22
tus máquinas como web server o DV Server. Y la regla de Firewall dice: "Abre el puerto 80 a cualquier máquina
46:30
que tenga la etiqueta web server. Si mañana creas 10 máquinas nuevas con esa
46:35
etiqueta, la regla se aplica por sí misma. Ahora vamos a crear una regla inteligente que permita la conexión SSH
46:43
solo a las máquinas que nosotros decidamos.
47:13
Vale, en este ejercicio lo que vamos a hacer va a ser crear una
47:22
regla de firewall.
47:30
En este ejercicio lo que vamos a hacer va a ser crear una regla de firewall eh aplicada a un network tag,
47:38
lo que podría ser pues estos network tags se pueden añadir, por ejemplo, a diferentes servicios levantados en
47:44
Google Cloud como computing, apping, etcétera, que veremos ya en siguientes
47:52
ejercicios cómo se levanta. y lo vamos a vincular a la red que hemos creado en el ejercicio anterior.
47:59
Entonces, aquí si buscamos firewall
48:05
vamos a ver que hay estas cuatro reglas de firewall y que todos se empiezan por default
48:11
guion porque son las que crea por defecto eh GCP.
48:16
Entonces, lo vamos a hacer a través de un comando de Google Cloud. Nos venimos al editor y creamos un nuevo archivo que
48:24
sea net firewall network tax pun ch.
48:37
Entonces el comando es el siguiente. Hecloud compute firewall rules create al
48:45
ush custom. Este es el nombre de la regla de firewall que vamos a ver en la consola.
48:52
La red a la que vamos a apuntar es la del ejercicio anterior. Mi VPC curso. La action es al permitir.
48:59
La dirección es ingressante en el servidor. La regla es TCP2, que quiere decir
49:06
puerto 22 protocolo eh TCP, que es el de SSH. El rango de IP es eh origen
49:17
y el target tags que va a ser web server.
49:22
Entonces, para lanzarlo, vamos a ponerlo en una sola línea.
49:40
Y lo lanzamos aquí abajo. Nos dice creating firewall.
49:49
Vale, ya lo ha creado. Name SSH custom, como decíamos, network, la del ejercicio
49:56
anterior, mi VPC curso dirección ingressp2.
50:02
Entonces ahora aquí si actualizamos vemos la nueva regla que acabamos de crear.
50:09
Ya dice la prioridad 1000 como veíamos web server como destino, que es el
50:15
network tag. Y bueno, por último, ya vamos a subir el código curso 05.
50:24
Comiteamos, sincronizamos cambios
50:33
y si aquí refrescamos ya nos sale Firewall Network Tags curso
50:38
05 nuestro comando. Módulo 2, compute engine. Ejercicio 6,
VMs con Startup Scripts (Nginx auto-install)
50:44
virtual machines, zonas y bootstrapping. Computer engine son las máquinas virtuales de toda la vida. Tú eliges la
50:51
CPU, la RAM y el sistema operativo. Aquí es crucial entender la disponibilidad. Una virtual machine es un recurso que se
50:59
levanta a nivel de zona. Si la zona US Central 1A se incendia, tu máquina
51:05
virtual desaparece. Para evitar esto, luego veremos grupos de instancias, pero
51:10
ahora vamos a centrarnos en una sola. ¿Cómo configuramos el software dentro? Entrando por SSH e instalando a mano.
51:17
Jamás. Eso no es escalable. Usamos startup scripts. Son scripts baixo
51:23
Python que pegamos en la metadata de la virtual machine. Cuando la máquina arranca por primera vez, el agente de
51:29
Google ejecuta este script con permisos de root. Es la base de la automatización. En la práctica vamos a
51:35
provisionar un servidor web que se autoconfigura nada más nacer. En este
51:40
ejercicio vamos a crear, vamos a levantar nuestra primera máquina virtual en Google Cloud. Vamos a a utilizar el
51:47
servicio compute engine para ello y lo vamos a disponibilizar a través del balanceador balanceador engins.
51:54
Entonces, si nos venimos a compute engine,
52:01
vemos que no tenemos ninguna máquina virtual. Venimos aquí en las instancias y no hay
52:07
ninguna. Se podría crear una instancia desde aquí, pero nosotros lo vamos a hacer por línea de comandos.
52:13
Entonces, aquí en el editor vamos a crear un nuevo archivo a esta altura que
52:20
sea compute engine create instance.sh.
52:32
Entonces, el comando que vamos a lanzar es el siguiente. Vamos a crear un servidor web
52:40
que se llama Sí, servidor web 1 y le
52:46
le vamos a dar la zona entre el 1 el machin 2 micro que es una máquina muy
52:53
poco potente pero bueno, para un balanceador web suele funcionar. como subred vamos a darle la que creamos hace
53:00
unos ejercicios y como tag el web server, que es el que utilizamos también en la en las políticas de firewall en el
53:08
ejercicio anterior. Y como metadata startup script, eh, le
53:13
vamos a decir que instale engins y que arranque el servicio.
53:22
Entonces
53:30
vamos a quitar los saltos de línea estos
53:35
lo reemplazamos por un espacio y vamos a lanzar el comando.
53:53
Voy a para el startup script vamos a crear también un script
54:00
que va a ser startup script.sh
54:06
SH y vamos a copiar el código del startup script
54:17
que va a ser este. guardamos
54:23
y aquí en el comando
54:31
vamos a indicar que el startup script va a ser
54:37
punto barra startup
54:42
script.sh S.
55:02
Vale, ya nos dice que ya lo ha creado y que está en status running. Y esta es la IP. nos quedamos con la IP externa
55:09
porque es con la que vamos a poder abrir nuestro websver.
55:14
Entonces aquí si actualizamos nos sale nuestro servidor web en la zona que dijimos
55:21
y tiene este IP.
55:33
Vemos que tiene etiqueta web server. el almacenamiento que tiene,
55:41
etcétera, etcétera. Entonces, con la IP que teníamos,
55:47
excedemos http/ barra y copiamos la IP
56:02
sin http.
56:13
Vemos que está en la red que creamos nosotros en en otro ejercicio.
56:34
Y está cargando porque claro, tiene que instalar los paquetes de angings y arrancarlos. Entonces puede tardar un
56:39
poquillo. Podemos conectarnos con SSH a la máquina.
57:00
y vamos a hacer ponernos como root y hacemos
57:09
dice como not found.
57:23
Vamos a hacer un service status.
57:44
Y ahora si sí que hacemos el service en Geek está nos dice que está activo.
57:53
Entonces, ya deberíamos poder ver, poder arrancar.
58:05
Y por último, como siempre, venimos aquí y hacemos curso 06, comiteamos y
58:14
sincronizamos los cambios.
58:23
Entonces, ahora ya aquí en nuestro repositorio ya nos sale
58:30
los scripts del curso 06. Ejercicio siete, manage instance groups, mix y
Auto-healing y Managed Instance Groups (MIG)
58:37
autoescaning. Es el concepto de mascotas versus ganado. Un servidor individual es
58:43
como una mascota. Si enferma lo tienes que cuidar. En la nube queremos ganado.
58:48
Si una máquina virtual falla, la eliminamos y ponemos a una nueva. Los Manage Instance Groups Mix hacen esto
58:56
posible. Utilizan una instance template, plantilla inmutable para crear copias
59:01
idénticas. tienen dos superpoderes, autohealing y autoescalling. En el auto
59:07
healing, el MIG le pregunta a cada una de las máquinas cada cierto tiempo si sigue viva, o sea, le lanza un pin. Y si
59:15
no responde o falla, ya levanta una nueva. Y en el autoescaling, si la CPU de las máquinas llega al 80%, el MIG
59:22
añade más máquinas automáticamente. Cuando la carga baja, las destruye para ahorrar en dinero. Vamos a montar un
59:29
cláster de servidores con Terrafone que se autogestiona.
59:40
En este ejercicio vamos a crear lo que son los managing test groups, que son grupos de instancias, clasters, por así
59:47
decirlo, que trabajan las máquinas virtuales de manera cooperativa.
59:52
Entonces, si vamos a computer engine, hay aquí una
1:00:00
sección de grupos de instancias y nos sale vacío. Bueno, antes de nada
1:00:06
vamos a parar esta instancia para que no nos
1:00:13
para que no nos cobren. Y ya nos vamos aquí los grupos de
1:00:19
instancias los vamos a crear. utilizando Terraform.
1:00:24
Entonces nos venimos al código y aquí en setup Terrafone vamos a crear
1:00:30
un MIG.
1:00:35
Y aquí en el código es el siguiente.
1:00:41
Vamos a crear un resource Google complete instance template template 1. Y
1:00:47
esto es una plantilla para crear instancias dentro de un grupo.
1:00:53
Entonces este es el prefijo de cada una de las máquinas que van a formar el cluster. Machine Type, que es dos micro
1:01:00
que es pequeña en cuanto a CPU y cuanto y en cuanto a memoria los tags web
1:01:06
server, que es en el que habíamos creado la política de firewall,
1:01:12
el disco, en el disco va a tener una source image que es un devian, es el
1:01:17
sistema operativo y la network interface que es la subnet US que habíamos creado
1:01:23
también en otro ejercicio. Entonces, aquí es donde realmente definimos el instance group. Vamos a
1:01:30
tener, vamos a decirle que tiene un target save de dos para que cree un grupo con dos instancias,
1:01:37
que el nombre base va a ser app y bueno, la región donde se va a alojar
1:01:43
y y el template que es el que creamos arriba. Entonces, ahora aquí si hacemos un
1:01:50
terraform apply
1:01:59
está lo primero lo que hace es refrescar el estado de todo lo que está previsionado con Terrafone, que eran las
1:02:05
tres APIs, la network y la subnetwork. Y ahora lo que le decimos es que va a
1:02:11
crear una template con el código que dijimos, con todas estas cosas
1:02:18
y luego el inst group es el MIG también con todas estas configuraciones.
1:02:24
Entonces le decimos que ellas y nos dice que está create en la template. La
1:02:30
template ya la crea al momento y ahora está levantando el instance group.
1:02:35
Entonces, ahora aquí si refrescamos vemos que está pasando de cero las
1:02:42
instancias y que está que las está levantando.
1:02:50
Nos dice la plantilla. Esta plantilla es la que también definimos con Terraform
1:02:57
que está utilizada por App MIG. es una de dos micro
1:03:03
con esta red y esta subred que son las que creamos nosotros,
1:03:08
etcétera.
1:03:14
Entonces ahora aquí ya nos dice que el estado está OK.
1:03:19
Y si ahora nos venimos aquí al grupo de instancias, vamos a ver nuestras dos instancias y podríamos conectarnos por
1:03:25
con ellas esa SSH. y vemos dónde están creadas y la
1:03:31
plantilla que es la misma para las dos. Podríamos monitorear cómo va
1:03:40
y bueno, también podríamos editar listas group desde aquí y también se podría crear.
1:03:46
Entonces, por último, lo que vamos a hacer va a ser comitar los cambios.
1:03:52
Curso 07, creo que vamos ya comiteamos y sincronizamos.
1:04:03
Y ahora si nos venimos aquí al repo y refrescamos y nos va a salir curso 07 aquí
1:04:12
y nos sale nuestro. 10.
1:04:22
Entonces también vamos a ir aquí a grupos de instancias
1:04:38
y bueno, no nos deja
1:04:44
detenerlas. estará bien eliminarlas en en próximos
1:04:50
ejercicios. Ejercicio 8o, snapshots y gestión de discos. Los datos son lo único que no
Automatizando Snapshots con Python
1:04:57
podemos reemplazar si una máquina virtual se borra. En Computing, los discos Persistent Disks son
1:05:03
almacenamiento en red, no están insertados físicamente en el servidor. Para hacer backups utilizamos snapshots.
1:05:11
Lo genial de los snapshots en GCP es que son incrementales. El primer backup tarda mucho porque copia toda la
1:05:17
máquina. El segundo solamente copia los bytes que han sido modificados, así que
1:05:23
es muy rápido y muy barato. ¿Cómo muevo una máquina virtual de Estados Unidos a Europa? No puedes moverla. Haces un
1:05:30
snapshot del disco y creas un disco nuevo en Europa utilizando ese snapshot como fuente. Vamos a automatizar la
1:05:36
creación de snapshots utilizando Python y la librería cliente de Google Cloud.
1:05:53
En este ejercicio vamos a crear backups de las instancias que que creamos en los
1:05:59
ejercicios anteriores. Entonces, si nos vamos a snapshots de compute engine,
1:06:07
vemos que está vacío, se puede crear un snapshot o programar.
1:06:13
Entonces nosotros lo vamos a hacer con código de Python, con la librería cliente de Google Cloud para Python.
1:06:22
Entonces vamos a crear una carpeta que sea
1:06:28
compute engine
1:06:36
y vamos a meter aquí este del create instance y el del
1:06:41
startup script y vamos a crear uno nuevo que sea
1:06:48
backupvien.p. me col un carácter
1:06:56
backup.pine P y es este código.
1:07:06
Entonces, eh aquí lo que hace es listar los discos y selecciona el disco según
1:07:13
Project ID, zona y su nombre y crea un
1:07:19
snapshot y lo inserto.
1:07:25
Entonces tenemos que añadir esta parte para lo que es la línea de comandos.
1:07:32
Podemos pedirlo antigravity que nos lo haga también.
1:07:42
Ya nos da el código de hecho.
1:07:49
Entonces hay que pasarle proyect ID, dis name, snapshot name y son.
1:07:59
Entonces aquí nos vamos hacia atrás. CD pun punto
1:08:04
puncd compute engine. Aquí tenemos que guardar y si hacemos un
1:08:11
pon 3
1:08:16
se llama backupbien.p de gcp.cloud
1:08:22
Cloud Engineer, curso 01,
1:08:30
el disk name, snapshot name y la zona del disco.
1:08:36
Entonces, el disco lo vamos lo podemos buscar aquí con un
1:08:42
cloud compute instances.
1:08:52
list nos deja listar
1:08:59
attach disc.
1:09:04
Vamos a hacer un list y ahora vamos a hacerle un describe
1:09:13
de servidor web 1.
1:09:31
Entonces, aquí nos dice, aquí tiene los discos. Este es el del sistema operativo, creo.
1:09:41
Entonces, este es el nombre del disco
1:09:46
y la zona
1:09:58
es iestre el 1a. La tenemos aquí al final.
1:10:03
Entonces, ahora sí vamos a hacer Python 3
1:10:13
backup bien GCP Cloud Engineer
1:10:20
01. El nombre del disco ahora que es persistent disc.
1:10:26
El snapshot name vamos a decirle snapshot
1:10:34
gu ¿Cómo se llamaba esta? Servidor web 1.
1:10:41
Servidor web 1 y nos falta la zona que si va a estar
1:10:48
entre el 1a.
1:10:53
Tenemos que hacer pip install Google
1:11:02
Cloud Compute.
1:11:18
Y ahora si ya lanzamos el comando.
1:11:35
Lo estamos lanzando mal. Perdón, es con menos project
1:11:41
id
1:11:49
menos disc
1:11:55
menos snapshot name
1:12:01
y menos menos.
1:12:20
Vale, tenemos que habilitar la API compute.googleapis.com.
1:12:36
Podemos añadirlo aquí lo de setup terraformma main.tf.
1:12:44
Lo añadimos.
1:13:19
Creo que tenemos mal puesto el project.
1:13:27
Es con el curso 01.
1:13:40
Nos dice que no encuentra el disco. Vamos a ver aquí en las instancias.
1:13:53
¿Cuál es el disco?
1:14:00
Servidor web, ¿vale?
1:14:06
No es el que estábamos viendo allí. Entonces cambiamos el nombre del disco a
1:14:15
servidor web No.
1:14:38
Y voy a ir creando por aquí también un archivo, compute engine de commands.sh. SH con
1:14:46
los comandos que hemos lanzado también para que queden ahí a mano.
1:14:53
Vamos a venir aquí a los snapshots y ahora sí que se está creando el snapshot.
1:15:00
Entonces vemos que el código de Python está yendo bien.
1:15:06
Y aquí en los commands quería añadir estos que lanzamos que era el cloud
1:15:13
compute instance list. He cloud compute instance describe.
1:15:23
Y bueno, y también voy a añadir el de Python
1:15:32
para que ya quede ahí.
1:15:46
Ahora vemos que ya ha terminado snapshot creado. Y por último, como siempre lo que vamos
1:15:53
a hacer va a ser subir los cambios.
1:15:59
Le hicimos curso 08, comiteamos,
1:16:05
sincronizamos. Y ahora aquí en el repo
1:16:15
ya tenemos curso 08 computer engine con todos los cuatro scripts. Ejercicio nu
SSH seguro con OS Login
1:16:21
operate system logging y el fin de las llaves de SSH. Imaginad una empresa con
1:16:26
500 ingenieros. Gestionar sus llaves públicas SSH manualmente en cada
1:16:31
servidor Linux es imposible y peligroso. ¿Qué pasa cuando alguien deja la empresa? Tienes que ir servidor por
1:16:38
servidor borrando su llave. Google solucionó esto con OS Login. OS Login
1:16:44
vincula la cuenta de Google, Gmail o corporativa con el usuario de Linux.
1:16:49
Cuando intentes hacer SSH, Google verifica en tiempo real si tienes permisos IAM en el proyecto. Si eres un
1:16:57
empleado activo, entras. Si te han revocado el acceso, el SSH te rechaza al
1:17:02
instante. Además, permite la autenticación en dos factores. En esta práctica, para subir a GitHub, vamos a
1:17:09
configurar la metadata del proyecto para forzar el uso de OS login y ver cómo nos
1:17:14
conectamos. Vale, en esta práctica vamos a ver todo lo relacionado con el OS login y con la conexión mediante claves
1:17:22
SHsh a nuestros servidores en computer engine. Entonces, empezamos entrando en
1:17:27
computer engine. Pues esto lo vamos a hacer con comandos de H Cloud. Y si nos vamos
1:17:36
a nuestras instancias, vamos a arrancar esta, la del ejercicio
1:17:42
6. Y mientras nos vamos al código
1:17:52
y vamos a crear aquí lo que sea
1:17:58
OS login ssh.sh.
1:18:05
Entonces vamos a tener dos comandos, uno para habilitar el OS login a nivel
1:18:10
de proyecto y el otro para conectarnos por SH el
1:18:16
servidor web 1. Muy sencillo.
1:18:21
Entonces vamos a empezar habilitándolo.
1:18:27
Ya, una vez que está habilitado el OS login en el proyecto GCP cloud Engineer
1:18:33
curso 01, ya vamos a poder hacer el compute SSH, el servidor que creamos en
1:18:39
el ejercicio anterior.
1:18:51
Aceptamos y ahí estamos conectados al servidor web
1:18:59
uno que le habíamos instalado, por ejemplo, elings. Entonces podríamos hacer un
1:19:07
y hacer un service engings status
1:19:15
que está activo. Vamos a hacerle un stop.
1:19:23
Vamos a lanzar un estatus y ahora nos dice que está habilitado pero inactivo.
1:19:31
Y bueno, pues estamos aquí en el servidor.
1:19:37
Vamos a hacer un exit y nos salimos. Y bueno, vamos a como
1:19:43
siempre a subir los los cambios a nuestro repo. Pulso 09.
1:19:50
Comiteamos, sincronizamos y ahora aquí si refrescamos
1:19:58
vemos nuestro OS login. Por ejemplo, si queréis ver que de verdad está de
1:20:03
habilitado L, podéis entrar por SSH desde aquí
1:20:11
y hacemos un su do menos y hacemos
1:20:16
service engso.
1:20:29
No, Sims 58 segundos. Ejercicio 10, Google Cubernetes Engine. Cubernetes es
Desplegando un Cluster GKE con Terraform
1:20:36
el sistema operativo de la nube moderna, pero instalarlo y mantenerlo es muy difícil. Google Cubernetes Engine es la
1:20:42
versión gestionada. Google se encarga del control Plane, el cerebro del clúster, lo actualiza y lo repara. Tú
1:20:50
solo gestionas los note pools, los servidores donde corren tus apps. Existen dos modos que debes conocer,
1:20:56
estándar y autopilot. En el estándar tú eliges las máquinas y pagas por ellas,
1:21:03
aunque estén vacías. Tienes el máximo control. En el Autopilot, Google también
1:21:08
gestiona los nodos. Tú solamente pagas por los recursos CPU RAM que consumen
1:21:13
los pots. Es más caro por unidad, pero eliminas el desperdicio. En la práctica,
1:21:18
para subir a GitHub, vamos a desplegar un cluster con terrfono de tipo estándar, configurando la red y los
1:21:26
permisos. En este ejercicio vamos a levantar nuestro primer claster de cubernetes
1:21:31
utilizando Terreform y luego configurando el comando cube CTL.
1:21:38
Entonces aquí si escribimos GKE nos sale cubernetes engine
1:21:46
bueno aquí estarían los cleres. Entonces vamos a crear uno nuevo pero utilizando ter. Entonces nos ven un venimos a
1:21:52
nuestro editor de código y vamos a crear
1:22:00
una nueva carpeta que sea en esta altura.
1:22:07
que sea GKE Google Cubernet Sense. Vamos a crear
1:22:13
un archivo que sea cke.tf
1:22:18
y el código es el siguiente. Es resource es un Google container
1:22:26
cluster primario. Le vamos a dar nombre mi cluster de GKE y US entrel 1A como
1:22:34
location. el inicial no de count, el machine type es 2 medium, ya que GKR
1:22:41
que era un poco más de RAM y el scope es la cloud, la Google Cloud Platform.
1:22:49
Entonces ahora aquí si nos vamos a CD GKE
1:22:56
hacemos un Terraf.
1:23:11
Bueno, vamos a hacer lo siguiente. Vamos a mover
1:23:17
esto adentro de setup terzo.
1:23:25
Entonces vamos a setup form
1:23:31
y a GKE y hacemos terraform init
1:23:44
y hacemos Terraform apply.
1:23:55
Vamos a mover el 10 a setup terraform
1:24:04
y vamos a cargarnos esta carpeta.
1:24:18
Nos dice que está. Ah, porque estamos sobre allá.
1:24:26
Vale, entonces aquí en Terraform sí que hacemos el terraform
1:24:32
apply.
1:24:37
Vale, está viendo todo lo que está refrescando el contenido.
1:24:43
Entonces ya nos dice que solamente va a crear esto porque lo del resto de archivos ya está creado
1:24:49
y le decimos que ya es está creing.
1:24:55
Entonces, aquí a lo mejor ya podemos empezar a ver la
1:25:15
podemos ver que se está creando. Vamos a esperar un poco y mientras voy a
1:25:21
ir creando
1:25:27
ahora sí una carpeta en esta altura de Google Cubernetes Engine
1:25:34
y voy a crear un
1:25:40
QVCTL setup
1:25:45
sh. Ese es QCTL es el comando para comunicarse con el cluster de cubernetes
1:25:50
engine desplegado sobre Google Cloud. Entonces es un get credential de mi
1:25:57
cluster de GKE Z Central 1. Y también podemos añadir un getes.
1:26:21
Sigue creando.
1:26:28
Vale, ahora ya ha terminado de crearse el cluster. 5 minutos 17 segundos
1:26:34
y aquí ya están estado okay también. Entonces ahora ya vamos a lanzar los
1:26:40
comandos.
1:26:55
Tenemos que instalar el plugin
1:27:05
que nos dice que ha sido generado, no está reconocido.
1:27:13
Vamos a instalar el plugin
1:27:24
y es este el comando.
1:27:36
Decimos que sí
1:27:41
está instalando el GKG Cloud Login.
1:27:46
Voy a dejar también por aquí el comando.
1:28:12
Datón. Vale, entonces ahora volvemos a lanzar el get credentials.
1:28:20
Nos dice que ya está. Entonces hacemos ya el cub
1:28:26
ctl getes.
1:28:45
Tenemos que instalar también. Lo voy a dejar aquí.
1:28:58
Decimos que ya es de nuevo.
1:29:09
está descargando, instalando y postrocessing.
1:29:28
Terminado. Entonces ahora sí que ya podemos hacer un get name spaces.
1:29:36
Y aquí nos salen varios.
1:29:41
Y también podemos hacer un get notes. Y aquí está GKM cluster, que es el que
1:29:49
creamos aquí con con Terreform. Pues como siempre vamos ya a comitar los
1:29:56
cambios curso 10 y sincronizamos.
Kubectl, Deployments y Load Balancers
1:30:03
Ejercicio 11. Objetos de cubernetes, pods, services y exposición. Dentro de
1:30:10
cubernetes, la unidad mínima no es el contenedor, es el poz. Un poz puede tener uno o varios contenedores. El
1:30:16
problema es que los pods son efímeros. Si un poz muere y renace, su dirección IP interna cambia. No puedes confiar en
1:30:24
ella. Para solucionar esto, utilizamos el objeto service. Un service es una dirección IP estable y un velocidad de
1:30:31
carga interno que reparte la carga a los diferentes bots, tengan la IP que
1:30:36
tengan. Para exponer una AP a internet, cambiamos el tipo de servicio al OT Balancer, lo que aprovisiona una IP
1:30:43
externa real de Google Cloud. En la práctica vamos a desplegar engins y haremos que sea accesible desde vuestro
1:30:50
navegador.
1:31:06
Ahora, una vez que tenemos un clúster de cubernetes engine creado, lo que vamos a hacer va a ser levantar un servicio en
1:31:12
este clúster, que va a ser un engins para tener un un web server al que
1:31:17
acceder vía página web. Entonces, nos vamos al editor de código
1:31:23
y aquí en GKE vamos a crear un un nuevo archivo que será creatervice.
1:31:34
SH. y tendrá estos comandos de cube ZTL.
1:31:42
Vamos a crear un deployment que se va a llamar app con la imagen deix test
1:31:49
y luego los vamos a exponer a través de un lot balancer en el puerto 80
1:31:56
y después podremos hacer un get services. Entonces vamos a lanzar el create
1:32:03
deployment.
1:32:08
nos dice que ya está creado y ahora vamos a exponer.
1:32:17
nos dice que ya está expuesto y ahora hacemos un get services
1:32:24
y vemos que tenemos la en Kingspap en este cluster y que la external IP
1:32:34
está está pendiente todavía. Tenemos que esperar un poco.
1:32:42
También podemos hacer un cube ctl get po
1:32:49
y vemos que hay un pot running de la engings app desde hace 42 segundos.
1:33:05
Ahora ya tenemos la externa IP, nos la copiamos
1:33:10
y aquí en el navegador deberíamos poder acceder a ella.
1:33:30
Y aquí está, tenemos el welcome tox que verifica que está funcionando correctamente.
1:33:38
Entonces, por último, pues nos vamos a a
1:33:44
comitar los cambios. Curso 11. Sincronizamos
1:33:50
y bueno, si nos venimos aquí ya debería estar creada
1:33:56
la carpeta GKE con el Create Series SH y los comandos
1:34:01
que acabamos de ver. Ejercicio 12, Cloud Run, la joya de la
Cloud Run (De contenedor a URL en segundos)
1:34:06
corona. ¿Qué pasa si tengo un contenedor, pero no quiero el lío de administrar cubernetes? La respuesta es
1:34:12
Cloud Run. Cloud Run es Serverless Container Execution. Tú le das a Google
1:34:17
tu contenedor de Docker y él te da una URL https segura. Ventajas clave. Scale
1:34:24
to cero. Si nadie visita tu web a las 3 de la mañana. Google apaga todas las instancias y no pagas nada. Cero. Y
1:34:32
concurrencia. De las funciones antiguas, una instancia de Cloud RAM puede atender hasta 80 peticiones a la vez. Es ideal
1:34:39
para API Rest, webs y microservicios stateless sin estado. Vais a ver qué
1:34:45
rápido es en la siguiente práctica. Con un solo comando de GCloud tendremos una app productiva con certificado SSL
1:34:53
incluido. En este ejercicio lo que vamos a hacer va a ser crear nuestro primer contenedor
1:34:59
con cloud Run con una imagen de contenedor predefinido.
1:35:07
Entonces aquí si nos vamos a servicios vemos que no tenemos ningún servicio.
1:35:14
Podríamos aquí implementar un contenedor o conectar un repositorio o escribir una
1:35:19
función que veremos en otro ejercicio. Entonces, lo vamos a hacer a través de
1:35:24
comandos y nos ven unimos a nuestro código y vamos a crear
1:35:30
una carpeta que sea Cloudra.
1:35:35
Vamos a crear un archivo que sea
1:35:41
cloud rang deploy.sh
1:35:48
el comando va a ser este. Vamos a hacer un GCloud R deploy de mi servicio RAN,
1:35:54
que es como le vamos a llamar, con la imagen de Google Samples Hello
1:36:02
App y vamos a permitir que se pueda acceder de forma un
1:36:08
authenticate, o sea, que no hace falta autenticarse para acceder.
1:36:13
Entonces, si lo lanzamos aquí,
1:36:21
nos dice que tenemos que habilitar la API de Cloud Run. Le decimos que ya es
1:36:26
está habilitando la API y luego desplegará el contenedor. Ahí está desplegando el nuevo servicio.
1:36:35
Vamos a ver aquí si lo podemos ver ya. Y aquí está levantando el servicio de
1:36:41
acceso público y nos dice que lo ha implementado. Está
1:36:47
levantado ya. Y para acceder a este contenedor se accede con este URL que
1:36:53
tenemos aquí o que también nos la ha devuelto aquí,
1:37:00
nos la podemos copiar. Entonces, si ahora accedemos a ella, vemos que es un simple hello world para
1:37:08
demostrar cómo se cómo se haría. Entonces, aquí también podrías ver la fuente, pero simplemente con una imagen
1:37:15
podrías crear tu propio código y tenerlo aquí. Y aquí tienes la observabilidad también.
1:37:24
Y eso sería todo para desplegar un contenedor en cloud run predefinido.
1:37:29
Entonces, vamos a subir el código. Curso 12.
1:37:36
Comiteamos, sincronizamos los cambios.
1:37:42
Entonces, ahora aquí ya vemos nuestra carpeta de cloud run con el comando.
Cloud Functions Gen 2 (Event-Driven)
1:37:49
Ejercicio 13, cloud functions, event driving. Mientras cloud run es para apps
1:37:55
completas, cloud functions es como si fuese un pegamento. Son pequeños fragmentos de código que reaccionan a
1:38:02
eventos. ¿Qué es un evento? Un archivo subido a storage, un mensaje en Papsap o
1:38:08
una llamada http. Mira este ejemplo práctico. Queremos que cada vez que alguien suba una imagen a un bucket se
1:38:14
genere una miniatura automáticamente. No vas a tener un servidor encendido 24 horas esperando a que lleguen imágenes.
1:38:21
Usas una cloud function que se despierta, procesa y se vuelve a dormir. Vamos a hablar de la generación dos de
1:38:28
cloud functions, que por debajo utiliza Cloud Run, dándonos más tiempo de ejecución y más potencia. En la práctica
1:38:35
vamos a crear una cloud function que responde a HTTP. y que el código está en Python para
1:38:41
entender todo el ciclo de vida. Pues ahora en este siguiente ejercicio lo que vamos a hacer va a ser despegar una
1:38:47
cloud function a través de cloud run. Antes eran servicios separados por algo
1:38:52
se han unificado y sería aquí en servicios lo que sería
1:38:59
escribir una función. Puedes tener tu propio código en Python, en JavaScript, en lo que
1:39:06
quieras. Entonces nos vamos al editor
1:39:12
y aquí dentro de Cloud Run va a ser vamos a crear una carpeta que se va a llamar función de prueba y dentro de
1:39:20
esta carpeta un archivo main.plegar P porque vamos a desplegar código Python
1:39:26
y hay que añadir el requirements punxt
1:39:34
y también un deploysh
1:39:46
deploy.shes SH. Entonces, aquí en el main vamos a tener el código.
1:39:53
Hay que hacer un importe functions framework y decirle que va a ser http y este es el nombre de la función.
1:39:59
Simplemente nos va a imprimir un hola desde GCP Cloud Functions.
1:40:05
El requirement lo podemos dejar vacío porque como bien sabéis con Python, bueno, pues las librerías que vayas
1:40:10
importando que que se instalan con PIP Install, si las metes en el requirements
1:40:16
eh ya se van a desplegar por defecto. Y aquí en el
1:40:22
en el deploy.shsh vamos a añadir el comando. es GCloud functions deploy función
1:40:29
prueba. Es el nombre de la función.
1:40:37
Le decimos generación dos, que son las nuevas que tienen más potencia y pueden estar más tiempo ejecutándose. El Run
1:40:45
Python 3.10, la región US Central 1, el código le
1:40:52
decimos qué punto porque es el código donde estamos. Entonces vamos a tener que ir aquí a CD
1:41:00
Cloudrun barra función prueba.
1:41:08
CD función prueba.
1:41:13
Entonces el entry point es el hellow http que es esto de aquí.
1:41:20
El trigger va a ser http y vamos a de nuevo a permitir un authenticate para
1:41:26
que quien pueda pueda pueda acceder a él.
1:41:31
Entonces es cierto que tenemos que quitar esto
1:41:39
para que funcione en la de Windows.
1:42:16
Lanzamos el comando, nos dice que esta AP no está habilitada
1:42:21
y decimos que ya es que la habilitamos.
1:42:35
Ya está habilitado el servicio. Debería empezar a crearse la función. Necesita
1:42:45
otrai.
1:42:51
Cloud build. Está habilitando el servicio. Finish
1:42:57
successfully. Y ahora sí ya está desplegando la función.
1:43:09
Podríamos ver en Cloudville cómo se cómo se está desplegando, que nunca
1:43:15
hemos entrado todavía.
1:43:24
Bueno, está todavía en el deploying. Cuando empiece el build debería salir aquí.
1:43:41
Ahora que nos dice building progress, ya lo vamos a poder ver aquí.
1:43:49
Vemos que ya ha terminado en 33 segundos y que hizo tres pasos. Y bueno, aquí
1:43:55
está un poco la información. A ver si volvemos a Cloud Run.
1:44:03
servicios ya está desplegado y de nuevo nos da un RL
1:44:10
que nos lo copiamos, pero que
1:44:17
que la podemos consultar aquí también ahora desde GP cloud functions es
1:44:22
correcto. Y bueno, luego ya podríamos venir aquí editar el código.
1:44:32
Vamos a por el curso y a guardar. Voy volver a implementar.
1:44:41
Y ahora se está implementando. Hay que esperar que esto esté listo.
1:44:49
Ha creado ya compilado. Ahora está esperando a
1:44:54
enrotar el tráfico. Ya terminado. Entonces ahora si entráramos de nuevo
1:45:00
vemos que ya escribe lo de Vamos a por el curso. Entonces, por último, vamos a hacer el
1:45:09
commit, curso 12, sincronizamos cambios
1:45:17
y ya deberíamos ver aquí nuestra función, función de prueba y todo el código.
Lifecycle Rules en Cloud Storage (Ahorra dinero)
1:45:24
Módulo 4, almacenamiento y datos. Ejercicio 14, cloud storage y clases de
1:45:30
almacenamiento. Cloud Storage es un servicio para el almacenamiento de objetos. Piensa en archivos, no en
1:45:36
bloques de disco. Es inmutable. Si editas un archivo, en realidad lo estás
1:45:42
sobrescribiendo por completo. Lo más crítico para el bolsillo son las storage classes. Hay la estándar, son datos
1:45:49
calientes de acceso diario. La Nearline, datos tibios que se acceden sobre una
1:45:56
vez al mes. Son los backups más recientes. Calline, datos fríos, acceso de una vez cada
1:46:03
trimestre. y archive. Datos congelados son datos para crear histórico, que
1:46:09
pueden llevar años sin tocarse y que están preparados por si hay alguna auditoría. Cuanto más frío es el almacenamiento, más barato es guardarlo,
1:46:17
pero también es más caro leerlo. Las life cycle rules permiten decir, si el archivo tiene más de 30 días, pásalo a
1:46:25
callline directamente. En la práctica vamos a configurar un backet inteligente utilizando Terraform.
1:46:36
Pues en este ejercicio lo que vamos a hacer va a ser crear un bucket de cloud storage con una
1:46:44
regla que a los 30 días elimine los archivos. Entonces es un backet que va a trabajar de esa forma. Los archivos se
1:46:50
almacenan durante 30 días y luego desaparece. Así no se disparan los costes y se mantiene
1:46:59
y se mantiene los archivos más controlados. Entonces si vamos a cloud Storage,
1:47:05
a los buckets, eh, bueno, tenemos este par creados por
1:47:12
Cloud Run, yo creo, CFG Cloud Functions, seguramente sean de Cloud Run los dos.
1:47:18
Entonces, nosotros lo vamos a hacer con Terraform. Venimos al editor y vamos a crear aquí
1:47:27
setup terraform, un nuevo archivo que sea storage.
1:47:37
Y el código es este, resource Google Cloud Storage Backet. Vamos a crear un packet de autoexpire. Un paquet es un
1:47:43
sitio donde puedes almacenar cualquier tipo de de fichero
1:47:49
y el nombre es mi betaet único 1 2 3 4 5 debe ser único globalmente, así que a lo
1:47:54
mejor tenemos que cambiar luego el nombre. Y aquí está la life cycle rule que a los
1:48:02
30 días le hace un delete.
1:48:07
Entonces si nos vamos a setup Terraform, hacemos un Terraform
1:48:16
apply.
1:48:21
está refrescando el estado de todo lo que ya llevamos creado.
1:48:26
No había guardado el archivo. Nos dice que está todo bien. Ahora va a detectar cambios
1:48:34
en el store HTF y va a crear el backet. Decimos yes
1:48:43
y nos dice request backet name is not available. Lo tenemos que cambiar.
1:48:48
Mi backet túnico. GCP
1:48:55
Cloud Engineer C. A ver si ahora ya nos deja.
1:49:08
Decimos queas. Vale, ahora sí. y ya lo ha creado.
1:49:14
Entonces, ahora aquí si actualizamos está aquí nuestro paquet único
1:49:20
y en la configuración del ciclo de vida
1:49:27
vemos aquí ya la regla 30 o+s 10 desde que se creado el objeto.
1:49:34
Y eso sería todo. Vamos a subir los cambios. Curso 14.
1:49:42
Comiteamos, sincronizamos cambios y comprobamos que aquí en setup
1:49:50
terraform ya está el storage
Subida de archivos programática (Python script)
1:49:57
ejercicio 15 interactuando con API a través de las librerías de cliente. Para
1:50:03
ser cloud engineer tenemos que asumir que tenemos que saber programar por lo menos un poco, no basta con la consola.
1:50:09
Para comunicarse con Google Cloud a través del código, Google recomienda las
1:50:15
clientaries. Son librerías oficiales para Python, Go, Java, etcétera, que
1:50:20
manejan la autenticación y los reintentos por ti. ¿Cómo se autentica tu código localmente? utilizando las
1:50:27
application default credentials. Cuando lanzas el comando Gcloudout application default login se crea un archivo de
1:50:34
Jason en tu PC que las librerías leen automáticamente. Así no tienes que pegar claves secretas en tu código, que es una
1:50:41
mala práctica. En la práctica escribiremos un script de Python para subir archivos a la nube utilizando
1:50:48
estas librerías. Vale, ahora en este ejercicio lo que vamos a hacer va a ser a través de código Python subir archivos
1:50:54
desde nuestro ordenador local hacia el backet de cloud storage que acabamos de
1:51:00
crear con Terref en el ejercicio anterior. Entonces, bueno, vamos al backet
1:51:09
y vemos que está vacío. Entonces ahora
1:51:15
nos vamos al editor de código y vamos a crear una carpeta que sea
1:51:25
Cloud Storage y vamos a crear un archivo que sea
1:51:33
upload Googlecloudstorage.p F y es el siguiente código.
1:51:43
Tenemos una función upload block. Eh, levanta el storage client, coge el
1:51:49
bucket name que le mandemos y le y le dice el destination block name,
1:51:56
que será un archivo que vamos a crear aquí, por ejemplo. De hecho, vamos a crear ya el archivo
1:52:03
test.txt. Le hicimos mi primer archivo
1:52:10
en Google Cloud Storage.
1:52:21
Entonces aquí me voy a el el nombre del backet
1:52:30
y hacemos un import AR.
1:52:40
Y ahora aquí tenemos el código. Entonces, si nos vamos ya
1:52:47
CD Cloud Storage y hacemos un Python 3 upload gcs.p.
1:52:59
nos dice que falta backet name, source file name y destination block name.
1:53:09
Entonces, backet name lo tenemos aquí copiado. Source file name le vamos a
1:53:16
poner test txt y destination. Pues mira, vamos a
1:53:24
poner eh archivos txt/test.txt.
1:53:38
Archivotest.txt subido archivos/test.txt. Entonces aquí si actualizamos
1:53:49
vemos que nos crea una carpeta y mete aquí el 3.txt
1:53:58
y si nos lo abrimos con la URL pública, que no sé si podremos, no está
1:54:03
habilitado, pero bueno, lo podemos descargar si queréis. Y llevamos aquí mi primer archivo en GCS.
1:54:13
Podríamos también arrastrarlo simplemente, pero bueno, esto es para tener código Python con el que
1:54:19
automatizar operaciones en Cloud Storage. Entonces vamos a comitar ya los cambios.
1:54:26
Curso 15. Sincronizamos
1:54:34
y verificamos que efectivamente está en nuestro repositorio.
1:54:41
Ejercicio 16, Cloud Sequel, base de datos relacional. Cloud Sequel es el
Cloud SQL (PostgreSQL)
1:54:47
servicio autogestionado de Google Cloud para Myse Sequel, Postgrace Sequel y
1:54:52
Sequel Server. Gestionado significa que Google se encarga de los parches de seguridad. la actualización del
1:54:58
software, los backups y la configuración del sistema operativo. Los puntos claves
1:55:04
son el escalado y la alta disponibilidad. Es un servicio que escala verticalmente a través de CPU y
1:55:10
de RAM. Si necesites escalado horizontal, lo que sería levantar más instancias, la
1:55:17
respuesta es Cloud Spanner, no cloud sequel. Y la alta disponibilidad high ability. Si la activas, Google crea una
1:55:24
instancia standby en otra zona. Si la primaria falla, la IP se mueve automáticamente a la instancia de
1:55:31
standby. En esta práctica vamos a levantar una base de datos de Postg SQL y veremos las opciones de configuración.
1:55:43
En este ejercicio vamos a crear, vamos a crear
1:55:50
un cluster de cloud sequel, que es la base de datos relacional por defecto de Google Cloud para SQL Server,
1:55:58
para MySQL y para Postgr SQL.
1:56:03
Entonces, si nos unimos aquí a Cloud Sequel,
1:56:13
vemos que nos dejaría comenzar desde cualquiera de estas tres.
1:56:18
Podríamos migrar una base de datos también y nos deja crearlo sin coste durante 40
1:56:25
días con un MySQL, pero nosotros lo vamos a hacer por línea
1:56:31
de comandos. Entonces vamos a crear un archivo que va a ser
1:56:38
cloud sequel create. SH y el comando es este.
1:56:46
Cloud SQL instances create mi instancia de SQL.
1:56:53
Vamos a quitar los saltos de línea.
1:56:58
Vamos a decir que es un Postgris 14. una CPU, 4 GB de memoria, US Central 1 y
1:57:06
de root password sreto. Entonces ahora si lanzamos el comando
1:57:16
nos pide habilitar una API, decimos que
1:57:21
una vez habilite la API va a empezar a desplegar el claster.
1:57:32
Está creando la instancia y si nos venimos al servicio, no sé si lo podremos ver ya.
1:57:43
Ahí está levantando mi instancia de SQL de tipo postg SQL 14.
1:57:49
Vale, ahora vemos que ya terminado. Nos dice created, mi instancia de SQL P SQL
1:57:55
14 en central 1 con este tier de 4 GB de
1:58:01
memoria y esta dirección. Pues aquí si refrescamos,
1:58:08
aquí vemos que la tendríamos y bueno,
1:58:14
podríamos ya tener nuestra base de datos SQL que podría servir a aplicaciones.
1:58:20
Vamos a
1:58:25
vamos a borrarla porque esto sí que la verdad que consume bastante
1:58:31
créditos y como no la vamos a utilizar más en el curso, ya la vamos a borrar.
1:58:40
Vale, vamos a subir el código del comando.
1:58:46
Curso 16.
1:58:51
Sincronizamos cambios
1:58:57
y listo.
1:59:03
Ya se ha eliminado. Y ahora vamos a ver que que esté creado el archivo
1:59:10
create. Aquí está. Curso 16.
BigQuery y Datasets con Terraform
1:59:20
Ejercicio 17, Big Query, Data Warehousing. Big Query es probablemente
1:59:25
el producto más diferenciador de Google. Es un data warehouse serverless capaz de
1:59:31
analizar petabytes en segundos utilizando SQL. A diferencia de una base de datos normal, MBQ no gestiona índices
1:59:38
ni particiones físicas de la misma manera. En su arquitectura interna, el almacenamiento conocido como Colossus
1:59:46
está separado del cómputo llamado Borg. Esto significa que puedes tener terabytes almacenados pagando muy poco y
1:59:53
el procesamiento solo lo pagas cuando lanzas una consulta. La estructura es proyecto, creas un dataset en BQU y ahí
2:00:00
metes tus tablas. En esta práctica vamos a utilizar Terrafone para crear un entorno de análisis de datos.
2:00:07
Vale, ahora en este ejercicio vamos a crear nuestro primer T7 en BQU con una tabla vacía y definiendo un esquema con
2:00:15
Terrafone. Entonces, si nos venimos aquí a Big Query,
2:00:22
vamos a ver que está que no tenemos datasets. Debería haber
2:00:29
aquí una parte que puede ser conjunto de datos. Podríamos crear un conjunto de datos desde aquí, pero lo vamos a hacer
2:00:36
con terro. Entonces, nos vamos al editor de código y aquí en setup terraf vamos a
2:00:43
crear unquerf y el código es el siguiente. Vamos a
2:00:50
crear un recurso Google BQU dataset, mi dataset para reportes y location US.
2:00:58
Y luego también vamos a crear una tabla en el Google BQU Dataset que se va a
2:01:04
llamar resumen de ventas y cuyo esquema va a ser una columna producto de tipo
2:01:10
string y que es require y una columna cantidad de tipo integer que no es
2:01:16
required. Entonces nos vamos a setup Terraform
2:01:24
Terraform Apply. Antes voy a guardar el archivo.
2:01:37
Y aquí ya nos dice que va a añadir dos, una tabla y un dataset.
2:01:44
Esto creo que va a ser muy rápido. Ahí está. Es que viquery es un servicio muy
2:01:50
muy rápido. Entonces, ahora aquí si actualizamos el contenido, ya nos sale el dataset y la tabla
2:01:58
con las dos columnes que dijimos. Y si aquí quisiéramos hacer, por ejemplo, un insert into
2:02:07
resumen ventas mi dataset report
2:02:19
resumen ventas vales
2:02:26
y creo que sería un producto
2:02:33
camiseta uno.
2:02:42
Vale, se agregó una fila. Entonces, ahora aquí en la vista campeta puse
2:02:50
si por ejemplo si solo le ponemos ahora sí bien camiseta,
2:02:57
nos va a dejar insertar,
2:03:02
¿no? Porque necesito dos columnas. Camiseta 50.
2:03:15
Eh, entonces ahora podemos hacer un select allol from
2:03:29
y ahí tenemos nuestras nuestras camisetas. Voy a copiar los comandos que lancé
2:03:39
para dejarlos por aquí también en en
2:03:45
un archivo BQU
2:03:51
SQL. Dejamos el selector
2:03:58
y el insert.
2:04:04
Y eso sería todo por parte de desplegar datasets y tablas en BQU con Terraf.
2:04:12
Entonces, ya vamos a comitear. Curso 17.
2:04:19
Comiteamos, sincronizamos cambios. Y vamos a verificar.
2:04:26
Está aquí el bquery.sql y también debería estar el bquery.
2:04:32
Correcto. Módulo 5, operaciones. Ejercicio 18,
Monitorización y Uptime Checks
2:04:38
cloud monitoring y uptime checks. Los ingenieros no podemos arreglar lo que no sabemos si está roto. Cloud monitoring
2:04:45
es la suit de observabilidad. Una de las herramientas favoritas es el UPTime Check. Google tiene servidores en todo
2:04:51
el mundo. Puedes configurar un apptime check para que servidores de Singapur,
2:04:56
Virginia y Frankfurt intenten cargar tu web cada minuto. Si falla, devolviendo
2:05:02
un error 400 o un 500 o incluso si tarda mucho, se dispara un alert policy que te
2:05:08
avisa por email, Slack, SMS. Es monitoreo de caja negra. Vigila lo que
2:05:14
ve el usuario final. En la práctica vamos a poner un vigilante 247 a nuestro servidor web.
2:05:20
Vale, en este ejercicio vamos a trabajar con cloud monitoring y vamos a desplegar a través de Terrafone. Pero bueno, vamos
2:05:26
a irnoslo abriendo. Aquí es la suit de servabilidad de Google
2:05:32
Cloud. Nos venimos aquí a paneles, pues bueno, hay unos paneles ya predeterminados de
2:05:39
sobre esto. Vemos que no hay incidentes en BQU ni nada.
2:05:46
Por ejemplo, de Cloud Storage, igual podemos ver algo.
2:05:53
Request aquí cuando subimos el archivo, otro ejercicio.
2:05:59
Bueno, un poco eso. Podemos monitorear todos los servicios que fuimos levantando. Wernet engineerabilidad
2:06:07
de convernet engine, pues vemos que sí que está levantado.
2:06:12
optimización de costos nos sugerirá cosas. Y bueno, nos vamos ya al código.
2:06:20
Vamos a crear aquí un nuevo archivo,
2:06:26
perdón, aquí no, aquí
2:06:31
que será monitoring. Terraform y aquí vamos a crear un resource de
2:06:38
Google Cloud Monitoring Upime Check. se va se va a a ver así con este nombre.
2:06:46
Y cuando hay un time out de 10 segundos, cada 60 eh comprueba que la
2:06:55
up real está okay. El monitor resource tenemos que poner
2:07:01
aquí cloudir
2:07:07
curso 01. y la IP de la máquina monitorear.
2:07:14
Podríamos monitorear el cluster de cubernetes
2:07:19
o podemos ir a compute engine
2:07:28
a nuestras instancias. Tenemos aquí la de servidor web.
2:07:35
Copiamos la IP externa. y le pegamos aquí.
2:07:47
Dejo aquí el comentario de que pongáis la IP que os corresponda.
2:07:53
Entonces, ahora ya podemos hacer un Terraform apply
2:08:03
y le decimos y
2:08:08
vale, ya lo ha creado. Ahora en monitoring.
2:08:39
Aquí en los aquí en los verificadores tenemos nuestro http upptime check
2:08:52
y el nombre del host es este y lo revisa cada 60 segundos.
2:08:59
Todavía no hay datos disponibles. Vamos a esperar unos minutos.
2:09:07
Vale, ahora mismo nos dice que el currente estutus es que no puede llegar al host.
2:09:39
Vamos a poner la IP interna Terraforma Play
2:09:51
y va a reemplazar lo que es esta
2:09:56
este uptime check y de nuevo nos da todo en rojo. Algo
2:10:03
estamos configurando mal en este upptime check, seguramente sea la región.
2:10:12
Entonces sería en el Terrafone cambiar la región y ya estaría la región en la
2:10:18
que esté la instancia levantada. Entonces, como siempre, vamos a comitear curso 18
2:10:27
y sincronizar cambios.
2:10:37
Y ahora si nos venimos aquí a al repositorio de código,
2:10:44
ya tenemos nuestro monitoring.tf. Ejercicio 19. Cloud logging y sence.
Exportando Logs a BigQuery (Auditoría)
2:10:51
Exportación. Todos los servicios de GCP generan locks. Cloud loging es el servicio que los centraliza. Pero hay un
2:10:58
problema, la retención y el análisis. Los locs de tu aplicación suelen almacenarse solamente durante 30 días.
2:11:05
¿Qué pasa si necesitas investigar un hackeo de hace 6 meses? Necesit un lock sign. Un router es una tubería que envía
2:11:12
los logs para almacenamiento a largo plazo a otro servicio. A cloud Storage, que es barato y que sirve para hacer
2:11:19
auditorías, a Big Query, que permite hacer consultas en SQL, cuántos errores
2:11:24
500 hubo el martes, Papsap para enviarlo a un sistema de almacenamiento externu,
2:11:30
por ejemplo. En esta práctica vamos a configurar la exportación de logs de error automáticamente a BQU.
2:11:38
Vale, en esta práctica vamos a exportar a Big Query todos los blogs de cloud
2:11:43
login que hayan que sean de error, o sea, que se verity
2:11:49
sea error. Entonces, si nos vamos a cloud login,
2:11:54
está integrado dentro de monitoring. Entonces aquí vemos todo lo que ha ido
2:12:00
ocurriendo y si le damos error vemos que hay todos estos logs. La mayoría son de
2:12:06
BQY, alguno de Engins, eh alguno de el cubernetis engine agent.
2:12:16
Entonces, bueno, tenemos varios la de error. Entonces, aquí en el código vamos a
2:12:22
utilizar un comando de GCO y vamos a poner cloud login export.sh SH
2:12:33
y el comando es el siguiente. Cloud login Synx Create, mi exportación ABQ
2:12:40
y le indicamos aquí en nuestro proyecto CCP Cloud
2:12:45
Engineer curso 01 y med reportes que fue el que creamos en otro ejercicio.
2:12:54
Entonces, vamos a quitar los saltos de línea y vamos directos a lanzar el comando.
2:13:09
Vemos que le metemos el log filter con severity error, como decíamos.
2:13:16
Vale, ha creado mi exportación de BQ.
2:13:23
Entonces ahora vamos a ir a BQU.
2:14:03
nos dice que tenemos que darle a este service account GCPSA
2:14:10
login el rol de data editor en BQU. Entonces, ahora como ya sabemos lo que
2:14:16
es, podemos ir a M
2:14:21
y le vamos a dar el rol de BQU editor. A,
2:14:29
¿qué service acá nos decían? Service-980.
2:14:38
Vamos a cuant de servicio.
2:14:57
Vamos a crear una cuenta de servicio.
2:15:17
Crear y continuar. Y ahora aquí buscamos BQU editor,
2:15:27
editor de datos de BQU y listo.
2:15:35
Entonces ahora aquí ya vamos a ver la service account.
2:15:45
Vamos a hacer el cloud login sing de nuevo
2:15:51
y dice que sin mi exportación BQ already exists.
2:15:58
Vamos a lanzarlo ahora sin el Severity Terror.
2:16:16
Y le vamos a cambiar a mi dataset synx.
2:16:28
decir que no existe el dataset
2:16:37
exportación Q2
2:16:45
nos va a decir que no existe el dataset,
2:16:51
pero con nuestro código de Terraform.
2:16:56
Ah, nos dice que ya lo ha creado.
2:17:03
Vale, entonces ahora sí vamos a actualizar.
2:17:10
Vale, pues todavía no se pueden ver los logs del Sync, así que vamos a terminar
2:17:16
por subir los cambios y sincronizarlos. Y
2:17:21
así ya nos queda el comando guardado. Y nos venimos a
2:17:28
aquí al perfil de Git, ya vamos a ver nuestro
2:17:36
nuestro cloud login es porsh. Ejercicio 20, limpieza, cleanup y
LIMPIEZA TOTAL (¡Importante para no pagar!)
2:17:42
gestión de costes. Llegamos al final. La nube es maravillosa, pero cobra por segundos. Un ingeniero cloud profesional
2:17:49
siempre limpia su mesa de trabajo. Aquí es donde la infraestructura como código Terrafone brilla con fuerza. Si
2:17:56
hubiéramos creado todo esto haciendo clic en la consola, tardaríamos una hora en encontrar y borrar cada recurso y
2:18:03
seguro que nos olvidaríamos de un disco huérfano que nos costaría dinero. Con Terraf tenemos un comando mágico,
2:18:10
Terraform Destroy. Este comando lee el estado actual, mira lo que ha creado y lo destruye en el orden inverso
2:18:16
correcto. Primero las máquinas, luego la red. En la práctica vamos a destruir todo lo que hemos creado utilizando un
2:18:23
único comando y vamos a verificar que la facturación se detiene.
2:18:29
Llegamos al último ejercicio y aquí lo que vamos a hacer va a ser limpiar todos los recursos que tenemos levantados en
2:18:34
Big Query y eliminar el proyecto para asegurarnos de que no haya ningún problema de facturación.
2:18:41
Entonces, nos venimos al código y vamos a crear un archivo que sea clean
2:18:48
app. sh y vamos a hacer un terreform destroy
2:18:59
y luego vamos a borrar la distancia de SQL que yo la borré directamente desde
2:19:07
desde la interfaz, pero bueno, aquí se va a borrar también la cloud function, el cloud run y el cluster de cubernetes
2:19:14
que hemos creado durante este curso. Entonces, lo primero va a ser lo de
2:19:20
Terraform, Terrenform destroy con autoproof
2:19:28
y ahí va a estar eliminando todo, va a estar destruyendo todo. Vamos a ver qué
2:19:34
dice 12 recursos y vamos a repasar que es todo lo que va a cargarse Terraf.
2:19:42
un BQU dataset, un BQU table,
2:19:47
un computance template, que es el que utilizamos para crear el manage instance group, una VPC network,
2:19:55
un manage instance group, una subnetwork,
2:20:02
un Google Container Cluster, que estos cubernetes,
2:20:12
eh el app check del cloud monitoring para revisar que el servidor estaba
2:20:17
levantado, la app de cloud resource, de compute y
2:20:23
de container, el backet de auto spire que habíamos creado y ya está, sigue destruyendo
2:20:32
todo. Puede tardar unos minutos. Sin duda.
2:20:37
Y luego ya iremos a crear a ahorrar esto. Y yo creo que algunas creo que ya
2:20:42
estaban incluidas aquí o no. No, porque se debieron crear con comandos.
2:20:59
Le está costando destruir el MIG, por ejemplo.
2:21:09
Vale, Mig M. Destrucción del M completado. Ahora empieza con la team plate. Esto debería ser casi
2:21:15
instantáneo, yo creo. Ya la destruyó. La subnetwork no le
2:21:22
deja.
2:21:28
No me deja eliminar la tabla.
2:21:38
Del protection false.
2:21:45
Porque en el claster tenemos algunas cosas con apply. Bueno, ahora vamos a lanzar ya estos comandos.
2:21:56
Está eliminando la función. Ahora está eliminando el servicio de
2:22:03
Cloud RAM
2:22:08
y ahora está eliminando el cler de GKE.
2:22:17
Entonces, bueno, ahora si nos venísemos, por ejemplo, computen
2:22:28
saliendo dos virtual machine, que son las de uno es el servidor web de computer
2:22:34
engine, que lo podríamos, por ejemplo, aquí borrar
2:22:42
y luego el cluster de cubernetes, ¿qué es lo que se está parando desde aquí?
2:23:06
Entonces, bueno, vamos a ir subiendo el código. Curso 20.
2:23:15
Comiteamos y sincronizamos los cambios.
2:23:21
Vemos que está aquí ya nuestro clean up. SH.
2:23:27
Y bueno, por último sería desde aquí, desde estos ajustes,
2:23:34
podríamos eliminar el proyecto. Podéis ver que a mí, por ejemplo, me
2:23:39
pone ceros de facturación. A vosotros debería ser lo mismo y si no, incluso tenéis los 300 de prueba gratuita.
2:23:50
Y eso sería todo. Recuerda que en el comentario fijado tienes acceso a poder
2:23:57
descargar el código de cada clase para poder así añadirlo más fácilmente a
2:24:03
tu perfil de GitHub y a tu repositorio. Y también tienes acceso al banco de
2:24:09
preguntas que he creado para que puedas ir practicando por si decides acceder al
2:24:15
examen de Google Cloud Professional Data Engineer. Te recomiendo que le eches un
2:24:21
vistazo a todo porque hay información muy interesante. Hoy en día los reclutadores buscan pruebas reales.
2:24:29
¿Sabes lo que diferencia a alguien que solo estudió teoría de alguien que tiene su perfil de Githa? pues que consigue
2:24:36
más entrevistas. Cuando un técnico revisa tu perfil y ve que has construido
2:24:42
proyectos reales en Google Cloud, entiende perfectamente que vas a poder construir soluciones, no solo