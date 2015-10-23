#!/usr/bin/env bash

_jar_completion() {
    local cmd cur completions
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    cmd="${COMP_WORDS[0]}"
    case "${#COMP_WORDS[@]}" in
        2)
            return 0
            ;;
        3)
            case "${cmd}" in
                jar-map|jar-apply)
                    COMPREPLY=( $( compgen -A command -- "${cur}" ) )
                ;;
                *)  # will default to filename completion if set up with -o default
                ;;
            esac
            return 0
            ;;
        *)
            case "${cmd}" in
                jar-map|jar-apply)
                    _jar_completer_from_jarfile "${COMP_WORDS[1]}" "${cur}"
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

_jar_completer_from_jarfile() {
    local cur jar_file
    jar_file=$1
    cur=$2
    if [ -f "${jar_file}" ]; then
        completions=$( jar tf ${jar_file} )
        COMPREPLY=( $( compgen -W "${completions}" -- ${cur}) )
    fi
}

complete -o nospace -o default -F _jar_completion jar-map
complete -o nospace -o default -F _jar_completion jar-apply

