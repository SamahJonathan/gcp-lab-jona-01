"""ETAPA 13 - Cloud Function gen2 con trigger HTTP.

El codigo de la funcion. No se ejecuta a mano: lo despliega deploy.sh y lo
arranca Google cuando llega una peticion.

El nombre de la funcion de aqui abajo, hello_http, tiene que coincidir EXACTO
con el --entry-point del comando de despliegue. Si se renombra una, hay que
renombrar la otra.

Apuntes: docs/apuntes-etapa-13-cloud-functions.md
"""

import functions_framework


@functions_framework.http
def hello_http(request):
    """Responde a cualquier peticion HTTP con un saludo.

    El decorador @functions_framework.http es lo que convierte una funcion de
    Python normal en algo que sabe recibir peticiones web. Por debajo monta un
    servidor Flask: el argumento 'request' es un objeto Request de Flask.

    Devolver un str es el atajo: equivale a un 200 con content-type text/html.
    Para controlar codigo y cabeceras se devuelve una tupla:
        return ("no encontrado", 404, {"Content-Type": "text/plain"})
    """
    # Lee el parametro ?nombre= de la URL si viene, y si no usa "mundo".
    # Sirve para comprobar que la funcion recibe de verdad la peticion y no
    # devuelve siempre lo mismo:
    #   https://URL?nombre=jonathan
    nombre = request.args.get("nombre", "mundo")

    return f"Hola {nombre}, desde una Cloud Function gen2 en us-east1.\n"
