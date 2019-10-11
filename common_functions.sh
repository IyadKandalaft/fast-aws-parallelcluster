log() {
    echo "[$(date --rfc-3339=seconds)]: $*"
}

activate_conda(){
  CONDA=$1
  source $CONDA/etc/profile.d/conda.sh 
  conda activate
}

deactivate_conda(){
  [[ ! -z $CONDA_PREFIX ]] && conda deactivate
}

is_env_ready() {
  DEST_DIR=$1
  CONDA=$2
  REQUIREMENTS=$3

  # Ensure conda is deactivated before continuing
  [[ ! -z $CONDA_PREFIX ]] && conda deactivate

  # Assume environment is not setup
  ENV_READY=1

  cd $DEST_DIR

  # Check if the CONDA directory exists
  [[ ! -e $CONDA || ! -d $CONDA ]] && return $ENV_READY

  # Try to activate the CONDA environment
  activate_conda $CONDA
  [ $? -ne 0 ] && return $ENV_READY

  # Check if python modules are installed in the conda env
  for MODULE in $(cat $REQUIREMENTS); do
    log "Checking if Python module $MODULE exists"
    if ! pip list | grep -F $MODULE; then
      log "Module $MODULE is not installed"
      return $ENV_READY
    fi
  done

  ENV_READY=0
  return $ENV_READY
}

setup_env() {
  DEST_DIR=$1
  CONDA=$2
  REQUIREMENTS=$3

  deactivate_conda

  cd $DEST_DIR
  rm -rf $CONDA

  log "Downloading miniconda3"
  wget -nc https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
  log "Installing miniconda3 in $DESTDIR/$CONDA"
  bash Miniconda3-latest-Linux-x86_64.sh -b -p $CONDA

  activate_conda $CONDA

  log "Installing python modules in $REQUIREMENTS"
  pip install -r $REQUIREMENTS
}

check_aws_profile(){
  if aws configure get aws_access_key_id &>>/dev/null &&
     aws configure get aws_secret_access_key &>>/dev/null &&
     aws configure get default.region &>>/dev/null ; then
     return 0
  fi

  return 1
}

setup_aws_profile(){
  while ! aws configure; do
    log "AWS profile configuration failed"
    log "Re-initializing AWS profile configuration"
  done
}

pcluster_provision(){
  CONFIG=$1
  CLUSTER=$2

  export AWS_PCLUSTER_CONFIG_FILE=$CONFIG

  pcluster configure -c $CONFIG
  pcluster create $CLUSTER
}

pcluster_decom(){
  CONFIG=$1
  CLUSTER=$2

  export AWS_PCLUSTER_CONFIG_FILE=$CONFIG

  pcluster delete $CLUSTER
}
