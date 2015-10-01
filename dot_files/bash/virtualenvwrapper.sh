# /bin/bash

export WORKON_HOME=~/venvs

# make sure to use the system python
# prevents problems starting subshell
VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
source /usr/local/bin/virtualenvwrapper.sh

# setting prompt in prompt.sh
export VIRTUAL_ENV_DISABLE_PROMPT=1

# starting a new shell will inherit this but virtualenv won't really be active
export VIRTUAL_ENV=
