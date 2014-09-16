#!/bin/bash

mkdshgrp() {
echo $role
if [ ! -d "$HOME/.dsh/group" ]; then
   mkdir -p "$HOME/.dsh/group"
fi

for r in "$role"; do
   knife role show $role > /dev/null 2>&1
   if [ $? == 0 ]; then
     grpfile="$HOME/.dsh/group/$r"
     echo -n "Creating $grpfile "
     knife search node "roles:$r" -i | grep net | sort > $grpfile
     echo "- $(wc -l ${grpfile} | awk '{print $1}') hosts"
     if [ -s $grpfile ]; then
       cat $grpfile
     else
       echo "No hosts found for $r"
       rm $grpfile
     fi
   else
     echo "Role $r not found"
   fi
 done
}
role=("$@")
mkdshgrp
