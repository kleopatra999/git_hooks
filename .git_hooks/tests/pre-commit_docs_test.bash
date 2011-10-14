#!/usr/bin/env bash

TEST_DIR=$(cd ${0%/*} && pwd)
GIT_HOOKS_DIR=$( cd $TEST_DIR/.. && pwd)
REPO_DIR="/tmp/git_hooks_test"


# create test git repo
rm $REPO_DIR -rf
mkdir -p $REPO_DIR
cd $REPO_DIR && git init > /dev/null

# install git_hooks_framework
cp $GIT_HOOKS_DIR $REPO_DIR -R
cd $REPO_DIR/.git_hooks && \
./bin/setup pre-commit pre-commit_docs > /dev/null




documented_code="
  # class A description\n
  class A\n
    # method doc\n
    def meth; end\n
\n
    # method doc\n
    def meth2; end\n
  end\n
"

undocumented_code="
  class A\n
    def meth; end\n
    def meth2; end\n
  end\n
"


cd $REPO_DIR
git add -A
git ci -m 'initial' &> /dev/null

setUp(){
    cd $REPO_DIR
}


test_decline_documentation(){
    mkdir lib
    echo -e $documented_code > ./lib/a.rb
    git add ./lib/a.rb
    git commit -m 'documented commit' > /dev/null

    echo -e $undocumented_code > ./lib/a.rb
    git add ./lib/a.rb
    output=$(git ci -m 'undocumented commit'  2>&1) #> /dev/null
    assertTrue "echo '${output}' | grep 'You removed documentation for 1 classes'"
    assertTrue "echo '${output}' | grep 'You removed documentation for 2 methods'"
    assertTrue "echo '${output}' | grep 'You decline documentation'"
}


# run tests using shunit
cd $TEST_DIR
. ./shunit2

rm $REPO_DIR -rf
