#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function mfassi_invoked_from_shebang () {
  case "$1" in
    '#!' | -S ) shift;;
    * )
      echo E: $FUNCNAME: 'Invocation with glued arguments is deprecated!' \
        'For details, run: mfassi -S --help' >&2
      return 3;;
  esac

  case "$*" in
    --help )
      echo 'Use a shebang like this: #!/usr/bin/env -S mfassi -S' \
        '[<separator>] <action> [<arg>...] <separator>'
      echo 'Example: #!/usr/bin/env -S mfassi -S pwfile ::first gxotp --'
      echo
      echo 'There is no long option name for -S because of the' \
        'harsh length limit for shebang lines.' \
        "Thus, long options aren't vey useful there."
      echo 'The action name must start with a letter.' \
        'The separator must start with a non-letter.'
      echo 'If the first separator is omitted, the default value "--" is used.'
      echo "The final separator is mandatory because otherwise we couldn't" \
        "determine the position of the credentials filename."
      return 0;;
  esac

  case "$1" in
    '' ) echo E: $FUNCNAME: 'Action name must not be empty.' >&2; return 2;;
    [a-z]* ) set -- -- "$@";;
  esac

  local SEP="$1"; shift
  local ACTION=( $1 ); shift # action splitting is intentional.
  local ARGS=()
  while [ "$#" -ge 1 ]; do
    if [ "$1" == "$SEP" ]; then
      shift
      break
    else
      ARGS+=( "$1" )
      shift
    fi
  done
  local CREDS_FILE="$1"; shift
  mfassi_"${ACTION[@]}" "$CREDS_FILE" "${ARGS[@]}" "$@" || return $?
}








return 0
