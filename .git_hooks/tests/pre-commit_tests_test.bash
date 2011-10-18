#!/usr/bin/env bash

USE_HOOKS="tests"
. test_helper

test_tests(){
   local test_code="
        require 'rubygems'
        require 'rails'
        require 'rails/test_help'

        class HookTest < ActiveSupport::TestCase

          test 'it_is_true' do
            assert true, 'true is not true'
          end

          test 'it_is_false' do
            assert false, 'false is false'
          end
        end"


    mkdir -p ./test
    echo "$test_code" > ./test/user_test.rb
    git add ./test/user_test.rb
    local warning=$(git commit -m "first test" 2>&1 1>/dev/null)
    assertEquals 'Failed test: test_it_is_false(HookTest)' "$warning"

    local last_msg=$(git log --format='%s' -n 1)
    assertEquals "first test" "$last_msg"
}

. ./shunit2
