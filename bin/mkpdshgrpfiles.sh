
mkdshgrp() {
echo $role
 for r in "$role";
 do
   if [ -f $HOME/repos/soundcloud/system/roles/$r.rb ]; then
     grpfile="$HOME/.dsh/group/$r"
     echo -n "Creating $grpfile "
     cd $HOME/repos/soundcloud/system
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
