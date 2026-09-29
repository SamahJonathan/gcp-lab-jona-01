#!/usr/bin/env bash
# =============================================================================
# ETAPA 9 - OS Login y el fin de las claves SSH repartidas
# =============================================================================
# NO es un script ejecutable. Es un cuaderno de copiar y pegar: los comandos van
# comentados y se lanzan en PowerShell quitando el # del principio.
#
# Apuntes: docs/apuntes-etapa-09-os-login.md
#
# La idea en dos lineas: sin OS Login, quien puede entrar por SSH es "quien
# tenga una clave en la metadata". Con OS Login, es "quien tenga el rol de IAM".
# Se pasa de una lista de llaves repartida por las maquinas a una sola fuente
# de verdad.
#
# COSTE: la VM del paso 0. El resto -metadata, OS Login, el perfil POSIX- es
# gratis. Borra la maquina al terminar la sesion.
# =============================================================================


# -----------------------------------------------------------------------------
# 0. Hace falta una VM encendida
# -----------------------------------------------------------------------------
# La de la etapa 6 se destruyo al cerrar la etapa 8, asi que se recrea. Desde la
# RAIZ del proyecto, porque la ruta del startup script es relativa a donde estes:
#
#   cd C:\Users\Joony\OneDrive\Documentos\proyectos_programacion\gcp-lab-jona-01
#
#   gcloud compute instances create servidor-web-1 --zone=us-east1-b --machine-type=e2-micro --subnet=subred-us-east1 --tags=web-server --metadata-from-file=startup-script=compute-engine/startup-script.sh
#
# El comando completo y el porque de cada flag, en compute-engine/create-instance.sh
#
# Espera a que este RUNNING:
#
#   gcloud compute instances list --filter="name:servidor-web-1"


# -----------------------------------------------------------------------------
# 1. El estado de partida: mira la metadata ANTES de tocar nada
# -----------------------------------------------------------------------------
#   gcloud compute project-info describe --format="value(commonInstanceMetadata.items[].key)"
#
#   Esperado ahora: vacio, o como mucho una clave ssh-keys.
#
# Merece la pena mirarlo antes para poder comparar despues. Si aparece ssh-keys,
# esa es exactamente la lista de llaves que OS Login viene a jubilar.


# -----------------------------------------------------------------------------
# 2. Activar OS Login en TODO el proyecto
# -----------------------------------------------------------------------------
#   gcloud compute project-info add-metadata --metadata enable-oslogin=TRUE
#
# Lo elegante del ejercicio: OS Login se enciende POR METADATA. Se usa el canal
# viejo de configuracion -el mismo por el que viajo el startup script de la
# etapa 6- para desactivar el sistema viejo de acceso.
#
# ### LAS DOS TRAMPAS DE ESTA LINEA ###
#
#   a) enable-os-login   <- MAL, y NO DA ERROR
#
#      La metadata es un almacen de clave-valor y NO VALIDA LAS CLAVES: acepta
#      cualquier texto y responde "updated" tan tranquila. El que decide si una
#      clave significa algo es el agente que la lee, y ese busca exactamente
#      enable-oslogin, sin guion entre os y login. Con el guion de mas, OS Login
#      se queda apagado y nada te avisa.
#
#      Es la misma familia de error que un region = "us-central" mal escrito:
#      campos de texto libre que nadie valida hasta que algo no funciona.
#
#   b) project-onfo      <- MAL, pero este SI avisa
#
#      gcloud no reconoce el subcomando, corta y hasta sugiere el correcto. Es
#      el error inofensivo de los dos, precisamente porque falla.
#
# Los dos niveles de metadata, por si algun dia chocan:
#
#   PROYECTO  (project-info add-metadata)   lo heredan todas las instancias
#   INSTANCIA (instances add-metadata)      solo esa, y GANA sobre el proyecto
#
# Para forzarlo en una sola maquina:
#
#   gcloud compute instances add-metadata servidor-web-1 --zone=us-east1-b --metadata enable-oslogin=TRUE


# -----------------------------------------------------------------------------
# 3. Entrar
# -----------------------------------------------------------------------------
#   gcloud compute ssh servidor-web-1 --zone=us-east1-b
#
# LA PRIMERA VEZ genera una clave propia de gcloud en C:\Users\Joony\.ssh\
# (google_compute_engine), distinta de la de GitHub. Pide una passphrase: pulsa
# Enter dos veces para dejarla vacia, como hace el video.
#
# Y fijate en lo que NO sale por pantalla:
#
#   "Updating project ssh metadata..."   <- con OS Login activo NO aparece
#
# Si aparece, es que OS Login no esta puesto: gcloud esta metiendo tu clave
# publica en la metadata del proyecto, o sea el sistema viejo.
#
# La prueba definitiva es el prompt de dentro de la maquina:
#
#   jona@servidor-web-1                    <- metadata (sistema viejo)
#   jona_samah_gmail_com@servidor-web-1    <- OS LOGIN
#
# Ese nombre lo deriva Google de jona.samah@gmail.com, con puntos y arroba
# convertidos en guiones bajos. Con una cuenta de Workspace seria solo
# jona_samah, sin el dominio.
#
# La primera vez veras tambien:
#
#   Creating directory '/home/jona_samah_gmail_com'
#
# Nadie creo esa cuenta a mano: Google fabrico el usuario POSIX -nombre, UID y
# home- en cuanto valido tu identidad contra IAM.


# =============================================================================
# 4. COMPROBACIONES DE LA ETAPA 9
# =============================================================================
# 4.1 La metadata quedo bien escrita:
#
#   gcloud compute project-info describe --format="value(commonInstanceMetadata.items)"
#
#   Esperado: aparece enable-oslogin con valor TRUE.
#   Si ves enable-os-login, vuelve al paso 2: sobra un guion.
#
# 4.2 LA del ejercicio, sin depender de leer el prompt:
#
#   gcloud compute ssh servidor-web-1 --zone=us-east1-b --command="whoami"
#
#   Esperado: jona_samah_gmail_com
#   NO jona (tu usuario de Windows) y NO root. Ese nombre ES la prueba de que
#   quien decide el acceso es tu identidad de Google, no una llave copiada.
#
# 4.3 El perfil POSIX que Google gestiona por ti:
#
#   gcloud compute os-login describe-profile
#
#   Devuelve el usuario, el UID, el GID y el home. Eso es lo que antes creaba a
#   mano un administrador en cada servidor.
#
# 4.4 Que la clave ya no manda (opcional, pero es el remate):
#
#   gcloud compute project-info describe --format="value(commonInstanceMetadata.items[].key)"
#
#   Si ssh-keys sigue ahi y aun asi entraste como jona_samah_gmail_com, esa es
#   la demostracion: la clave no desaparecio, DEJO DE DECIDIR.


# -----------------------------------------------------------------------------
# 5. Los roles: OS Login no manda mas que IAM, le PREGUNTA a IAM
# -----------------------------------------------------------------------------
#   roles/compute.osLogin        entrar por SSH, usuario normal, SIN sudo
#   roles/compute.osAdminLogin   entrar CON sudo
#
# Tu entras porque eres owner del proyecto, y owner ya incluye esos permisos.
#
# Ver quien tiene acceso hoy:
#
#   gcloud projects get-iam-policy gcp-lab-jona-01 --flatten="bindings[].members" --filter="bindings.role:roles/compute.os" --format="table(bindings.role,bindings.members)"
#
# Y ahi esta el valor de todo el ejercicio: revocar el acceso de alguien es
# quitarle un rol en IAM, UNA VEZ. Sin OS Login habria que borrar su clave
# publica de la metadata de cada proyecto y de cada maquina, y esperar que no
# quedara ninguna copia suelta.


# -----------------------------------------------------------------------------
# 6. LIMPIEZA - al cerrar la sesion
# -----------------------------------------------------------------------------
# Salir de la maquina:
#
#   exit        (y otro exit si habias hecho sudo -i)
#
# Y borrarla, que es lo unico que cuesta dinero aqui:
#
#   gcloud compute instances delete servidor-web-1 --zone=us-east1-b
#
# La metadata enable-oslogin puede quedarse: es gratis y deja el proyecto mejor
# de como estaba. Si quieres dejarlo como lo encontraste:
#
#   gcloud compute project-info remove-metadata --keys=enable-oslogin
#
# Comprobacion final, la del ejercicio 20:
#
#   gcloud compute instances list        # esperado: vacio
