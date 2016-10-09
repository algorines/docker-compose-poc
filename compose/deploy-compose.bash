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
  log_info "usage: $0 <environment> <version> <files_folder>"
  echo "  <environment>: [ stag | local ]"
  echo "  <version>: [ latest | stable | x.y.z ]"
  echo "  <files_folder>: /path/to/compose/files"

}

if [ "$#" -ne 3 ]; then
  usage
  exit 1
fi

files_folder=$3
if [ ! -d "$files_folder" ]; then
  usage
  log_error "ERROR: '$files_folder' does not exist or is not a directory"
  exit 1
fi

if [[ ! $files_folder = /* ]]; then
  usage
  log_error "ERROR: '$files_folder' must be an absolute path"
  exit 1
fi
if [ ! -f "$files_folder/docker-compose.template" ]; then
  usage
  log_error "ERROR: No such docker-compose.template file"
  exit 1
else
  if [ $1 == 'local' ]; then
    ENV='dev'
  else
    ENV='stag'
  fi
  cd $files_folder
  VERSION=$2
  cp ./common_env.template ./common.env
  cp ./docker-compose.template ./docker-compose.yml
  sed -i'.bk' 's/DEPLOYMENT_ENV/'$ENV'/g' ./common.env
  sed -i'.bk' 's/DEPLOYMENT_ENV/'$1'/g' ./docker-compose.yml
  sed -i'.bk' 's/VERSION/'$VERSION'/g' ./docker-compose.yml

  /usr/local/bin/docker-compose up -d
fi
