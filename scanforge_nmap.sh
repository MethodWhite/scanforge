function extractPorts() {
    local -A unique_ips=() unique_ports=() unique_services=()
    local ips=() ports=() services=() line ip port service

    if [[ $# -ne 1 ]]; then
        echo -e "\n[!] Uso: ${0##*/} <archivo_nmap>\n" >&2
        return 1
    fi

    if [[ ! -f "$1" || ! -r "$1" ]]; then
        echo -e "\n[!] Error: El archivo '$1' no existe o no es legible\n" >&2
        return 1
    fi

    while IFS= read -r line; do
        [[ -z "$line" ]] && continue

        # Extraer IP (formato grepable)
        if [[ $line =~ ^Host:\ ([0-9.]+) ]]; then
            ip="${BASH_REMATCH[1]}"
            [[ -z "${unique_ips[$ip]}" ]] && unique_ips["$ip"]=1 && ips+=("$ip")
        fi

        # Procesar puertos
        if [[ $line =~ Ports:\ (.*) ]]; then
            IFS=',' read -ra entries <<< "${BASH_REMATCH[1]}"
            for entry in "${entries[@]}"; do
                entry="${entry// }"  # Eliminar espacios
                IFS='/' read -ra fields <<< "$entry"
                port="${fields[0]}"
                state="${fields[1]}"
                service="${fields[4]}"

                if [[ "$state" == "open" && "$port" =~ ^[0-9]+$ ]]; then
                    [[ -z "${unique_ports[$port]}" ]] && unique_ports["$port"]=1 && ports+=("$port")
                    if [[ -n "$service" ]]; then
                        [[ -z "${unique_services[$service]}" ]] && unique_services["$service"]=1 && services+=("$service")
                    fi
                fi
            done
        fi
    done < "$1"

    # Ordenar y mostrar resultados (igual que antes)
    IFS=$'\n' sorted_ports=($(sort -n <<<"${ports[*]}"))
    IFS=$'\n' sorted_services=($(sort -f <<<"${services[*]}"))
    unset IFS

    echo -e "\n[*] Información extraída:\n"
    printf "  IP(s): %s\n" "$(IFS=,; echo "${ips[*]}")"
    printf "  Puertos: %s\n" "$(IFS=,; echo "${sorted_ports[*]}")"
    printf "  Servicios: %s\n\n" "$(IFS=,; echo "${sorted_services[*]}")"

    [[ ${#ips[@]} -eq 0 ]] && echo "[!] No se encontraron IPs" >&2
    [[ ${#sorted_ports[@]} -eq 0 ]] && echo "[!] No se encontraron puertos abiertos" >&2
    [[ ${#sorted_services[@]} -eq 0 ]] && echo "[!] No se encontraron servicios" >&2
}
