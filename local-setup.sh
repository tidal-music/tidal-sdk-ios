#!/bin/bash

create_git_hooks() {
    echo "Copying pre-commit hook" >&2
    mkdir -p "./.git/hooks/"
    cp "./bin/git-hooks/pre-commit" "./.git/hooks/pre-commit"
    chmod a+x ".git/hooks/pre-commit"
    echo "Done." >&2
}

configure_git_blame_ignore_revs() {
    if [ -f ".git-blame-ignore-revs" ]; then
        echo "Configuring git blame to ignore revisions listed in .git-blame-ignore-revs" >&2
        git config blame.ignoreRevsFile .git-blame-ignore-revs
        echo "Git blame configuration updated." >&2
    else
        echo ".git-blame-ignore-revs file not found. Skipping git blame configuration." >&2
    fi
}

create_git_hooks
configure_git_blame_ignore_revs
