#!/usr/bin/env bash

USE_HOOKS="flog"
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

. ./shunit2
