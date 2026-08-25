output "vpc_name" {
  description = "Nombre de la VPC creada."
  value       = google_compute_network.vpc.name
}

output "subnet_name" {
  description = "Nombre de la subred creada."
  value       = google_compute_subnetwork.subnet.name
}

output "bucket_name" {
  description = "Nombre del bucket creado."
  value       = google_storage_bucket.main.name
}
