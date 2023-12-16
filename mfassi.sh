#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function mfassi_cli_init () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFPATH="$(readlink -m -- "$BASH_SOURCE"/..)"
  # cd -- "$SELFPATH" || return $?
  source_these_libs "$SELFPATH"/funcs/*.sh || return $?

  local -A CFG=() LOGIN=()
  mfassi_"$@" || return $?
}


function source_in_func () { source -- "$@"; }


function source_these_libs () {
  local LIB=
  for LIB in "$@"; do
    source_in_func "$LIB" --lib || return $?
  done
}










mfassi_cli_init "$@"; exit $?
