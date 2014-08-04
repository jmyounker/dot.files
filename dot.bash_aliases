
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

function ssh-reagent () {
  export SSH_AUTH_SOCK=$(find /tmp/ssh-* -user `whoami` -name agent\* -printf '%T@ %p\n' 2>/dev/null | sort -k 1nr | sed 's/^[^ ]* //' | head -n 1)
  if ssh-add -l 2&>1 > /dev/null; then
    echo Found working SSH Agent:
    ssh-add -l
    return
  fi
  echo Cannot find ssh agent - maybe you should reconnect and forward it?
}
