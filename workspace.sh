#!/bin/bash

# Instalador que prepara la configuración Terraform/OpenTofu,
# crea los workspaces desa y prod,
# instala Apache2 siempre (update, install, enable y start),
# sin función deploy_workspace ni despliegue automático.

# Crear main.tf con contenido HTML dinámico según workspace
cat > main.tf <<EOF
locals {
  index_content = {
    desa = <<EOT
<html>
  <body style="background: linear-gradient(to right, #a8edea, #fed6e3); color: #004080; font-size: 48px; text-align:center; padding-top: 20%;">
    Bienvenido a desa
  </body>
</html>
EOT

    prod = <<EOT
<html>
  <body style="background: linear-gradient(to right, #ff0000, #800000); color: #fff0f0; font-size: 48px; text-align:center; padding-top: 20%;">
    Bienvenido a producción
  </body>
</html>
EOT
  }
}

resource "local_file" "index_html" {
  filename = "/var/www/html/index.html"
  content  = lookup(local.index_content, terraform.workspace, "Bienvenido")
}
EOF

# Crear versions.tf con provider local
cat > versions.tf <<EOF
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}
EOF

# Inicializar OpenTofu sin crear o seleccionar workspaces aún
echo "Inicializando proyecto con tofu..."
tofu init

# Crear workspaces desa y prod si no existen
echo "Creando workspaces..."
tofu workspace new desa || echo "Workspace desa ya existe"
tofu workspace new prod || echo "Workspace prod ya existe"

echo "Workspaces 'desa' y 'prod' listos."

# Instalar Apache siempre (update, install, enable y start)
echo "Instalando y activando Apache2..."
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl enable --now apache2

echo "Apache2 instalado y corriendo."

echo -e "\nPara aplicar la configuración usa los comandos manualmente:\n"
echo "  tofu workspace select desa"
echo "  tofu apply -auto-approve"
echo "  -- o --"
echo "  tofu workspace select prod"
echo "  tofu apply -auto-approve"
