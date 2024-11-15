#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function mfassi_cli_init () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFPATH="$(readlink -m -- "$BASH_SOURCE"/..)"
  # cd -- "$SELFPATH" || return $?
  source_these_libs "$SELFPATH"/funcs/*.sh || return $?

  local -A CFG=(
    [gxotp_win_opt]='-ontop -nofocus' # -nearmouse -sticky
    [gxotp_type_cooldown]='1s' # how to wait after faking input
    )
  local -A LOGIN=()
  case "$1" in
    -S ) mfassi_invoked_from_shebang "$@"; return $?;;
    '#!'* ) mfassi_invoked_from_shebang "$@"; return $?;;
  esac
  mfassi_"$@" || return $?
}


function source_in_func () {
  source -- "$@" || return $?$(
    echo "W: $FUNCNAME failed (rv=$?) for '$1'" >&2)
}


function source_these_libs () {
  local LIB=
  for LIB in "$@"; do
    source_in_func "$LIB" --lib || return $?
  done
}


function mfassi_rc () {
  local ARG="$1"; shift
  source_in_func "$ARG" || return $?
  mfassi_"$@" || return $?
}


function mfassi_eval () {
  local ARG="$1"; shift
  eval "$ARG" || return $?
  mfassi_"$@" || return $?
}










mfassi_cli_init "$@"; exit $?
