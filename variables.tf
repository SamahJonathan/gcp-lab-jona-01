variable "project_id" {
  description = "ID del proyecto de GCP donde se desplegarán los recursos."
  type        = string
}

variable "region" {
  description = "Región principal para recursos regionales."
  type        = string
  default     = "us-central1"
}

variable "network_name" {
  description = "Nombre de la VPC."
  type        = string
  default     = "gcp-lab-vpc"
}

variable "subnet_name" {
  description = "Nombre de la subred principal."
  type        = string
  default     = "gcp-lab-subnet"
}

variable "subnet_cidr" {
  description = "Rango CIDR de la subred principal."
  type        = string
  default     = "10.10.0.0/24"
}

variable "bucket_name_prefix" {
  description = "Prefijo del nombre del bucket (se agrega sufijo aleatorio)."
  type        = string
  default     = "gcp-lab-jona"
}

variable "labels" {
  description = "Etiquetas para recursos compatibles."
  type        = map(string)
  default = {
    environment = "lab"
    managed_by  = "terraform"
  }
}
