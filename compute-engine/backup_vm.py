#!/usr/bin/env python3
"""
ETAPA 8 - Snapshot de un disco de Compute Engine

Los datos son lo unico que no se puede reemplazar. Una VM se rehace con el
comando de la etapa 6; su disco, no. Para eso estan los snapshots.

Este SI es un script ejecutable, como custom_role.py de la etapa 3.

    pip install google-cloud-compute
    python compute-engine/backup_vm.py --disk app-p144 --zone us-east1-c

Lanzalo DOS VECES sobre el mismo disco. La segunda tardara mucho menos y
ocupara mucho menos: los snapshots de GCP son INCREMENTALES, solo guardan los
bloques que cambiaron desde el anterior. Esa es la medida del ejercicio.

Autenticacion: Application Default Credentials, igual que Terraform. No hay
ninguna clave en el codigo.

Apuntes: docs/apuntes-etapa-08-snapshots.md
"""

import argparse
import re
import sys
import time
from datetime import datetime
from pathlib import Path

from google.api_core.exceptions import Conflict, NotFound
from google.cloud import compute_v1

RAIZ = Path(__file__).resolve().parent.parent
TFVARS = RAIZ / "terraform" / "terraform.tfvars"


def leer_project_id() -> str:
    """El id del proyecto vive una sola vez, en terraform.tfvars.

    Misma funcion que en scripts/custom_role.py y por el mismo motivo: la
    convencion del lab dice que no se escribe a mano en ningun sitio.
    """
    if not TFVARS.exists():
        sys.exit(f"ERROR: no encuentro {TFVARS}\n"
                 f"Sin ese archivo no se sobre que proyecto trabajar.")

    encontrado = re.search(
        r'^\s*project_id\s*=\s*"([^"]+)"',
        TFVARS.read_text(encoding="utf-8"),
        re.MULTILINE,
    )
    if not encontrado:
        sys.exit(f'ERROR: {TFVARS} no tiene ninguna linea project_id = "..."')

    return encontrado.group(1)


def nombre_por_defecto(disco: str) -> str:
    """snapshot-<disco>-<fecha>, que es unico y ademas se lee.

    Los nombres de snapshot no se pueden repetir, asi que uno fijo haria que la
    segunda ejecucion fallara con un 409 - y la segunda ejecucion es justo la
    que demuestra que son incrementales. Con la fecha dentro, el script se puede
    lanzar las veces que haga falta.

    Reglas del nombre: minusculas, numeros y guion, empezando por letra, hasta
    63 caracteres. Se recorta el disco por si viene largo.
    """
    marca = datetime.now().strftime("%Y%m%d-%H%M%S")
    return f"snapshot-{disco[:35]}-{marca}"


def main() -> int:
    trozos = argparse.ArgumentParser(
        description="Crea un snapshot de un disco de Compute Engine.",
    )
    trozos.add_argument("--disk", required=True,
                        help="nombre del disco (suele coincidir con el de la VM)")
    trozos.add_argument("--zone", required=True,
                        help="zona del disco, p.ej. us-east1-c")
    trozos.add_argument("--snapshot-name", default=None,
                        help="opcional; por defecto snapshot-<disco>-<fecha>")
    args = trozos.parse_args()

    proyecto = leer_project_id()
    nombre = args.snapshot_name or nombre_por_defecto(args.disk)

    # 1. Localizar el disco. Un disco es ZONAL: hacen falta proyecto, zona y
    #    nombre para identificarlo, los tres. Un snapshot, en cambio, es GLOBAL.
    discos = compute_v1.DisksClient()
    try:
        disco = discos.get(project=proyecto, zone=args.zone, disk=args.disk)
    except NotFound:
        print(f"ERROR: no hay ningun disco '{args.disk}' en la zona '{args.zone}'.")
        print("Listalos con:")
        print("  gcloud compute disks list --format=\"table(name,zone.basename())\"")
        return 1

    print(f"Proyecto : {proyecto}")
    print(f"Disco    : {disco.name}  ({args.zone}, {disco.size_gb} GB)")
    print(f"Snapshot : {nombre}")
    print()

    # 2. Crear el snapshot. source_disk va por self_link, la URL completa del
    #    disco, no por su nombre suelto: el snapshot vive fuera de la zona y
    #    necesita saber exactamente de donde sale.
    recurso = compute_v1.Snapshot()
    recurso.name = nombre
    recurso.source_disk = disco.self_link

    snapshots = compute_v1.SnapshotsClient()
    reloj = time.monotonic()

    try:
        # insert() devuelve una operacion, no el snapshot. La llamada vuelve
        # enseguida y el trabajo sigue en GCP; .result() es lo que espera a que
        # termine de verdad.
        operacion = snapshots.insert(project=proyecto, snapshot_resource=recurso)
        print("Creando... (la primera vez tarda: copia el disco entero)")
        operacion.result(timeout=600)
    except Conflict:
        print(f"ERROR: ya existe un snapshot llamado '{nombre}'.")
        print("Los nombres son unicos y globales. Prueba sin --snapshot-name.")
        return 1

    tardanza = time.monotonic() - reloj

    # 3. Leerlo ya creado para ver cuanto ocupa.
    hecho = snapshots.get(project=proyecto, snapshot=nombre)

    print()
    print(f"  estado    : {hecho.status}")
    print(f"  origen    : {hecho.disk_size_gb} GB")
    print(f"  ocupa     : {hecho.storage_bytes / (1024 ** 2):.1f} MB")
    print(f"  tardanza  : {tardanza:.1f} s")

    # storage_bytes tarda un rato en cuadrar. Si sale UPDATING, el numero de
    # arriba es provisional y conviene mirarlo luego con gcloud.
    if hecho.storage_bytes_status != "UP_TO_DATE":
        print(f"  (ocupacion todavia {hecho.storage_bytes_status}, "
              f"el numero definitivo tarda unos minutos)")

    print()
    print("Lanzalo otra vez sobre el mismo disco y compara 'ocupa' y 'tardanza':")
    print("ahi se ve que el segundo snapshot es incremental.")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
