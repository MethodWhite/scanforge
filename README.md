# Extractor de Puertos y Servicios desde Nmap

Este script en Bash permite extraer direcciones IP y puertos abiertos, así como los servicios asociados, desde un archivo de salida generado por Nmap. Organiza y presenta la información de manera clara y ordenada.

## Características

- **Extracción de IPs y puertos**: Identifica y lista direcciones IP y puertos abiertos presentes en el archivo de Nmap.
- **Detección de servicios**: Asocia cada puerto con su servicio correspondiente.
- **Ordenación y presentación**: Muestra los resultados sin duplicados y en orden numérico y alfabético.

## Requisitos

- **Sistema operativo**: Linux o macOS.
- **Dependencias**: Ninguna. El script utiliza herramientas estándar de Bash.

## Instalación

1. **Clonar el repositorio**:

   ```bash
   git clone https://github.com/MethodWhite/extractor-nmap.git
   ```

2. **Navegar al directorio del proyecto**:

   ```bash
   cd scanforge
   ```

3. **Asignar permisos de ejecución al script**:

   ```bash
   chmod +x scanforge_nmap.sh
   ```

## Uso

1. **Ejecutar el script**:

   ```bash
   ./scanforge_nmap.sh ruta/al/archivo_nmap.xml
   ```

   Reemplaza `ruta/al/archivo_nmap.xml` con la ubicación de tu archivo de salida de Nmap.

2. **Salida esperada**:

   El script mostrará en consola las direcciones IP, puertos y servicios detectados, por ejemplo:

   ```
   [*] Información extraída:

     IP(s): 192.168.1.1, 192.168.1.2
     Puertos: 22, 80, 443
     Servicios: ssh, http, https
   ```

## Contribuciones

Las contribuciones son bienvenidas. Por favor, sigue estos pasos:

1. Realiza un fork del repositorio.
2. Crea una nueva rama (`git checkout -b feature/nueva-caracteristica`).
3. Realiza tus cambios y haz commit (`git commit -am 'Añadir nueva característica'`).
4. Empuja los cambios a tu fork (`git push origin feature/nueva-caracteristica`).
5. Abre un Pull Request detallando tus cambios.

## Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más detalles.

## Agradecimientos

- A [PurpleBooth](https://gist.github.com/PurpleBooth/109311bb0361f32d87a2) por la plantilla de README en español.
- A la comunidad de StackEdit por su herramienta de edición en línea de Markdown.
