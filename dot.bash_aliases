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
    if [ $# -eq 0 ]; then
      file=$( ~/bin/projtool . )
    else
      file=$( ~/bin/projtool "$@" )
    fi
    if [[ -r $file ]]; then
      source $file
    fi
}

# Start a session on a remote machine.  It assumes that .tmux.config has already been
# deployed to the remote host.
conn() {
    if [ $# -eq 0 ]; then
      echo "TMUX ATTACH"
      tmux attach
      return 0
    fi
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

# Install environment on a new host
prov() {
  if [ "$#" != 1 ]; then
    echo usage: prov HOST
    return 127
  fi
  local host prov_cmd
  host=$1
  prov_cmd=/tmp/prov.$$.$RANDOM
  cat <<PROV_SCRIPT >$prov_cmd
#!/bin/sh

# Installs my dot files.  This is copied to remote hosts and executed
# by the bash alias 'prov HOSTNAME'

die() { echo "\$@" 1>&2 ; exit 1; }

if [ ! -e \$HOME/repos ]; then
  mkdir \$HOME/repos || die "Could not create repox directory"
fi

cd \$HOME/repos || die "Could not cd into repos directory"

if [ ! -e \$HOME/.ssh ]; then
   mkdir \$HOME/.ssh || die "Could not create .ssh directory"
   chmod 700 \$HOME/.ssh || die "Could not set permissions on .ssh directory"
fi

GITHUB="github.com,192.30.252.130 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ=="

if [ ! -e \$HOME/.ssh/known_hosts ]; then
   echo \$GITHUB > \$HOME/.ssh/known_hosts || die "Could not create known_hosts file"
   chmod 644 \$HOME/.ssh/known_hosts || die "Could not set permissions on known_hosts file"
else
   grep -q github.com \$HOME/.ssh/known_hosts
   if [ \$? != 0 ]; then
     echo \$GITHUB >> \$HOME/.ssh/known_hosts || die "Could not create known_hosts entry for github"
   fi
fi

if [ ! -e \$HOME/repos/dot.files ]; then
  git clone git@github.com:jmyounker/dot.files.git dot.files || die "Could not clone dot files"
else
  cd \$HOME/repos/dot.files
  git pull || die "Could not pull most recent dot files changes"
fi

cd \$HOME/repos/dot.files || die "Could not change into dot files directory"

./install || die "Could not install dot files"

PROV_SCRIPT
  chmod a+x $prov_cmd
  scp $prov_cmd $host:$prov_cmd
  rm $prov_cmd
  ssh -A -x $host $prov_cmd
  if [ "$?" == 0 ]; then
     ssh -x $host rm $prov_cmd
     conn $host 
  else
     ssh -x $host rm $prov_cmd
  fi
}

on_exit_acc () {
    local next="$1"
    eval "on_exit () {
        local oldcmd='$(echo "$next" | sed -e s/\'/\'\\\\\'\'/g)'
        local newcmd=\"\$oldcmd; \$1\"
        trap -- \"\$newcmd\" 0
        on_exit_acc \"\$newcmd\"
    }"
}
on_exit_acc true

rmkh() {
  sed -iback -e "${1}d" $HOME/.ssh/known_hosts
}
