#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function mfassi_pwfile () {
  local SRC_ORIG="$1"; shift
  local WANT_USER="$1"; shift
  local NEXT_TASK="$1"; shift

  local SRC_ABS="$(readlink -m -- "$SRC_ORIG")"
  [ -n "$SRC_ABS" ] || return $?$(
    echo "E: $FUNCNAME: Failed to resolve pwfile: $SRC_ORIG" >&2)
  local SRC_TEXT="$(mfassi_pwfile_preparse_keytabval <"$SRC_ABS")"
  [ -n "$SRC_TEXT" ] || return 3$(
    echo "E: $FUNCNAME: Failed to read pwfile: $SRC_ORIG" >&2)

  local MAXLN=9009009
  local USER_GREP=( -Pe '^user\t' )
  case "$WANT_USER" in
    '' )
      echo "E: Expected a username, or '::first' (or '¹')" \
        "for the first found name." >&2
      return 3;;
    '::first' | '¹' ) ;;
    * ) USER_GREP=( -xFe $'user\t'"$WANT_USER" );;
  esac
  SRC_TEXT+=$'\nuser\t\n'
  SRC_TEXT="$(<<<"$SRC_TEXT" grep "${USER_GREP[@]}" -m 1 -A $MAXLN)"
  SRC_TEXT="$(<<<"$SRC_TEXT" grep -Pe '^user\t' -m 2 -B $MAXLN)"
  SRC_TEXT="${SRC_TEXT%$'\nuser\t'*}"
  [ -n "$SRC_TEXT" ] || return 4$(
    echo "E: Found no credentials for user '${WANT_USER:-<any>}'" >&2)

  LOGIN=()
  if [ -z "$NEXT_TASK" ]; then echo "$SRC_TEXT"; return 0; fi
  local SRC_TEXT="$( mfassi_keytabval_to_bash_dict <<<"$SRC_TEXT" )"
  if [ "$NEXT_TASK" == --bash-dict ]; then echo "$1$SRC_TEXT$2"; return 0; fi
  eval "LOGIN=( $SRC_TEXT )"
  mfassi_"$NEXT_TASK" "$@"; return $?
}


function mfassi_pwfile_preparse_keytabval () {
  sed -rf <(echo '
    s:\s+: :g
    s~\a|\v~~g
    s~^~\r~g
    ') | sed -rf <(echo '
    s~^\r(-{3,}|={3,})$~<\a:bar>~
    $s~$~\r~
    ') | tr -d '\n' | tr '\r' '\n' | sed -nrf <(echo '
    s~^([A-Za-z0-9. _-]+): ~\1\t~
    s~^<\a:bar>$~~
    s~^([^\a]+)<\a:bar>$~\a= user\t\1~
    s~^([^\a\t]+ |)([0-9]{6}|$\
      [0-9]{4}-[0-9]{2}-[0-9]{2}|$\
      )( |\t)~\1<\a:maybeDate>\3~g
    s~^([^\a\t]+)(\s)(<\a:maybeDate>)~\3\2\1~
    s~^(<\a:maybeDate>) ~\a= ~
    s~^\a= ([^\t]+)\t~\1\n~p
    ') | sed -rf <(echo '
    s~[A-Z]+~\L&\E~g
    s~ ~_~g
    s~^(totp_)secret$~\1key~
    s~^pass$~pswd~
    s~^password$~pswd~
    s~^pw$~pswd~
    s~^(user)_?name$~\1~
    s~^un$~user~
    n
    ') | sed -re 'N;s~\n~\t~'
}









return 0
