#!/usr/bin/env bash

USE_HOOKS="commit-msg"
. test_helper

valid_ruby_code="def meth(); end"
invalid_ruby_code="def meth))(); end"

modify_file(){
    echo "a char\n" >> ./file.txt
    git add ./file.txt
}

test_invalid_commit_messages(){
    local msgs
    local output
    msgs[0]="task 12"
    msgs[1]="Only headline"
    msgs[2]="Task 34; some message"
    msgs[3]="Task 34\nsome message"
    msgs[4]="Something done task 14"

    for((i = 0; i < 5; i++)); do
	modify_file
	echo -e ${msgs[$i]} > /tmp/git_hook_test_commit_msg
	# try to commit and verify error message
	output=$(git commit -F /tmp/git_hook_test_commit_msg 2>&1 | head -n 1)
	assertEquals "Invalid format of commit message." "$output"
        # verify there is no new commits (only initial commit)
	assertEquals "1" "$(git log --oneline 2> /dev/null | wc -l)"
    done
}


test_valid_commit_messages(){
    local msgs

    msgs[0]="headline message\n   \ntask 19"
    msgs[1]="Renamed something\nBug 15"
    msgs[2]="Create new models\nCompleted task 14"
    msgs[3]="Create something\nTask: 123123"
    msgs[4]="Create something\nTask: 123123\ndetails"

    for((i = 0; i < 5; i++)); do
        modify_file
        echo -e ${msgs[$i]} > /tmp/git_hook_test_commit_msg
        git commit -F /tmp/git_hook_test_commit_msg > /dev/null
        # verify number of commits is incremented 
        assertEquals "$[i+2]" "$(git log --oneline 2> /dev/null | wc -l)"
    done
}

. ./shunit2
