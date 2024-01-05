#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function mfassi_invoked_from_shebang () {
  local TASK=( 'placeholder' $1 )
  TASK[0]="${TASK[1]}"; TASK[1]="$2"
  TASK[0]="${TASK[0]#'#!'}"
  mfassi_"${TASK[@]}" || return $?
}








return 0
