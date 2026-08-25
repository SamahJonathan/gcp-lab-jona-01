# gcp-lab-jona-01

Proyecto base de infraestructura en GCP usando Terraform.

## Recursos incluidos

- VPC custom
- Subred regional
- Bucket de Cloud Storage

## Uso rápido

1. Inicializar Terraform:

   ```bash
   terraform init
   ```

2. Crear archivo de variables (`terraform.tfvars`) con al menos:

   ```hcl
   project_id         = "tu-proyecto-gcp"
   bucket_name_prefix = "gcp-lab-jona"
   ```

3. Validar y planificar:

   ```bash
   terraform fmt -check -recursive
   terraform validate
   terraform plan
   ```