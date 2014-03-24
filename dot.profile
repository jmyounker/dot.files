resource() {
  source $HOME/.profile
}

# Set up virtualenvwrapper for Python development.
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Projects
source /usr/local/bin/virtualenvwrapper.sh

PATH=$PATH:$HOME/local/scala-2.0.12/bin

export EMERGENCY_PROMPT='${debian_chroot:+($debian_chroot)}\\u@\\h:\\[$(tput -T${TERM:-dumb} setaf 1)\\]DUDE!\ CANT\ RUN\ GET_PROMPT.\ WTF?\\[$(tput -T${TERM:-dumb} sgr0)\\]\\$ '

PROMPT_COMMAND='eval `~/bin/get_prompt || echo export PS1=$EMERGENCY_PROMPT` '
