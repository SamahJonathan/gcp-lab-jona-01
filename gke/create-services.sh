#!/usr/bin/env bash
# =============================================================================
# ETAPA 11 - Deployment y LoadBalancer en el cluster
# =============================================================================
# NO es un script ejecutable. Es un cuaderno de copiar y pegar.
#
# ### SE EJECUTA DESDE CLOUD SHELL, NO DESDE ESTE PC ###
#
# En este equipo no hay kubectl y no se puede instalar: el SDK esta en
# C:\Program Files (x86) y "gcloud components install" pide permisos de
# administrador. Cloud Shell es una terminal Linux gratis dentro de la consola
# de GCP, con gcloud y kubectl ya instalados y ya autenticados con tu cuenta.
#
#   console.cloud.google.com  ->  icono >_  (arriba a la derecha)
#
# Apuntes: docs/apuntes-etapa-11-kubectl-loadbalancer.md
#
# COSTE: el cluster de la etapa 10 MAS el balanceador que crea el paso 3 (regla
# de reenvio + IP externa, del orden de 18 USD/mes). Las dos cosas se destruyen
# el mismo dia, y el ORDEN importa: ver el bloque final.
# =============================================================================


# -----------------------------------------------------------------------------
# 1. Apuntar kubectl al cluster
# -----------------------------------------------------------------------------
# Esto escribe ~/.kube/config con la direccion del control plane y como
# autenticarse. Sin esto, kubectl no sabe a que cluster hablar:
#
#   gcloud container clusters get-credentials cluster-lab --zone us-east1-c --project gcp-lab-jona-01
#
# us-east1-c, no la -b del resto del laboratorio: la -b no tenia e2-medium
# libres el dia que se creo el cluster. Ver la variable gke_zone.
#
# En Cloud Shell el gke-gcloud-auth-plugin ya viene puesto. En un PC normal hay
# que instalarlo aparte, y es el error que corta el ejercicio en el video.
#
# Comprobar que hay nodo y que es una VM como las del modulo 2:
#
#   kubectl get nodes
#
#   Esperado: 1 nodo, STATUS Ready, nombre gke-cluster-lab-default-pool-XXXX


# -----------------------------------------------------------------------------
# 2. El deployment: los pods
# -----------------------------------------------------------------------------
#   kubectl create deployment nginx-app --image=nginx:latest
#
# Un POD es la unidad minima de Kubernetes, no el contenedor: un pod puede tener
# varios contenedores que comparten red y almacenamiento. El DEPLOYMENT es quien
# vigila que haya tantos pods como pediste y los repone si mueren. Es el mismo
# papel que el MIG de la etapa 7, un nivel mas arriba: el MIG cuenta MAQUINAS,
# el deployment cuenta PODS.
#
#   kubectl get pods
#
#   Esperado: 1 pod, READY 1/1, STATUS Running.
#
# Compara con la etapa 6: la misma pagina de nginx costo crear una VM, escribir
# un startup script, poner un tag y abrir el firewall. Aqui es UN comando, y la
# imagen nginx:latest ya viene hecha de Docker Hub.


# -----------------------------------------------------------------------------
# 3. Exponerlo a internet
# -----------------------------------------------------------------------------
#   kubectl expose deployment nginx-app --type=LoadBalancer --port 80 --target-port 80
#
# El problema que resuelve: los pods son EFIMEROS y su IP cambia cada vez que
# uno muere y nace otro. No se puede apuntar a ella. Un SERVICE es una direccion
# estable que reparte a los pods que haya, con la IP que tengan.
#
#   --type=LoadBalancer   pide a GCP un balanceador de verdad, con IP externa.
#                         El tipo por defecto (ClusterIP) solo es alcanzable
#                         desde dentro del cluster.
#   --port 80             por donde entras tu desde fuera
#   --target-port 80      donde escucha nginx dentro del contenedor
#
# Los dos puertos coinciden aqui; si la app escuchara en 8080, esa seria la
# diferencia entre los dos flags.
#
# La IP tarda 1-2 minutos. Con -w el comando se queda mirando y escribe una
# linea cada vez que algo cambia (Ctrl+C para salir):
#
#   kubectl get svc nginx-app -w
#
#   EXTERNAL-IP pasa de <pending> a una IP real.
#
# Veras tambien un puerto como 80:3XXXX/TCP. El 80 es por donde entras; el 3XXXX
# es el NodePort, el puerto alto que Kubernetes abre en cada nodo para enrutar
# hacia los pods. No lo eliges tu.


# =============================================================================
# 4. COMPROBACIONES DE LA ETAPA 11
# =============================================================================
# 4.1  kubectl get pods           -> 1/1 Running
# 4.2  kubectl get svc nginx-app  -> EXTERNAL-IP deja de ser <pending>
# 4.3  esa IP en el navegador     -> "Welcome to nginx"
#
#      CON http:// DELANTE. Si escribes la IP a secas, el navegador prueba
#      https:// primero, no hay nadie en el 443 y se queda cargando hasta que
#      expira. Es el mismo sintoma que el firewall cerrado de la etapa 6, con
#      otra causa.
#
#      Desde Cloud Shell, sin navegador:
#
#        curl -I http://EXTERNAL_IP        # esperado: HTTP/1.1 200 OK
#
# 4.4  GKE se crea SUS PROPIAS reglas de firewall, al contrario que el modulo 1,
#      donde cada regla se escribio a mano:
#
#        gcloud compute firewall-rules list --filter="name~k8s-"
#
#      Veras un par allow/deny sobre el mismo tag. No es alarmante: el allow
#      tiene prioridad 999 y el deny 1000, y en GCP gana el numero MAS BAJO.


# =============================================================================
# 5. APAGADO - EL ORDEN IMPORTA
# =============================================================================
# 5.1 PRIMERO el Service, desde Cloud Shell. Se lleva el balanceador y la IP:
#
#   kubectl delete service nginx-app
#   kubectl delete deployment nginx-app
#
# 5.2 DESPUES el cluster, desde el PC:
#
#   terraform -chdir=terraform destroy '-target=google_container_cluster.primary'
#
# Al reves, el balanceador queda HUERFANO: Terraform no lo conoce -lo creo
# kubectl- y nadie lo borra, asi que sigue facturando. Encontrarlo luego:
#
#   gcloud compute forwarding-rules list
#
# 5.3 Las tres listas vacias:
#
#   gcloud compute forwarding-rules list
#   gcloud container clusters list
#   gcloud compute instances list
