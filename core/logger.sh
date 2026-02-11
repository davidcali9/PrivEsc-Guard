#!/bin/bash

log_info() {
  echo -e "${BLUE}[i]${NC} $1"
}

log_ok() {
  echo -e "${GREEN}[+]${NC} $1"
}

log_warn() {
  echo -e "${YELLOW}[!]${NC} $1"
}

log_critical() {
  echo -e "${RED}[!!]${NC} $1"
}
