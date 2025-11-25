#!/bin/bash

# Crear los directorios para los módulos
mkdir -p mimodulo_simple
mkdir -p mimodulo_reutilizable

# Módulo simple (sin provider dentro)
cat > mimodulo_simple/main.tf <<EOF
resource "local_file" "ejemplo" {
  filename = "ejemplo.txt"
  content  = "Archivo creado por un módulo simple en Tofu"
}
EOF

# Módulo reutilizable con variables (sin provider dentro)
cat > mimodulo_reutilizable/main.tf <<EOF
variable "filename" {
  type    = string
  default = "ejemplo.txt"
}

variable "content" {
  type    = string
  default = "Contenido por defecto"
}

resource "local_file" "archivo" {
  filename = var.filename
  content  = var.content
}
EOF

# Archivo root que controla qué módulo usar, sin duplicar provider
cat > main.tf <<EOF
variable "usar_modulo_reutilizable" {
  type    = bool
  default = false
}

module "archivo_simple" {
  source = "./mimodulo_simple"
  count  = var.usar_modulo_reutilizable ? 0 : 1
}

module "archivo1" {
  source   = "./mimodulo_reutilizable"
  filename = "archivo1.txt"
  content  = "Hola, este es el archivo 1"
  count    = var.usar_modulo_reutilizable ? 1 : 0
}

module "archivo2" {
  source   = "./mimodulo_reutilizable"
  filename = "archivo2.txt"
  content  = "Este es el archivo 2, reutilizando el módulo"
  count    = var.usar_modulo_reutilizable ? 1 : 0
}
EOF

# Provider requerido declarado solo una vez
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

echo "Archivos creados. Usa 'tofu init' y 'tofu apply' para desplegar."
echo "Para usar el módulo reutilizable añade -var='usar_modulo_reutilizable=true' al comando apply."
