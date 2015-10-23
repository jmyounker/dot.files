#!/usr/bin/env bash

_cmdplx_completion() {
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    case "${prev}" in
       j|jr|m|s|t|v|ve)
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

_jr_completion() {
    local cmd subcmd cur completions
    COMPREPLY=()
    cmd="${COMP_WORDS[0]}"
    subcmd="${COMP_WORDS[1]}"
    cur="${COMP_WORDS[COMP_CWORD]}"
    case "${#COMP_WORDS[@]}" in
        2)
            case "${cmd}" in
                jr)
                    _cmdplx_completer_cmds jr "${cur}"
                    ;;
                *)  # will default to filename completion if set up with -o default
                ;;
            esac
            return 0
            ;;
        3)
            case "${cmd}" in
                *)  # will default to filename completion if set up with -o default
                ;;
            esac
            return 0
            ;;
        4)
            case "${subcmd}" in
                apply|map)
                    COMPREPLY=( $( compgen -A command -- "${cur}" ) )
                    ;;
                *)
                ;;
            esac
            return 0
            ;;
        *)
            case "${subcmd}" in
                apply|map)
                    _jar_completer_from_jarfile "${COMP_WORDS[3]}" "${cur}"
                    ;;
                *)
                ;;
            esac
            return 0
            ;;
    esac
    return 0
}

complete -o nospace -o default -F _jr_completion jr

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
