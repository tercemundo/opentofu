# Terraform/OpenTofu Módulos Locales con Bash

Este proyecto contiene dos ejemplos de módulos para OpenTofu (compatible con Terraform) que crean archivos locales usando el proveedor `local`. Un módulo es un bloque reutilizable de configuración.

---

## Contenido

- `mimodulo_simple/`: Módulo básico que crea un archivo con contenido fijo.
- `mimodulo_reutilizable/`: Módulo con variables para crear archivos con diferentes nombres y contenidos.
- Archivos raíz `main.tf` que permiten elegir qué módulo usar mediante una variable booleana.
- Archivo `versions.tf` con la declaración única del proveedor `local`.

---

## Bash Script para crear la estructura

El script `crear_modulos.sh` crea todo lo necesario para ambos módulos sin repetir el provider y con una variable para elegir cuál usar:

```
#!/bin/bash

mkdir -p mimodulo_simple
mkdir -p mimodulo_reutilizable

cat > mimodulo_simple/main.tf <<EOF
resource "local_file" "ejemplo" {
filename = "ejemplo.txt"
content = "Archivo creado por un módulo simple en Tofu"
}
EOF

cat > mimodulo_reutilizable/main.tf <<EOF
variable "filename" {
type = string
default = "ejemplo.txt"
}

variable "content" {
type = string
default = "Contenido por defecto"
}

resource "local_file" "archivo" {
filename = var.filename
content = var.content
}
EOF

cat > main.tf <<EOF
variable "usar_modulo_reutilizable" {
type = bool
default = false
}

module "archivo_simple" {
source = "./mimodulo_simple"
count = var.usar_modulo_reutilizable ? 0 : 1
}

module "archivo1" {
source = "./mimodulo_reutilizable"
filename = "archivo1.txt"
content = "Hola, este es el archivo 1"
count = var.usar_modulo_reutilizable ? 1 : 0
}

module "archivo2" {
source = "./mimodulo_reutilizable"
filename = "archivo2.txt"
content = "Este es el archivo 2, reutilizando el módulo"
count = var.usar_modulo_reutilizable ? 1 : 0
}
EOF

cat > versions.tf <<EOF
terraform {
required_providers {
local = {
source = "hashicorp/local"
version = "~> 2.0"
}
}
}
EOF

echo "Archivos creados. Para usar ejecuta 'tofu init' y 'tofu apply'."
```



---

## Cómo usar

1. Corre el script para crear los archivos:

``` bash <nombre.sh>
tofu apply -var="usar_modulo_reutilizable=true"
```

