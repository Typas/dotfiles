#!/usr/bin/env sh

INS=($(ls *.sh | grep -v font-install-all.sh | grep -v add-font-file.sh | grep -v remove-font-file.sh))
for installer in ${INS[@]}
do
    bash "$installer" install
done
