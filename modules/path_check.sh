#!/bin/bash

check_path_hijacking() {
  log_info "Analizando posibles riesgos de PATH Hijacking..."

  echo

  IFS=':' read -ra path_dirs <<< "$PATH"

  for dir in "${path_dirs[@]}"; do

    if [[ ! -e "$dir" ]]; then
      echo -e "  ${YELLOW}[REVISAR]${NC} Directorio en PATH no existe: $dir"
      continue
    fi

    # Resolver symlink
    if [[ -L "$dir" ]]; then
      real_dir=$(readlink -f "$dir")
    else
      real_dir="$dir"
    fi

    if [[ ! -d "$real_dir" ]]; then
      continue
    fi

    perms=$(stat -c "%a" "$real_dir")

    # Extraer último dígito (permisos de otros)
    others=${perms: -1}

    if [[ "$others" =~ [2367] ]]; then
      echo -e "  ${RED}[ALTO RIESGO]${NC} $dir (resuelto a $real_dir) es world-writable ($perms)"
    else
      echo -e "  ${GREEN}[OK]${NC} $dir ($perms)"
    fi

  done

  echo
  log_info "Contexto:"
  echo "  - Directorios inseguros en PATH pueden permitir ejecución de binarios maliciosos"
  echo "  - El orden del PATH influye en qué binario se ejecuta primero"

  echo
  log_info "Mitigación recomendada:"
  echo "  - Evitar permisos world-writable en directorios del PATH"
  echo "  - No incluir directorios temporales en el PATH"
  echo "  - Colocar directorios seguros antes que otros personalizados"

  echo
}
