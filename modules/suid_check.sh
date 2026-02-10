#!/bin/bash

check_suid_sgid() {
  log_info "Buscando binarios SUID / SGID..."

  local suid_files
  suid_files=$(find / -perm /6000 -type f 2>/dev/null)

  if [[ -z "$suid_files" ]]; then
    log_ok "No se encontraron binarios SUID/SGID."
    return
  fi

  log_warn "Se han encontrado binarios con SUID/SGID:"

  local high_risk_bins=("find" "bash" "sh" "vim" "nmap" "less" "more" "cp" "mv" "perl" "python" "ruby" "tar")

  while IFS= read -r file; do
    bin_name=$(basename "$file")

    if [[ " ${high_risk_bins[*]} " =~ " ${bin_name} " ]]; then
      echo -e "  ${RED}[ALTO RIESGO]${NC} $file"
    else
      echo -e "  ${YELLOW}[REVISAR]${NC} $file"
    fi
  done <<< "$suid_files"

  echo
  log_info "Contexto:"
  echo "  - Los binarios SUID se ejecutan con privilegios elevados"
  echo "  - Algunos permiten ejecutar comandos o shells"

  echo
  log_info "Mitigación recomendada:"
  echo "  - Eliminar el bit SUID/SGID si no es estrictamente necesario"
  echo "  - Restringir permisos de ejecución"
  echo "  - Verificar binarios en GTFOBins"

  echo
  log_info "Referencia:"
  echo "  https://gtfobins.github.io/"
}
