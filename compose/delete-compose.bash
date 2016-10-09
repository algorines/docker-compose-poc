#!/bin/bash
set -eu

red='\033[0;31m'
green='\033[0;32m'
NC='\033[0m' # No Color

log_info() {
  echo -e "\n${green}$1${NC}"
}

log_error() {
  echo -e "\n${red}$1${NC}"
}

usage() {
  log_info "usage: $0 <environment> <version>"
  echo "  <environment>: [ stag | local ]"
  echo "  <version>: [ latest | stable | x.y.z ]"
}

if [ "$#" -ne 2 ]; then
  usage
  exit 1
fi

if [ ! -f "./docker-compose.yml" ]; then
  usage
  log_error "ERROR: No such docker-compose.yml file"
  exit 1
else
  docker-compose down --rmi all -v

  rm ./common.env ./common.env.bk ./docker-compose.yml ./docker-compose.yml.bk
fi
