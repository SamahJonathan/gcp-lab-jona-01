#!/usr/bin/env bash
# =============================================================================
# ETAPA 8 - Snapshots con Python
# =============================================================================
# NO es un script ejecutable. Es un cuaderno de copiar y pegar: los comandos van
# comentados y se lanzan en PowerShell quitando el # del principio.
#
# Entregable: compute-engine/backup_vm.py  (ESE SI se ejecuta)
# Apuntes:    docs/apuntes-etapa-08-snapshots.md
#
# Coste: bajo pero NO cero. Un snapshot se factura por lo que ocupa, y no
# caduca solo. Ver el bloque de limpieza al final.
# =============================================================================


# -----------------------------------------------------------------------------
# 0. Hace falta un disco vivo
# -----------------------------------------------------------------------------
# Un snapshot se saca de un disco, asi que las maquinas del MIG de la etapa 7
# tienen que seguir encendidas. Mira que discos hay y en que zona esta cada uno:
#
#   gcloud compute disks list --format="table(name,zone.basename(),sizeGb,type.basename(),status)"
#
#   Esperado: 2 discos app-XXXX de 10 GB, en zonas DISTINTAS de us-east1.
#
# El nombre del disco coincide con el de su maquina, pero son cosas distintas:
# el disco es almacenamiento en RED, no una pieza metida dentro del servidor.
# Por eso sobrevive a la maquina y por eso se puede fotografiar sin apagarla.
#
# Y comprueba que no hay snapshots todavia:
#
#   gcloud compute snapshots list        # esperado: vacio


# -----------------------------------------------------------------------------
# 1. La librería
# -----------------------------------------------------------------------------
# El script de la etapa 3 usaba googleapiclient.discovery, que se fabrica los
# metodos al vuelo y por eso no tiene autocompletado. Este usa la libreria
# cliente moderna, con clases de verdad:
#
#   pip install google-cloud-compute
#
# Comprobar que entro:
#
#   python -c "from google.cloud import compute_v1; print('OK')"


# -----------------------------------------------------------------------------
# 2. El primer snapshot
# -----------------------------------------------------------------------------
# Da igual la carpeta: el script busca el terraform.tfvars a partir de su propia
# ruta, no de donde estes tu. Desde la raiz del proyecto:
#
#   python compute-engine/backup_vm.py --disk app-p144 --zone us-east1-c
#
# o, si ya estas dentro de compute-engine/:
#
#   python .\backup_vm.py --disk app-p144 --zone us-east1-c
#
# LOS DOS ARGUMENTOS SON OBLIGATORIOS. Un disco es un recurso ZONAL: su nombre
# solo no lo identifica, podria haber un app-p144 en cada zona y serian discos
# distintos. Si los omites, argparse te para antes de tocar nada.
#
# app-p144 y us-east1-c son los de la sesion del 3 de septiembre. Las maquinas
# del MIG llevan sufijo aleatorio, asi que si el grupo las ha repuesto tendran
# otro nombre: sacalo del 'disks list' del paso 0.
#
# Tarda. Esta copiando 10 GB enteros. Apunta lo que diga en 'ocupa' y en
# 'tardanza', que son los dos numeros del ejercicio.


# -----------------------------------------------------------------------------
# 3. El segundo snapshot: LA MEDIDA DE VERDAD
# -----------------------------------------------------------------------------
# El MISMO comando otra vez, sobre el MISMO disco:
#
#   python compute-engine/backup_vm.py --disk app-p144 --zone us-east1-c
#
# Esperado: mucho mas rapido y ocupando una fraccion. No hace falta cambiar el
# nombre: el script le pone la fecha y la hora, asi que nunca choca.
#
# Eso es que los snapshots son INCREMENTALES. El primero copia el disco entero;
# el segundo solo guarda los bloques que cambiaron desde el anterior. Cada uno
# se restaura por si solo -no hay que ir encadenando-, pero por dentro comparten
# los bloques que no han cambiado.


# =============================================================================
# 4. COMPROBACIONES DE LA ETAPA 8
# =============================================================================
# 4.1 LA del ejercicio:
#
#   gcloud compute snapshots list --format="table(name,status,diskSizeGb,storageBytes)"
#
#   Esperado: 2 snapshots, los dos READY y con storageBytes > 0.
#
#   Compara la columna storageBytes de los dos. La diferencia ES el ejercicio.
#   Si el segundo sale a 0 o parecido al primero, espera unos minutos: GCP tarda
#   en cuadrar esa cifra y mientras tanto la da provisional.
#
# 4.2 De donde salio cada uno:
#
#   gcloud compute snapshots list --format="table(name,sourceDisk.basename(),creationTimestamp)"
#
# 4.3 Un snapshot es GLOBAL, no zonal. Fijate en que en ningun comando de arriba
#     hace falta decir la zona, al reves que con los discos. Esa es la clave de
#     como se mueve una maquina de continente:
#
#       disco en us-east1  ->  snapshot (global)  ->  disco nuevo en europe-west1
#
#     No se mueve una VM. Se fotografia su disco y se revela la foto en otro
#     sitio. El comando seria:
#
#   gcloud compute disks create disco-en-europa --source-snapshot=NOMBRE --zone=europe-west1-b
#
#     (no lo lances: crearia un disco que hay que pagar)
# =============================================================================


# -----------------------------------------------------------------------------
# 5. LIMPIEZA - los snapshots NO caducan solos
# -----------------------------------------------------------------------------
# Se facturan por lo que ocupan y se quedan ahi para siempre si nadie los borra.
# Es el goteo clasico de las facturas de GCP: nadie recuerda haberlos creado.
#
#   gcloud compute snapshots list --format="value(name)"
#   gcloud compute snapshots delete NOMBRE_DEL_SNAPSHOT
#
# OJO al borrar uno del que otro depende: GCP NO pierde datos. Antes de
# borrarlo, mueve los bloques que hagan falta al siguiente snapshot de la
# cadena. Por eso borrar un snapshot puede no liberar el espacio que esperabas.
#
# En un proyecto de verdad esto no se hace a mano: se pone una politica de
# retencion (resource policy) que los cree y los caduque sola.
