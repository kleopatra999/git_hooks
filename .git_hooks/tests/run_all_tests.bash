#!/usr/bin/env bash

cd $(dirname $0)
for t in ./*; do
    if [[ "$t" =~ "_test.bash" ]]; then
        tput bold; echo -e $t; tput sgr0;
        ./$t | grep -v '^#' | grep -v '^$'
        echo
    fi
done
