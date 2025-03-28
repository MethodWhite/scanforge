#!/usr/bin/env bash

# Validar versión de Bash
if (( BASH_VERSINFO < 4 )); then
    echo -e "\n[!] Se requiere Bash 4.0 o superior\n" >&2
    exit 1
fi

# Auto-asignar permisos de ejecución si es necesario
if [[ "${BASH_SOURCE[0]}" == "${0}" ]] && [[ ! -x "$0" ]]; then
    echo -e "\n[!] Asignando permisos de ejecución..."
    chmod +x "$0" 2>/dev/null && exec "./$0" "$@"
    exit $?
fi

function extractPorts() {
    local -A unique_ips=() unique_ports=() unique_services=()
    local ips=() ports=() services=() line ip port service

    # Validación de argumentos
    if [[ $# -ne 1 ]]; then
        echo -e "\n[!] Uso: ${0##*/} <archivo_nmap>\n" >&2
        return 1
    fi

    if [[ ! -f "$1" || ! -r "$1" ]]; then
        echo -e "\n[!] Error: El archivo '$1' no existe o no es legible\n" >&2
        return 1
    fi

    # Procesamiento del archivo
    while IFS= read -r line; do
        # Ignorar líneas vacías
        [[ -z "$line" ]] && continue

        # Extracción de IPs (formato grepable)
        if [[ $line =~ ^Host:\ .*((25[0-5]|2[0-4][0-9]|[01]?[0-9]{1,2})\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9]{1,2}) ]]; then
            ip="${BASH_REMATCH[0]##* }"
            [[ -z "${unique_ips[$ip]}" ]] && unique_ips["$ip"]=1 && ips+=("$ip")
        fi

        # Detección de puertos y servicios
        if [[ $line =~ ([0-9]{1,5})/open.*/([a-zA-Z0-9\-\_]+)/ ]]; then
            port="${BASH_REMATCH[1]}"
            service="${BASH_REMATCH[2]}"
            [[ -z "${unique_ports[$port]}" ]] && unique_ports["$port"]=1 && ports+=("$port")
            [[ -z "${unique_services[$service]}" ]] && unique_services["$service"]=1 && services+=("$service")
        fi
    done < "$1"

    # Ordenamientos
    IFS=$'\n' sorted_ports=($(sort -n <<<"${ports[*]}"))
    IFS=$'\n' sorted_services=($(sort -f <<<"${services[*]}"))
    unset IFS

    # Mostrar resultados
    echo -e "\n[*] Información extraída:\n"
    printf "  IP(s): %s\n" "$(IFS=,; echo "${ips[*]}")"
    printf "  Puertos: %s\n" "$(IFS=,; echo "${sorted_ports[*]}")"
    printf "  Servicios: %s\n\n" "$(IFS=,; echo "${sorted_services[*]}")"

    # Manejo de casos sin resultados
    [[ ${#ips[@]} -eq 0 ]] && echo "[!] No se encontraron IPs" >&2
    [[ ${#sorted_ports[@]} -eq 0 ]] && echo "[!] No se encontraron puertos abiertos" >&2
    [[ ${#sorted_services[@]} -eq 0 ]] && echo "[!] No se encontraron servicios" >&2
}

# Ejecutar solo si se invoca directamente
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && extractPorts "$@"
