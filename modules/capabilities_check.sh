#!/bin/bash

check_capabilities() {
  log_info "Analizando Linux Capabilities..."

  echo

  if ! command -v getcap &>/dev/null; then
    log_warn "getcap no está disponible en el sistema."
    return
  fi

  cap_output=$(getcap -r / 2>/dev/null)

  if [[ -z "$cap_output" ]]; then
    log_ok "No se encontraron binarios con capabilities activas."
    return
  fi

  log_warn "Se encontraron binarios con capabilities:"

  # Capacidades potencialmente peligrosas
  dangerous_caps=("cap_setuid" "cap_setgid" "cap_sys_admin" "cap_dac_override" "cap_sys_ptrace")

  while IFS= read -r line; do
    for cap in "${dangerous_caps[@]}"; do
      if [[ "$line" == *"$cap"* ]]; then
        echo -e "  ${RED}[ALTO RIESGO]${NC} $line"
	add_risk 15
        continue 2
      fi
    done
    echo -e "  ${YELLOW}[REVISAR]${NC} $line"
  done <<< "$cap_output"

  echo
  log_info "Contexto:"
  echo "  - Las capabilities permiten privilegios específicos sin usar SUID"
  echo "  - Algunas pueden permitir escalada de privilegios"

  echo
  log_info "Mitigación recomendada:"
  echo "  - Revisar si la capability es necesaria"
  echo "  - Eliminar con: setcap -r <archivo>"
  echo "  - Minimizar privilegios asignados"

  echo
}
