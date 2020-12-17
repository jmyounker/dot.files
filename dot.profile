#!/bin/bash -x

# Pull in .bashrc
[[ -r ~/.bashrc ]] && source ~/.bashrc

# Override defnition from .bashrc
resource() {
  source ~/.profile
}

if [ $(uname) == "Darwin" ]; then
    # Override export so that variables become visible to processes
    # launched from finder.
    function export() {
        builtin export "$@"
        if [[ ${#@} -eq 1 && "${@//[^=]/}" ]]
        then
            launchctl setenv "${@%%=*}" "${@##*=}"
        elif [[ ! "${@//[^ ]/}" ]]
        then
            launchctl setenv "${@}" "${!@}"
        fi
    }

   export -f export
fi


export PATH="$HOME/.cargo/bin:$PATH"
