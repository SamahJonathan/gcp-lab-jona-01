variable "project_id" {
  description = "Id del proyecto de GCP del laboratorio"
  type        = string
}

variable "region" {
  description = "zona de los recursos zonales (VM's, discos)"
  type        = string
}

variable "zone" {
  description = "Zona por defecto para los recursos zonales (VMs, discos)"
  type        = string
}

variable "gke_zone" {
  description = <<-EOT
    Zona del cluster de GKE, separada de var.zone a proposito.

    El 01-10-2026 el cluster fallo al crearse en us-east1-b con "Google Compute
    Engine does not have enough resources available to fulfill request": Google
    no tenia e2-medium libres en esa zona. No es un error de configuracion, es
    inventario, y la unica salida es probar otra zona.

    Las e2-micro del MIG si entraron en us-east1-c y us-east1-d, asi que se
    empieza por la -c. Si vuelve a fallar, cambiar el default a us-east1-d y
    reaplicar.
  EOT
  type        = string
  default     = "us-east1-c"
}