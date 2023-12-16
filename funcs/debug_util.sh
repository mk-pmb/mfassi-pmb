#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function mfassi_dump_login_dict () {
  local KEYS=()
  readarray -t KEYS < <(printf -- '%s\n' "${!LOGIN[@]}")
  local KEY=
  for KEY in "${KEYS[@]}"; do
    printf -- '[%q]=%q\n' "$KEY" "${LOGIN["$KEY"]}"
  done
}








return 0
