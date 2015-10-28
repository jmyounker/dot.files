#!/usr/bin/env bash

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

