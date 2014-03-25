#!/bin/bash

# Reload the environemnt
resource() {
    source ~/.bashrc
}

# Read .bash_aliases to pick up all my shortcuts
[[ -r ~/.bash_aliases ]] && . ~/.bash_aliases
