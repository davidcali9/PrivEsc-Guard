#!/bin/bash

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

# Cargar core
source "$BASE_DIR/core/colors.sh"
source "$BASE_DIR/core/logger.sh"
source "$BASE_DIR/core/config.sh"
source "$BASE_DIR/core/banner.sh"
source "$BASE_DIR/core/utils.sh"
source "$BASE_DIR/modules/suid_check.sh"
source "$BASE_DIR/modules/sudo_check.sh"

main() {
  print_banner
  require_root
  log_info "Iniciando PrivEsc-Guard..."

  check_suid_sgid
  check_sudo
}

main
