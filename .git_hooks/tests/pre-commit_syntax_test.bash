#!/usr/bin/env bash

INSTALL_HOOKS="pre-commit pre-commit_syntax"
. test_helper

valid_ruby_code="def meth(); end"
invalid_ruby_code="def meth))(); end"

test_installation(){
    assertTrue "[ -h ./.git/hooks ]"
    assertEquals "../.git_hooks"  "$(readlink ./.git/hooks)"
    assertTrue "[ -d  ./.old_git_hooks ]"
}

test_commit_valid_syntax(){
    echo $valid_ruby_code > ./file_1.rb
    git add ./file_1.rb
    git ci -m 'valid syntax' > /dev/null
    assertEquals "valid syntax" "$(git log --format=%s -n 1)"
}


test_try_commit_invalid_syntax(){
    echo $invalid_ruby_code > ./file_2.rb
    git add ./file_2.rb
    git ci -m 'invalid syntax' &> /dev/null
    # no new commit appeared
    assertEquals "valid syntax" "$(git log --format=%s -n 1)"
    git reset HEAD ./file_2.rb
    rm ./file_2.rb
}

test_commit_invalid_syntax_which_ignored(){
    echo '$invalid_ruby_code' > ./ignore_my_syntax.rb
    git add ./ignore_my_syntax.rb
    git ci -m 'invalid syntax ignored' > /dev/null
    assertEquals "invalid syntax ignored" "$(git log --format=%s -n 1)"
}

. ./shunit2
