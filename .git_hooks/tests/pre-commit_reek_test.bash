#!/usr/bin/env bash

USE_HOOKS="reek"
. test_helper

test_reek_message(){
    local code="class User; end"
    local warning
    echo "$code" > ./user.rb
    git add ./user.rb
    warning=$(git commit -m "Created user" 2>&1 1>/dev/null)
    assertTrue "echo '${warning}' | grep 'user.rb:1 User has no descriptive comment (IrresponsibleModule)'"
}

. ./shunit2
