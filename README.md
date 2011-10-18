# Git Hooks

Allows hooks to be tracked as part of a repository by replacing .git/hooks/ with .git\_hooks/. Create local untracked hooks in .git\_hooks/local/, and source run\_local\_hooks in each hook script to run the local hook.

See .git\_hooks/README for more.


# Installation

Copy `.git_hooks` to root directory of your project. 

Run `./git_hooks/bin/setup`.

Configure hooks in `./git_hooks/config.yml` file.

Add `./git_hooks` to your repository and commit.
