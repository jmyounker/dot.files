#!/bin/bash

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Reload the environemnt
resource() {
    source ~/.bashrc
}

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# enable color support of ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Read .bash_aliases to pick up all my shortcuts
[[ -r ~/.bash_aliases ]] && . ~/.bash_aliases

# Set up virtualenvwrapper for Python development.
export WORKON_HOME=$HOME/.virtualenv
export PROJECT_HOME=$HOME/Projects
source /usr/local/bin/virtualenvwrapper.sh

# Set up go language
export GOROOT=/usr/local/go

PATH=$PATH:$HOME/bin:$HOME/local/scala-2.0.12/bin:/Applications/p4merge.app/Contents/MacOS:$GOROOT/bin

# Set up most awesome command line prompt
export EMERGENCY_PROMPT='${debian_chroot:+($debian_chroot)}\\u@\\h:\\[$(tput -T${TERM:-dumb} setaf 1)\\]DUDE!\ CANT\ RUN\ GET_PROMPT.\ WTF?\\[$(tput -T${TERM:-dumb} sgr0)\\]\\$ '
PROMPT_COMMAND='eval `~/bin/get_prompt || echo export PS1=$EMERGENCY_PROMPT` '


# Google Cloud SDK.
if [[ -r ~/google-cloud-sdk ]]; then
  source ~/google-cloud-sdk/path.bash.inc
  source ~/google-cloud-sdk/completion.bash.inc
fi


_proj_completion() {
    local cur prev opts projects
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    case "${prev}" in
         proj)
                projects=$( projtool ls )
                COMPREPLY=( $(compgen -W "${projects}" -- ${cur}) )
                return 0
                ;;
        projtool)
                projects=$( projtool ls )
                COMPREPLY=( $(compgen -W "${projects}" -- ${cur}) )
                return 0
                ;;
        *)
        ;;
    esac

    return 0
}

complete -F _proj_completion proj
complete -F _proj_completion projtool


_virtualenv_completion() {
    local cur virtualenvs
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    virtualenvs=$( workon )
    COMPREPLY=( $(compgen -W "${virtualenvs}" -- ${cur}) )
    return 0
}

complete -F _virtualenv_completion workon
