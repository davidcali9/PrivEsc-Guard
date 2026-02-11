#!/bin/bash

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

# -----------------------------
# Cargar core
# -----------------------------

source "$BASE_DIR/core/colors.sh"
source "$BASE_DIR/core/logger.sh"
source "$BASE_DIR/core/config.sh"
source "$BASE_DIR/core/banner.sh"
source "$BASE_DIR/core/utils.sh"

# -----------------------------
# Cargar módulos
# -----------------------------

source "$BASE_DIR/modules/suid_check.sh"
source "$BASE_DIR/modules/sudo_check.sh"
source "$BASE_DIR/modules/perms_check.sh"
source "$BASE_DIR/modules/cron_check.sh"
source "$BASE_DIR/modules/capabilities_check.sh"
source "$BASE_DIR/modules/docker_check.sh"
source "$BASE_DIR/modules/uid0_check.sh"
source "$BASE_DIR/modules/path_check.sh"

# -----------------------------
# Argumentos CLI
# -----------------------------

ONLY_MODULE=""
SKIP_MODULE=""
GENERATE_REPORT=true

while [[ $# -gt 0 ]]; do
  case "$1" in
    --only)
      ONLY_MODULE="$2"
      shift 2
      ;;
    --skip)
      SKIP_MODULE="$2"
      shift 2
      ;;
    --no-report)
      GENERATE_REPORT=false
      shift
      ;;
    *)
      echo "Argumento desconocido: $1"
      exit 1
      ;;
  esac
done

# -----------------------------
# Sistema de reporte
# -----------------------------

if $GENERATE_REPORT; then
  REPORT_DIR="$BASE_DIR/output/reports"
  mkdir -p "$REPORT_DIR"
  REPORT_FILE="$REPORT_DIR/report_$(date +%Y%m%d_%H%M%S).txt"
  exec > >(tee -a "$REPORT_FILE") 2>&1
fi

# -----------------------------
# Helper para ejecutar módulos
# -----------------------------

run_module() {
  module_name="$1"
  module_func="$2"

  if [[ -n "$ONLY_MODULE" && "$ONLY_MODULE" != "$module_name" ]]; then
    return
  fi

  if [[ "$SKIP_MODULE" == "$module_name" ]]; then
    return
  fi

  $module_func
}

# -----------------------------
# Main
# -----------------------------

main() {
  print_banner
  require_root
  log_info "Iniciando PrivEsc-Guard..."

  run_module "suid" check_suid_sgid
  run_module "sudo" check_sudo
  run_module "perms" check_permissions
  run_module "cron" check_cron
  run_module "capabilities" check_capabilities
  run_module "docker" check_docker
  run_module "uid0" check_uid0_users
  run_module "path" check_path_hijacking
}

main
