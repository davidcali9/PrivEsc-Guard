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
# Risk Scoring + Estado módulos
# -----------------------------

RISK_SCORE=0
MAX_SCORE=100
declare -A MODULE_STATUS

add_risk() {
  points="$1"
  RISK_SCORE=$((RISK_SCORE + points))
}

set_module_status() {
  module="$1"
  status="$2"
  MODULE_STATUS["$module"]="$status"
}

# -----------------------------
# Sistema de reporte
# -----------------------------

if $GENERATE_REPORT; then
  REPORT_DIR="$BASE_DIR/output/reports"
  mkdir -p "$REPORT_DIR"

  TIMESTAMP=$(date +%Y%m%d_%H%M%S)

  REPORT_FILE="$REPORT_DIR/report_$TIMESTAMP.txt"
  HTML_REPORT_FILE="$REPORT_DIR/report_$TIMESTAMP.html"

  exec > >(tee -a "$REPORT_FILE") 2>&1
fi

# -----------------------------
# Helper ejecución módulos
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

  BEFORE_SCORE=$RISK_SCORE

  $module_func

  AFTER_SCORE=$RISK_SCORE

  if [[ "$AFTER_SCORE" -gt "$BEFORE_SCORE" ]]; then
    set_module_status "$module_name" "ALTO"
  else
    set_module_status "$module_name" "OK"
  fi
}

# -----------------------------
# HTML Report
# -----------------------------

generate_html_report() {

  if ! $GENERATE_REPORT; then
    return
  fi

  if [[ "$RISK_SCORE" -ge 50 ]]; then
    LEVEL="ALTO"
    COLOR="#ff4d4d"
  elif [[ "$RISK_SCORE" -ge 20 ]]; then
    LEVEL="MEDIO"
    COLOR="#ffaa00"
  else
    LEVEL="BAJO"
    COLOR="#00cc66"
  fi

cat <<EOF > "$HTML_REPORT_FILE"
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>PrivEsc-Guard Report</title>
<style>
body {
  background-color: #0d1117;
  color: #c9d1d9;
  font-family: Arial, sans-serif;
  padding: 40px;
}
h1 { color: #58a6ff; }
.box {
  background-color: #161b22;
  padding: 20px;
  margin-top: 20px;
  border-radius: 8px;
}
table {
  width: 100%;
  border-collapse: collapse;
}
th, td {
  padding: 10px;
  border-bottom: 1px solid #30363d;
}
th { text-align: left; }
.status-ok { color: #00cc66; }
.status-alto { color: #ff4d4d; font-weight: bold; }
</style>
</head>
<body>

<h1>PrivEsc-Guard Security Report</h1>

<div class="box">
  <h2>Risk Score: $RISK_SCORE / $MAX_SCORE</h2>
  <h3 style="color:$COLOR;">Nivel: $LEVEL</h3>
</div>

<div class="box">
  <h2>Resumen por Módulo</h2>
  <table>
    <tr><th>Módulo</th><th>Estado</th></tr>
EOF

for module in "${!MODULE_STATUS[@]}"; do
  status="${MODULE_STATUS[$module]}"
  if [[ "$status" == "ALTO" ]]; then
    class="status-alto"
  else
    class="status-ok"
  fi
  echo "<tr><td>$module</td><td class=\"$class\">$status</td></tr>" >> "$HTML_REPORT_FILE"
done

cat <<EOF >> "$HTML_REPORT_FILE"
  </table>
</div>

<div class="box">
  <p><strong>Fecha:</strong> $(date)</p>
  <p><strong>Versión:</strong> $VERSION</p>
</div>

</body>
</html>
EOF

  echo "[+] HTML report generado en: $HTML_REPORT_FILE"
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

  echo
  echo "=============================="
  echo "Risk Score: $RISK_SCORE / $MAX_SCORE"
  echo "=============================="

  generate_html_report
}

main
