#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function mfassi_gxotp () {
  while [ "$#" -ge 1 ]; do
    case "$1" in
      tabs=[0-9]* ) mfassi_gxotp__split_short_opt_tabs "${1#*=}" || return $?;;
      [a-z]*=* ) CFG["gxotp_${1%%=*}"]="${1#*=}";;
      * ) echo E: $FUNCNAME: "Unsupported option: $1"; return 3;;
    esac
    shift
  done

  local -A TABS_AFTER=()
  local KEY= VAL=
  for KEY in user pswd otp ; do
    TABS_AFTER[$KEY]="$(str_repeat "${CFG[gxotp_tabs_after_$KEY]:-1}" $'\t')"
  done
  local GX_RV=
  local GX_BTN='
    user _tab pswd:5,
    _user:6,
    _pswd:7,
    T_OTP:8,
    GTK_STOCK_REFRESH:0,
    GTK_STOCK_CANCEL:1'
  GX_BTN="${GX_BTN//$'\n    '/}"
  local L_USER="${LOGIN[user]}"
  [ -z "${LOGIN[user_prefix]%¬}" ] || L_USER="${LOGIN[user_prefix]}$L_USER"
  [ -z "${LOGIN[user_suffix]%¬}" ] || L_USER+="${LOGIN[user_suffix]}"
  local GX_MSG=(
    gxmessage
    -buttons "$GX_BTN"
    -title "mfassi: $L_USER"
    ${CFG[gxotp_win_opt]}
    )
  local OTP_KEY="${LOGIN[totp_key]}"
  OTP_KEY="${OTP_KEY// /}"
  OTP_KEY="${OTP_KEY%%[^A-Za-z2-7]*}"
  # ^-- Strip off potential comment after base32 characters.
  local OTP_GEN='oathtool --totp --base32 -- '
  local OTP_PIN=
  local XDO_TYPE=
  while [ "$GX_RV" != 1 ]; do
    [ -z "$OTP_KEY" ] || OTP_PIN="$( $OTP_GEN "$OTP_KEY" )"
    "${GX_MSG[@]}" -file <(
      echo "user: $L_USER"
      echo "OTP: ${OTP_PIN:-(found no key)}"
      )
    GX_RV="$?"
    case "$GX_RV" in
      5 | 6 ) XDO_TYPE+="$L_USER${TABS_AFTER[user]}";;&
      5 | 7 ) XDO_TYPE+="${LOGIN[pswd]}${TABS_AFTER[pswd]}";;
      8 ) XDO_TYPE="$( $OTP_GEN "$OTP_KEY" )${TABS_AFTER[otp]}";;
    esac
    if [ -n "$XDO_TYPE" ]; then
      xdotool type "$XDO_TYPE"
      sleep "${CFG[gxotp_type_cooldown]}" || return $?$(
        echo 'E: Failed gxotp_type_cooldown' >&2)
    fi
    XDO_TYPE=
  done
}


function mfassi_gxotp__split_short_opt_tabs () {
  set -- ${1//,/ }
  local KEY=
  for KEY in user pswd otp; do
    CFG[gxotp_tabs_after_"$KEY"]="$1"; shift || true
  done
}








return 0
