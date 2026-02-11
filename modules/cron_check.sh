#!/bin/bash

check_cron() {
  log_info "Analizando configuraciones de cron..."

  echo

  cron_files=("/etc/crontab")
  cron_files+=($(find /etc/cron.d -type f 2>/dev/null))

  for cron_file in "${cron_files[@]}"; do
    if [[ -f "$cron_file" ]]; then
      log_info "Revisando $cron_file"

      while IFS= read -r line; do
        # Ignorar comentarios y líneas vacías
        [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue

        # Detectar líneas ejecutadas como root
        if [[ "$line" == *"root"* ]]; then
          script_path=$(echo "$line" | awk '{print $NF}')

          if [[ -f "$script_path" ]]; then
            perms=$(stat -c "%a" "$script_path")

            if [[ "$perms" -ge 777 || "$perms" -ge 775 ]]; then
              echo -e "  ${RED}[ALTO RIESGO]${NC} $script_path ejecutado por root y con permisos $perms"
            else
              echo -e "  ${GREEN}[OK]${NC} $script_path ($perms)"
            fi
          fi
        fi

      done < "$cron_file"

      echo
    fi
  done

  log_info "Mitigación recomendada:"
  echo "  - Restringir permisos de scripts ejecutados por cron"
  echo "  - Evitar permisos world-writable"
  echo "  - Revisar tareas ejecutadas como root"

  echo
}

