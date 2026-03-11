#!/usr/bin/env bash

INS=()
for f in *.sh; do
    case "$f" in
        font-install-all.sh|add-font-file.sh|remove-font-file.sh) ;;
        *) INS+=("$f") ;;
    esac
done
for installer in "${INS[@]}"
do
    bash "$installer" install
done
