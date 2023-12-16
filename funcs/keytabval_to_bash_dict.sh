#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function mfassi_keytabval_to_bash_dict () {
  sed -re 's~\t~\n~' | sed -rf <(echo '
    # key transforms
    s~^~[~
    s~$~]~

    n
    # value transforms
    s~\x27+~\x27"&"\x27~g
    s~^~\x27~
    s~$~\x27~
    ') | sed -nre 'N;s~\n~=~p'
}









return 0
