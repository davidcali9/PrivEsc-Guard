#!/bin/bash

check_uid0_users() {
  log_info "Analizando usuarios con UID 0..."

  echo

  uid0_users=$(awk -F: '($3 == 0) { print $1 }' /etc/passwd)

  count=0

  while IFS= read -r user; do
    ((count++))
    if [[ "$user" == "root" ]]; then
      echo -e "  ${GREEN}[OK]${NC} Usuario root detectado."
    else
      echo -e "  ${RED}[ALTO RIESGO]${NC} Usuario adicional con UID 0: $user"
    fi
  done <<< "$uid0_users"

  if [[ "$count" -eq 1 ]]; then
    log_ok "Solo existe el usuario root con UID 0."
  fi

  echo
  log_info "Contexto:"
  echo "  - UID 0 tiene privilegios equivalentes a root"
  echo "  - Usuarios adicionales con UID 0 representan riesgo crítico"

  echo
  log_info "Mitigación recomendada:"
  echo "  - Revisar /etc/passwd"
  echo "  - Eliminar usuarios innecesarios con UID 0"
  echo "  - Usar sudo en lugar de cuentas root adicionales"

  echo
}
