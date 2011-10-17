#!/usr/bin/env bash

USE_HOOKS="docs"
. test_helper

documented_code="
  # class A description\n
  class A\n
    # method doc\n
    def meth; end\n\n
    # method doc\n
    def meth2; end\n
  end\n "

undocumented_code="
  class A\n
    def meth; end\n
    def meth2; end\n
  end\n "

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

. ./shunit2
