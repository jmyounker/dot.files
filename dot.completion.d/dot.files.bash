#!/usr/bin/env bash

_dot_files_completion() {
   if [ ! -x ./install_dot_files ]; then
      return 0
   fi
   COMPREPLY=()
   cur="${COMP_WORDS[COMP_CWORD]}"
   prev="${COMP_WORDS[COMP_CWORD-1]}"
   case "${prev}" in
       ./install|./recover)
          files=$( ./install_dot_files --completions )
          COMPREPLY=( $(compgen -W "${files}" -- ${cur}) )
          return 0
          ;;
       *)
       ;;
   esac

   return 0
}

complete -F _dot_files_completion -o filenames ./install
complete -F _dot_files_completion -o filenames ./recover
complete -F _dot_files_completion -o filenames ./diff
