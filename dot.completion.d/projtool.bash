#!/usr/bin/env bash

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

