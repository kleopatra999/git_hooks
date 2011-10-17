#!/usr/bin/env bash

tests="commit-msg_test.bash  pre-commit_docs_test.bash  pre-commit_syntax_test.bash"

for t in $tests; do
    tput bold; echo -e $t; tput sgr0;
    ./$t | grep -v '^#' | grep -v '^$'
    echo
done
