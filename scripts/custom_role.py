#!/usr/bin/env python3
"""
ETAPA 3 - Rol personalizado 'vm_start_stop'

Crea un rol con EXACTAMENTE dos permisos: arrancar y parar instancias.
El predefinido mas pequeno que sirve para eso (compute.instanceAdmin.v1)
tambien permite borrarlas, y eso es mas de lo que hace falta.

Este SI es un script ejecutable, a diferencia de los .sh de esta carpeta.

    python scripts/custom_role.py

Autenticacion: Application Default Credentials. No hay ninguna clave en el
codigo; google.auth las busca solo en
%APPDATA%\\gcloud\\application_default_credentials.json.

Es idempotente: si el rol ya existe, lo actualiza en vez de fallar.
Apuntes: docs/apuntes-etapa-01-terraform-apis.md (seccion ADC)
"""

import re
import sys
from pathlib import Path

import google.auth
from googleapiclient import discovery
from googleapiclient.errors import HttpError

# -----------------------------------------------------------------------------
# Definicion del rol
# -----------------------------------------------------------------------------
# OJO con el id: los roles personalizados admiten letras, numeros, guion BAJO y
# punto, de 3 a 64 caracteres. El guion normal NO vale. Es la excepcion a la
# convencion de nombres del CLAUDE.md, que pide guiones para lo que viaja a GCP.
# Por eso 'vm_start_stop' y no 'vm-start-stop'. Tampoco se puede cambiar despues.
ROL_ID = "vm_start_stop"

ROL = {
    "title": "VM Start Stop",
    "description": "Arrancar y parar instancias de Compute Engine. Nada mas.",
    "includedPermissions": [
        "compute.instances.start",
        "compute.instances.stop",
    ],
    # Etapa del ciclo de vida: ALPHA, BETA, GA o DISABLED. Es solo una etiqueta
    # informativa para quien lo lea, no cambia lo que el rol permite. DISABLED
    # es la excepcion: ese si deja de conceder nada.
    "stage": "GA",
}

# Campos que el patch puede tocar si el rol ya existia.
CAMPOS = "title,description,includedPermissions,stage"

RAIZ = Path(__file__).resolve().parent.parent
TFVARS = RAIZ / "terraform" / "terraform.tfvars"


def leer_project_id() -> str:
    """El id del proyecto vive una sola vez, en terraform.tfvars.

    Convencion del lab: no se escribe a mano en ningun .tf ni en ningun script.
    Se lee de ahi para que solo haya un sitio que tocar si cambia.
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


def main() -> int:
    proyecto = leer_project_id()
    padre = f"projects/{proyecto}"

    # google.auth.default() devuelve las credenciales ADC y, de propina, el
    # quota project del archivo. Aqui solo usamos las credenciales: el proyecto
    # sale del tfvars, que es la fuente de verdad del lab.
    credenciales, _ = google.auth.default()

    # 'iam' 'v1' son el nombre y la version de la API. discovery.build se baja
    # la descripcion de la API y construye los metodos al vuelo: por eso el
    # .projects().roles().create() no lo autocompleta el editor.
    servicio = discovery.build("iam", "v1", credentials=credenciales)
    roles = servicio.projects().roles()

    print(f"Proyecto : {proyecto}")
    print(f"Rol      : {ROL_ID}")
    print(f"Permisos : {len(ROL['includedPermissions'])}")
    print()

    try:
        creado = roles.create(
            parent=padre,
            body={"roleId": ROL_ID, "role": ROL},
        ).execute()
        print("CREADO")
        resultado = creado

    except HttpError as error:
        if error.resp.status != 409:
            raise

        # 409 = ya existe. Puede ser que este vivo, o que lo borraras y siga en
        # la papelera: los roles borrados tardan 7 dias en desaparecer y su id
        # queda reservado mientras tanto.
        existente = roles.get(name=f"{padre}/roles/{ROL_ID}").execute()

        if existente.get("deleted"):
            print(f"El rol '{ROL_ID}' esta BORRADO pero aun en la papelera.")
            print("Su id sigue reservado 7 dias. Para recuperarlo:")
            print(f"  gcloud iam roles undelete {ROL_ID} --project={proyecto}")
            return 1

        # Ya existia y esta vivo: lo dejamos como dice ROL.
        # updateMask dice que campos tocar. Sin el, la API se queja.
        resultado = roles.patch(
            name=f"{padre}/roles/{ROL_ID}",
            updateMask=CAMPOS,
            body=ROL,
        ).execute()
        print("YA EXISTIA -> actualizado")

    print()
    print(f"  name    : {resultado['name']}")
    print(f"  title   : {resultado['title']}")
    print(f"  stage   : {resultado.get('stage')}")
    print(f"  etag    : {resultado.get('etag')}")
    print("  permisos:")
    for permiso in resultado.get("includedPermissions", []):
        print(f"    - {permiso}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
