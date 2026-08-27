# ETAPA 4 - Red del laboratorio
# Apuntes: docs/apuntes-etapa-04-vpc-custom.md
#
# Una VPC en modo CUSTOM y una sola subred. Coste 0: ni la red ni la subred
# se facturan.

# -----------------------------------------------------------------------------
# La VPC (virtual private cloud) es la red de nivel superior. En GCP se puede crear en modo CUSTOM o AUTO.
# -----------------------------------------------------------------------------
resource "google_compute_network" "vpc_lab" {
  # El nombre que viaja a GCP lleva guion; la etiqueta local de Terraform,
  # guion bajo. Son dos cosas distintas y solo la primera la ve Google.
  name = "vpc-lab"

  # ESTE es el ejercicio. Con true (el valor por defecto) Google crearia una
  # subred en cada region del mundo, con rangos que no elegiste: eso es el modo
  # AUTO. Con false la red nace vacia y las subredes las pones tu.
  auto_create_subnetworks = false

  # REGIONAL: cada subred anuncia sus rutas solo en su region. Es el valor por
  # defecto, escrito a proposito para que se vea que existe la alternativa
  # (GLOBAL, que las anuncia en todas y hace falta con varias regiones).
  routing_mode = "REGIONAL"

  # Sin esto, un 'terraform apply' desde cero podria intentar crear la red
  # antes de que la API de Compute este habilitada. Hoy ya lo esta, pero en el
  # ejercicio 20 se destruye todo y hay que poder rehacerlo de un tiron.
  depends_on = [google_project_service.apis]
}

# -----------------------------------------------------------------------------
# La subred
# -----------------------------------------------------------------------------
resource "google_compute_subnetwork" "subred_us_east1" {
  name = "subred-us-east1"

  # 10.10.0.0/24 son 256 direcciones, de las que GCP se reserva 4: la primera
  # (red), la segunda (gateway), y las dos ultimas. Quedan 252 utiles, de sobra
  # para el laboratorio.
  ip_cidr_range = "10.10.0.0/24"

  # var.region sale de terraform.tfvars, igual que el project_id. El id de la
  # region no se escribe a mano aqui.
  region = var.region

  # La subred se cuelga de la red por referencia, no por nombre en texto. Asi
  # Terraform sabe que primero va la red y luego la subred, sin depends_on.
  network = google_compute_network.vpc_lab.id
}
