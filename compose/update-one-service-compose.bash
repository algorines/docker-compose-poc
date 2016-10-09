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
  log_info "usage: $0 <microservice_name>"
  echo "  <microservice_name>: microservice name to update"
}

if [ "$#" -ne 1 ]; then
  usage
  exit 1
fi

name_svc=$1

docker-compose pull $name_svc
docker-compose up -d $name_svc
