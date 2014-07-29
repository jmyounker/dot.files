
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

proj() {
    local file
    file=$(~/bin/projtool "$@")
    if [[ -r $file ]]; then
        source $file
    fi
}

conn() {
    ssh -t "$@" screen -xRR
}

