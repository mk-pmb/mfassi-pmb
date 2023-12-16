#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function mfassi_gxotp () {
  local GX_RV=
  local GX_BTN='
    user _tab pswd:5,
    _user:6,
    _pswd:7,
    T_OTP:8,
    GTK_STOCK_REFRESH:0,
    GTK_STOCK_CANCEL:1'
  GX_BTN="${GX_BTN//$'\n    '/}"
  local GX_MSG=(
    gxmessage
    -buttons "$GX_BTN"
    -title "mfassi: ${LOGIN[user]}"
    # -center
    -nearmouse
    -ontop
    -sticky
    )
  local OTP_KEY="${LOGIN[totp_key]}"
  local OTP_GEN='oathtool --totp --base32 -- '
  local OTP_PIN=
  local XDO_TYPE=
  while [ "$GX_RV" != 1 ]; do
    [ -z "$OTP_KEY" ] || OTP_PIN="$( $OTP_GEN "$OTP_KEY" )"
    "${GX_MSG[@]}" -file <(
      echo "user: ${LOGIN[user]}"
      echo "OTP: ${OTP_PIN:-(found no key)}"
      )
    GX_RV="$?"
    case "$GX_RV" in
      5 ) XDO_TYPE="${LOGIN[user]}"$'\t'"${LOGIN[pswd]}"$'\t';;
      6 ) XDO_TYPE="${LOGIN[user]}"$'\t';;
      7 ) XDO_TYPE="${LOGIN[pswd]}"$'\t';;
      8 ) XDO_TYPE="$( $OTP_GEN "$OTP_KEY" )"$'\t';;
    esac
    if [ -n "$XDO_TYPE" ]; then
      xdotool type "$XDO_TYPE"
      sleep 3s
    fi
    XDO_TYPE=
  done
}








return 0
