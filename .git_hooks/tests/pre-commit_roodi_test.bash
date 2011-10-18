#!/usr/bin/env bash

USE_HOOKS="roodi"
. test_helper

test_roodi(){
    echo "class User; def initialize; @@var += 1; end; end" > ./user.rb
    git add -A ./user.rb
    warning=$(git commit -m "Created user" 2>&1 1>/dev/null)
    assertEquals "user.rb:1 - Don't use class variables. You might want to try a different design." "$warning"
}

. ./shunit2