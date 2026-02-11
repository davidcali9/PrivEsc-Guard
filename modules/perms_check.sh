#!/bin/bash

check_permissions() {
  log_info "Analizando permisos inseguros en archivos críticos..."

  echo

  # Archivos críticos
  critical_files=("/etc/passwd" "/etc/shadow" "/etc/sudoers")

  for file in "${critical_files[@]}"; do
    if [[ -e "$file" ]]; then
      perms=$(stat -c "%a" "$file")

      if [[ "$file" == "/etc/shadow" && "$perms" != "640" && "$perms" != "600" ]]; then
        echo -e "  ${RED}[ALTO RIESGO]${NC} Permisos inseguros en $file ($perms)"
      elif [[ "$file" != "/etc/shadow" && "$perms" -gt 644 ]]; then
        echo -e "  ${RED}[ALTO RIESGO]${NC} Permisos inseguros en $file ($perms)"
      else
        echo -e "  ${GREEN}[OK]${NC} $file ($perms)"
      fi
    fi
  done

  echo
  log_info "Buscando archivos world-writable en /etc..."

  world_etc=$(find /etc -xdev -type f -perm -002 2>/dev/null)

  if [[ -n "$world_etc" ]]; then
    while IFS= read -r file; do
      echo -e "  ${YELLOW}[REVISAR]${NC} $file es world-writable"
    done <<< "$world_etc"
  else
    log_ok "No se encontraron archivos world-writable en /etc."
  fi

  echo
  log_info "Buscando binarios world-writable en /usr/bin..."

  world_usrbin=$(find /usr/bin -xdev -type f -perm -002 2>/dev/null)

  if [[ -n "$world_usrbin" ]]; then
    while IFS= read -r file; do
      echo -e "  ${RED}[ALTO RIESGO]${NC} $file es world-writable"
    done <<< "$world_usrbin"
  else
    log_ok "No se encontraron binarios world-writable en /usr/bin."
  fi

  echo
  log_info "Mitigación recomendada:"
  echo "  - Ajustar permisos con chmod"
  echo "  - Revisar propiedad de archivos críticos"
  echo "  - Evitar permisos 777 en producción"
}
