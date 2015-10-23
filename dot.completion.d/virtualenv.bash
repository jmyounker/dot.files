#!/usr/bin/env bash

_virtualenv_completion() {
    local cur virtualenvs
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    virtualenvs=$( workon )
    COMPREPLY=( $(compgen -W "${virtualenvs}" -- ${cur}) )
    return 0
}

complete -F _virtualenv_completion workon
