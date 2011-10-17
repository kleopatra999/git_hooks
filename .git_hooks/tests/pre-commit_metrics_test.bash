#!/usr/bin/env bash

INSTALL_HOOKS="pre-commit  pre-commit_metrics"
. test_helper

test_flog_message(){
    local warning
    echo "puts 'Hello world!:)'" > ./hello_world.rb
    git add ./hello_world.rb
    git commit -m 'first hello commit' > /dev/null

    echo "instance_eval{ instance_eval{ instance_eval{ puts 'Hi!' } } }" > ./hello_world.rb
    git add ./hello_world.rb
    warning=$(git commit -m 'second hello commit' 2>&1 1>/dev/null)
    assertEquals "hello_world.rb: density of flog scores is more than it was before: 1.000 VS 18.103" "$warning"
}

test_flay_message(){
    local code="arr.each{|subarr| subarr.each{ puts e**2 }}"
    local warning
    echo "$code" > ./duplications.rb
    echo "$code" >> ./duplications.rb

    git add ./duplications.rb
    warning=$(git commit -m "duplications" 2>&1 1>/dev/null)
    assertTrue "echo '${warning}' | grep 'IDENTICAL code found'"
}

test_reek_message(){
    local code="class User; end"
    local warning
    echo "$code" > ./user.rb
    git add ./user.rb
    warning=$(git commit -m "Created user" 2>&1 1>/dev/null)
    assertEquals "user.rb:1 User has no descriptive comment (IrresponsibleModule)" "$warning"
}

. ./shunit2
