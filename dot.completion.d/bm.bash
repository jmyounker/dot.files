#!/usr/bin/env bash

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
