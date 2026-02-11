#!/bin/bash

check_sudo() {
  log_info "Analizando configuraciones sudo..."

  sudo_output=$(sudo -l 2>/dev/null)

  if [[ $? -ne 0 ]]; then
    log_warn "El usuario actual no puede ejecutar sudo o requiere contraseña."
    return
  fi

  log_ok "El usuario puede ejecutar sudo."

  echo
  log_info "Resultados de sudo -l:"

  # Binarios peligrosos conocidos (GTFOBins)
  local dangerous_bins=("vim" "nano" "less" "more" "find" "awk" "perl" "python" "ruby" "tar" "bash" "sh" "nmap" "rsync")

  local found_issue=false

while IFS= read -r line; do
  if [[ "$line" == *"NOPASSWD"* ]]; then
    for bin in "${dangerous_bins[@]}"; do
      if [[ "$line" == *"$bin"* ]]; then
        echo -e "  ${RED}[ALTO RIESGO]${NC} $line"
        found_issue=true
      fi
    done
  elif [[ "$line" == *"/"* ]]; then
    echo -e "  ${YELLOW}[REVISAR]${NC} $line"
  fi
done <<< "$sudo_output"

  if [[ "$found_issue" = false ]]; then
    echo -e "  ${YELLOW}[REVISAR]${NC} No se detectaron reglas sudo críticas con NOPASSWD."
  fi

  echo
  log_info "Contexto:"
  echo "  - sudo permite ejecutar comandos como root"
  echo "  - Reglas NOPASSWD eliminan una barrera de seguridad"
  echo "  - Algunos binarios permiten escapar a una shell"

  echo
  log_info "Mitigación recomendada:"
  echo "  - Evitar el uso de NOPASSWD siempre que sea posible"
  echo "  - No permitir editores o intérpretes vía sudo"
  echo "  - Usar comandos específicos y sin comodines"

  echo
  log_info "Referencia:"
  echo "  https://gtfobins.github.io/"
}
