#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function str_repeat () {
  # args: n pattern
  local N="$1"
  while [ "$N" -ge 1 ]; do
    echo -n "$2"
    (( N -= 1 ))
  done
}





[ "$1" == --lib ] && return 0; "$@"; exit $?
