#!/usr/bin/env bash

TEST_DIR=$(cd ${0%/*} && pwd)
GIT_HOOKS_DIR=$( cd $TEST_DIR/.. && pwd)
REPO_DIR="/tmp/git_hooks_test"

valid_ruby_code="def meth(); end"
invalid_ruby_code="def meth))(); end"

# create test git repo
rm $REPO_DIR -rf
mkdir -p $REPO_DIR
cd $REPO_DIR && git init > /dev/null

# install git_hooks_framework
cp $GIT_HOOKS_DIR $REPO_DIR -R
cd $REPO_DIR/.git_hooks && ./bin/setup > /dev/null

# remove commit message hook
# TODO: modify setup script to install only specified hooks
rm $REPO_DIR/.git_hooks/commit-msg


setUp(){
    cd $REPO_DIR
}


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




# run tests using shunit
cd $TEST_DIR
. ./shunit2


rm $REPO_DIR -rf
