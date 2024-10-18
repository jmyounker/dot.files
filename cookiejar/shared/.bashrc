#!/bin/bash

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export EDITOR=vi

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
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=1000
export HISTFILESIZE=2000

# enable color support of ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Read .bash_aliases to pick up all my shortcuts
[[ -r ~/.bash_aliases ]] && . ~/.bash_aliases
if [ -f ~/.env.d/*/bash_aliases ]; then
   for f in $( ls ~/.env.d/*/bash_aliases ); do
       source $f
   done
fi


# Set up virtualenvwrapper for Python development.
export WORKON_HOME=$HOME/.virtualenv
export PROJECT_HOME=$HOME/Projects
if [ -e /usr/local/bin/virtualenvwrapper.sh ]; then
    source /usr/local/bin/virtualenvwrapper.sh
fi

# Set up go language
export GOROOT=/usr/local/go

prepend_to_path () {
    if [ ! -d "$1" ]; then
        return 0
    fi
    if [[ "$PATH" =~ (^|:)"${1}"(:|$) ]]; then
        return 0
    fi
    export PATH=$1:$PATH
}

append_to_path () {
    if [ ! -d "$1" ]; then
        return 0
    fi
    if [[ "$PATH" =~ (^|:)"${1}"(:|$) ]]; then
        return 0
    fi
    export PATH=$PATH:$1
}

prepend_to_path "/usr/local/go/bin"
prepend_to_path "$HOME/bin"
prepend_to_path "$HOME/.jenv/shims"
append_to_path "$HOME/local/scala-2.0.12/bin"
append_to_path "/Applications/p4merge.app/Contents/MacOS"
append_to_path "$HOME/local/p4v/bin"
append_to_path "$GOROOT/bin"
append_to_path "$GOPATH/bin"
append_to_path "/usr/local/mysql/bin/"
append_to_path "/usr/local/apache-ant/bin"
append_to_path "/Applications/SWI-Prolog.app/Contents/MacOS"

# Set up most awesome command line prompt
export EMERGENCY_PROMPT='${debian_chroot:+($debian_chroot)}\\u@\\h:\\[$(tput -T${TERM:-dumb} setaf 1)\\]DUDE!\ CANT\ RUN\ GET_PROMPT.\ WTF?\\[$(tput -T${TERM:-dumb} sgr0)\\]\\$ '
PROMPT_COMMAND='eval `~/bin/get_prompt || echo export PS1=$EMERGENCY_PROMPT` '


# Read in bashrc for other environments
if [ -f ~/.env.d/*/bashrc ]; then
    for f in $( ls $HOME/.env.d/*/bashrc ); do
        source $f
    done
fi

function_exists() {
    declare -f $1 > /dev/null
    return $?
}

executable_in_path() {
    which $1 > /dev/null
    return $?
}

source_if_exists() {
    if [ -f $1 ]; then
        source $1
    fi
}

# Google Cloud SDK.
if [[ -r ~/google-cloud-sdk ]]; then
  source ~/google-cloud-sdk/path.bash.inc
  source ~/google-cloud-sdk/completion.bash.inc
fi

# Include command line completions from brew.
if $( which brew > /dev/null 2>&1 ); then
    brew_compl_dir=$(brew --prefix)/etc/bash_completion.d
    if [ -d $brew_compl_dir ]; then
        # AG completions are broken
        # source_if_exists $brew_compl_dir/ag.completion.bash
        source_if_exists $brew_compl_dir/git-completion.bash
        source_if_exists $brew_compl_dir/tig-completion.bash
        source_if_exists $brew_compl_dir/tmux
        source_if_exists $brew_compl_dir/subversion
    fi
fi

source ${HOME}/.completion.d/jar.bash
source ${HOME}/.completion.d/cmdplx.bash
source ${HOME}/.completion.d/bm.bash
source ${HOME}/.completion.d/dot.files.bash
source ${HOME}/.completion.d/conn.bash
source ${HOME}/.completion.d/virtualenv.bash
source ${HOME}/.completion.d/projtool.bash

export CLICOLOR=1
export LSCOLORS='cxCxdxDxexEgegBxBxBxbx'

# Completion for the 's' cmdplx
if ( function_exists "_svn" ); then
  complete -F _svn -o default -X '@(*/.svn|*/.svn/|.svn|.svn/)' s
fi

# Docker
redock
