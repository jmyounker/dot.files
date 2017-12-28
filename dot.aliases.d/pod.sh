#@IgnoreInspection BashAddShebang


POD_FILE="$HOME/.current-pod"

pod() {
    if [ "$1" == '--local' ]; then
        shift
        if [ "$1" == '' ]; then
            echo 'pod name required' >& 2
            return 127
        fi
        export POD="$1"
        return 0
    fi
    if [ -n "$1" ]; then
        echo "$1" > $POD_FILE
        unset POD
        return 0
    fi
    if [ -n "$POD" ]; then
        echo $POD
        return 0
    fi
    if [ -r "$POD_FILE" ]; then
        cat $POD_FILE
        return 0
    fi
    echo 'no pod currently defined' >& 2
    return 1
}

podhost() {
   local domain returncode
   domain="$(pod).dev-raisin.com"
   returncode=$?
   if [ $returncode != 0 ]; then
       return $returncode
   fi
   if [ -z "$1" ]; then
       echo $domain
   else
       echo $1.$domain
   fi
}

p() {
  podhost "$@"
}

sp() {
  pod "$@"
}

khrp() {
  # KnownHostsRemovePod.  Removes all of a pod's entries from known hosts.
  local pod_name_to_remove
  pod_name_to_remove=$(setpod)
  if [ -n "$1" ]; then
     pod_name_to_remove="$1"
  else
     pod_name_to_remove=$(pod)
     if [ $? != 0 ]; then
         cat <<EOUSAGE >&2
usage: ${FUNCNAME[0]} [PODNAME]

error: Must supply a pod name through the command line or \$POD.

Removes all entries for a pod from your known hosts.  Uses the command line
value if specified.  Tries to use the environment variable \$POD if a value
was not specified on the command line.
EOUSAGE
         return 127
     fi
  fi
  # Use a single sed command to get around the horrible impact of filesystem caching.
  grep -n "$pod_name_to_remove" $HOME/.ssh/known_hosts | awk -F: '{print $1}' | sort -u | xargs -L1 -II echo Id\; | xargs | xargs -L1 -II echo sed -i -e \'I\' $HOME/.ssh/known_hosts | sh
}


