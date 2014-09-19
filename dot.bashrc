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

if [ -e /usr/local/go ]; then
   export GOPATH=/usr/local/go
   if [ -e $HOME/repos ]; then
      GOPATH=$HOME/repos
   fi
   if [ -e $HOME/dev ]; then
      GOPATH=$HOME/dev
   fi
fi

# Turn on precommit checking for unstaged modifications to staged files.
export GIT_PRECOMMIT_CHECK_UNSTAGED="TRUE"  # Any non-zero length string turns it on

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
if [ -e /usr/local/bin/virtualenvwrapper.sh ]; then
    source /usr/local/bin/virtualenvwrapper.sh
fi

# Set up go language
export GOROOT=/usr/local/go

add_to_path () {
    if [ ! -d "$1" ]; then
        return 0
    fi
    if [[ "$PATH" =~ (^|:)"${1}"(:|$) ]]; then
        return 0
    fi
    export PATH=$PATH:$1
}

add_to_path "$HOME/bin"
add_to_path "$HOME/local/scala-2.0.12/bin"
add_to_path "/Applications/p4merge.app/Contents/MacOS"
add_to_path "$HOME/local/p4v/bin"
add_to_path "$GOROOT/bin"
add_to_path "$GOPATH/bin"
add_to_path "$GOPATH/src/github.com/soundcloud/system/bin"

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
         proj|projtools)
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


_conn_completion() {
    local cur prev conns
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    case "${prev}" in
         ssh|conn)
                conns=$( awk '/^host/{print $2}' $HOME/.ssh/config )
                COMPREPLY=( $(compgen -W "${conns}" -- ${cur}) )
                return 0
                ;;
        *)
        ;;
    esac

    return 0
}

complete -F _conn_completion conn
complete -F _conn_completion ssh

function_exists() {
    declare -f $1 > /dev/null
    return $?
}

function_exists _git && complete -F _git g

_dot_files_completion() {
   if [ ! -x ./install_dot_files ]; then
      return 0
   fi
   COMPREPLY=()
   cur="${COMP_WORDS[COMP_CWORD]}"
   prev="${COMP_WORDS[COMP_CWORD-1]}"
   case "${prev}" in
       ./install|./recover)
          files=$( ./install_dot_files --completions )
          COMPREPLY=( $(compgen -W "${files}" -- ${cur}) )
          return 0
          ;;
       *)
       ;;
   esac

   return 0
}

complete -F _dot_files_completion -o filenames ./install
complete -F _dot_files_completion -o filenames ./recover
complete -F _dot_files_completion -o filenames ./diff

