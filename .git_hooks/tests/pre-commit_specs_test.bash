#!/usr/bin/env bash

USE_HOOKS="specs"
. test_helper

test_saikuro(){
   local spec_code="
     describe 'Math' do
       it 'one should be two' do
         1.should == 2
       end

       it 'one should be one' do
         1.should == 1
       end
     end "

    mkdir -p ./spec
    echo "$spec_code" > ./spec/user_spec.rb
    git add ./spec/user_spec.rb
    local warning=$(git commit -m "first spec" 2>&1 1>/dev/null)
    assertEquals 'Failed spec: Math one should be two' "$warning"
    assertFalse "echo '${warning}| grep 'one should be one'"
}

. ./shunit2
