Los workspaces y los locales tienen roles clave para manejar ambientes y configurar contenido dinámico de infraestructura.

## Workspaces

Los workspaces en OpenTofu/Terraform permiten gestionar múltiples entornos (como desa y prod) usando el mismo código fuente.

Cada workspace mantiene su propio estado, aislando los recursos y evitando conflictos entre ambientes.

Esto facilita desplegar configuraciones similares pero independientes, por ejemplo para desarrollo, pruebas y producción.

En el script, se crean los workspaces desa y prod para tener dos ambientes separados gestionados con la misma infraestructura definida.

Luego tú seleccionas el workspace que quieres afectar y haces tofu apply para desplegar en ese entorno concreto.

## Locals

 Los locals son bloques dentro de la configuración que definen valores o estructuras intermedias de manera local, para simplificar y organizar el código.

En el script, el bloque locals contiene un mapa llamado index_content que asocia a cada workspace (desa o prod) su respectivo contenido HTML.

Luego, el recurso local_file usa lookup(local.index_content, terraform.workspace, "Bienvenido") para obtener el contenido correcto según el workspace activo.

Esto permite definir dinámicamente parámetros o valores repetidos sin duplicar código, haciendo la configuración más mantenible y clara.

En resumen, los workspaces permiten aislar estados y recursos por entorno usando la misma base de código, mientras que los locals dentro de la configuración organizan y parametrizan datos reutilizables, aplicando la lógica necesaria para configurar adecuadamente cada workspace en el despliegue.

Esta combinación es una práctica estándar en Terraform/OpenTofu para manejar múltiples ambientes con código eficiente y seguro.

## Referencias:

Terraform/OpenTofu Workspaces permiten separar estados para múltiples despliegues con el mismo código.

Locals ayudan a definir variables y estructuras reutilizables dentro del código HCL.
