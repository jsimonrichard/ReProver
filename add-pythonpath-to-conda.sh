#!/bin/bash

if [ "$CONDA_DEFAULT_ENV" = "base" ]; then
  echo "Active your conda environment first."
  exit 1
fi

# Create activation script
mkdir -p $CONDA_PREFIX/etc/conda/activate.d
cat << EOF > $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
#!/bin/bash
# Store the existing PYTHONPATH
export _OLD_PYTHONPATH="\$PYTHONPATH"

# Append new paths
export PYTHONPATH="\$PYTHONPATH:$(pwd)"
EOF

# Create deactivation script
mkdir -p $CONDA_PREFIX/etc/conda/deactivate.d
cat << EOF > $CONDA_PREFIX/etc/conda/deactivate.d/env_vars.sh
#!/bin/bash
# Restore the old PYTHONPATH
export PYTHONPATH="\$_OLD_PYTHONPATH"
unset _OLD_PYTHONPATH
EOF

# Make the scripts executable
chmod +x $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
chmod +x $CONDA_PREFIX/etc/conda/deactivate.d/env_vars.sh

ENV_NAME=$CONDA_DEFAULT_ENV

# Reactivate your environment
CONDA_PATH=$(conda info --base)
source "$CONDA_PATH/etc/profile.d/conda.sh" # required for conda deactivate

conda deactivate && conda activate $ENV_NAME