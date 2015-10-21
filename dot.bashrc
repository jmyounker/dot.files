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
add_to_path "/usr/local/go/bin"
add_to_path "$HOME/local/scala-2.0.12/bin"
add_to_path "/Applications/p4merge.app/Contents/MacOS"
add_to_path "$HOME/local/p4v/bin"
add_to_path "$GOROOT/bin"
add_to_path "$GOPATH/bin"
add_to_path "/usr/local/mysql/bin/"

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
complete -F _conn_completion prov
complete -F _conn_completion ssh

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


_bm_completion() {
    local cur prev completions
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    case "${prev}" in
         bm|bmtool)
                completions=$( bmtool --list )
                COMPREPLY=( $(compgen -W "${completions}" -- ${cur}) )
                return 0
                ;;
        *)
        ;;
    esac

    return 0
}

complete -F _bm_completion bm
complete -F _bm_completion bmtool


_cmdplx_completion() {
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    case "${prev}" in
       j|m|s|t|v|ve)
          _cmdplx_completer_cmds "${prev}" "${cur}"
       ;;
       *)
       ;;
    esac
}

complete -F _cmdplx_completion j
complete -F _cmdplx_completion m
complete -F _cmdplx_completion s
complete -F _cmdplx_completion t
complete -F _cmdplx_completion v
complete -F _cmdplx_completion ve


_jar_completion() {
    local cur prev1 prev2 prev3 completions
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev1="${COMP_WORDS[COMP_CWORD-1]}"
    case "${#COMP_WORDS[@]}" in
        2)
            case "${prev1}" in
                jr)
                    _cmdplx_completer_cmds jr "${cur}"
                    ;;
                jar-map|jar-apply)
                    COMPREPLY=( $( compgen -A command -- "${cur}" ) )
                    ;;
                *)
                ;;
            esac
            return 0
            ;;
        3)
            prev2="${COMP_WORDS[COMP_CWORD-2]}"
            case "${prev2}" in
                *)  # will default to filename completion if set up with -o default
                ;;
            esac
            return 0
            ;;
        4)
            prev3="${COMP_WORDS[COMP_CWORD-3]}"
            case "${prev3}" in
                jr|jar-map|jar-apply)
                    _jar_completer_from_jarfile "${prev1}" "${cur}"
                    ;;
                *)
                ;;
            esac
            return 0
            ;;
        *)
        ;;
    esac
    return 0
}


_cmdplx_completer_cmds() {
    local cur plx completions
    plx=$1
    cur=$2
    if [ -f "${HOME}/.${plx}.config" ]; then
        completions=$( cmdplx ${plx} | sed 's/echo cmds://' | tr ',' ' ')
        COMPREPLY=( $(compgen -W "${completions}" -- ${cur} ) )
    else
        COMPREPLY=()
    fi
}


_jar_completer_from_jarfile() {
    local cur jar_file
    jar_file=$1
    cur=$2
    if [ -f "${jar_file}" ]; then
        completions=$( jar tf ${jar_file} )
        COMPREPLY=( $( compgen -W "${completions}" -- ${cur}) )
    fi
}

complete -o nospace -o default -F _jar_completion jar
complete -o nospace -o default -F _jar_completion jr
complete -o nospace -o default -F _jar_completion jar-map
complete -o nospace -o default -F _jar_completion jar-apply


# Completion for the 'g' cmdplx
if ( function_exists "__git_complete" && function_exists "__git_main" ); then
   __git_complete g __git_main
fi

# Completion for the 's' cmdplx
if ( function_exists "_svn" ); then
  complete -F _svn -o default -X '@(*/.svn|*/.svn/|.svn|.svn/)' s
fi

# Docker
redock
