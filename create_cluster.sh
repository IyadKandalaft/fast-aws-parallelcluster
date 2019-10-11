#!/bin/bash

SCRIPT_PATH=$(cd -P -- "$(dirname -- $0)" && pwd -P)

. common_vars.sh
. common_functions.sh

main() {
  log "Checking if environment is already setup"
  if ! is_env_ready $SCRIPT_PATH $CONDA_PATH $CONDA_REQUIREMENTS; then
    log "Setting up a new environment" 
    setup_env $SCRIPT_PATH $CONDA_PATH $CONDA_REQUIREMENTS
  else
    log "Existing environment is setup"
  fi
  
  # Activate the conda environment
  cd $SCRIPT_PATH

  log "Activating environment"
  activate_conda $CONDA

  if ! check_aws_profile; then
    log "Your AWS profile is not configured"
    log "Please set your access key, secret, and default region when prompted"
    setup_aws_profile 
  fi

  # Configure the parallel cluster
  pcluster_provision $PCLUSTER_CONFIG $PCLUSTER_NAME

  pcluster ssh $PCLUSTER_NAME ls /shared
}

main
