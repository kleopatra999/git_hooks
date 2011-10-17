#!/usr/bin/env bash

for t in ./*; do
    if [[ "$t" =~ "test.bash" ]]; then
        tput bold; echo -e $t; tput sgr0;
        ./$t | grep -v '^#' | grep -v '^$'
        echo
    fi
done
