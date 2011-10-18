#!/usr/bin/env bash

USE_HOOKS="flay"
. test_helper

test_flay_message(){
   local code="arr.each{|subarr| subarr.each{ puts e**2 }}"
   local warning
   echo "$code" > ./duplications.rb
   echo "$code" >> ./duplications.rb

   git add ./duplications.rb
   warning=$(git commit -m "duplications" 2>&1 1>/dev/null)
   assertTrue "echo '${warning}' | grep 'IDENTICAL code found'"
}

. ./shunit2
