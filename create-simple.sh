#!/bin/bash

# Crear carpeta del módulo
mkdir -p mimodulo

# Crear archivo main.tf dentro del módulo
cat > mimodulo/main.tf <<EOF
provider "local" {}

resource "local_file" "ejemplo" {
  filename = "ejemplo.txt"
  content  = "Esto es un archivo creado por un módulo simple"
}
EOF

# Crear archivo main.tf en la raíz que llama al módulo
cat > main.tf <<EOF
module "archivo_simple" {
  source = "./mimodulo"
}
EOF

# Inicializar Terraform y aplicar la configuración
tofu init
tofu apply -auto-approve
