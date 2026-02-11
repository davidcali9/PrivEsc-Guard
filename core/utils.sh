#!/bin/bash

require_root() {
  if [[ $EUID -ne 0 ]]; then
    log_warn "Ejecutando sin privilegios root. Algunos checks pueden estar limitados."
  fi
}
