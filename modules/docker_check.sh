#!/bin/bash

check_docker() {
  log_info "Analizando configuración de Docker..."

  echo

  if ! command -v docker &>/dev/null; then
    log_warn "Docker no está instalado en el sistema."
    return
  fi

  log_ok "Docker está instalado."

  if [[ -S "/var/run/docker.sock" ]]; then
    log_warn "Se encontró el socket Docker: /var/run/docker.sock"

    perms=$(stat -c "%a" /var/run/docker.sock)
    owner=$(stat -c "%U:%G" /var/run/docker.sock)

    echo -e "  Permisos: $perms"
    echo -e "  Propietario: $owner"

    if groups | grep -q docker; then
      echo -e "  ${RED}[ALTO RIESGO]${NC} El usuario pertenece al grupo docker."
    else
      echo -e "  ${YELLOW}[REVISAR]${NC} Verificar acceso al socket Docker."
    fi

  else
    log_ok "No se encontró el socket Docker."
  fi

  echo
  log_info "Contexto:"
  echo "  - Acceso al socket Docker permite controlar contenedores"
  echo "  - Puede permitir escalada a root en el host"

  echo
  log_info "Mitigación recomendada:"
  echo "  - Restringir acceso al grupo docker"
  echo "  - No añadir usuarios innecesarios al grupo docker"
  echo "  - Monitorizar uso del daemon Docker"

  echo
}
