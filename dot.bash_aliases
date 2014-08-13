# Go back up the directory tree
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

alias g=git

# A wrapper around the projtool
proj() {
    local file
    file=$(~/bin/projtool "$@")
    if [[ -r $file ]]; then
        source $file
    fi
}

# Start a session on a remote machine.  It assumes that .tmux.config has already been
# deployed to the remote host.
conn() {
    ssh -t "$@" tmux attach
}

# Connect a session to an already existing ssh-agent
function ssh-reagent () {
  export SSH_AUTH_SOCK=$(find /tmp/ssh-* -user `whoami` -name agent\* -printf '%T@ %p\n' 2>/dev/null | sort -k 1nr | sed 's/^[^ ]* //' | head -n 1)
  if ssh-add -l 2&>1 > /dev/null; then
    echo Found working SSH Agent:
    ssh-add -l
    return
  fi
  echo Cannot find ssh agent - maybe you should reconnect and forward it?
}

# Reconnects a TMUX session to the underlying x display and ssh-agents
reconn() {
  update_env_script=$(tempfile)
  tmux showenv | awk '{if (/^-/) {print "unset " substr($0 ,2)} else {sub(/=/, "=\""); print "export " $0 "\"" }}' > $update_env_script
  source $update_env_script
  rm $update_env_script
}
