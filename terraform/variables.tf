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