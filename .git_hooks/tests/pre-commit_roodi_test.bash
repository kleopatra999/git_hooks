#!/usr/bin/env bash

USE_HOOKS="roodi"
. test_helper

test_roodi(){
    echo "class User; def initialize; @@var += 1; end; end" > ./user.rb
    git add -A ./user.rb
    local warning=$(git commit -m "Created user to test roodi" 2>&1 1>/dev/null)
    # verify warning
    assertEquals "Roodi: user.rb:1 - Don't use class variables. You might want to try a different design." "$warning"
    # verify the change was commited
    local last_msg=$(git log --format='%s' -n 1)
    assertEquals "Created user to test roodi" "$last_msg"
}

. ./shunit2
