#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function mfassi_eqdict () {
  local DICT="$1"; shift
  while [ "$#" -ge 1 ]; do case "$1" in
    '' ) shift;;
    *=* ) eval "$DICT"'["${1%%=*}"]="${1#*=}"'; shift;;
    -- ) shift; break;;
  esac; done
  [ -z "$1" ] || mfassi_"$@" || return $?
}








return 0
