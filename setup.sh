#!/usr/bin/env bash

# Current directory
if [[ -n "$1" ]]; then
    WORKING_DIR="$1"
else
    WORKING_DIR="."
fi

# Check git directory
CHECK_GIT=$(git -C "${WORKING_DIR}" remote -v 2>&- | \
    grep -E "Dark-Rail/dumBash.git|MahdyMirzade/dumBash.git")

# Add dumBash to shells
if [[ -n "${CHECK_GIT}" ]]; then
    printf "%s\n" "source ~/dumBash/dumBash.sh" >> ~/.bashrc
    printf "%s\n" "source ~/dumBash/dumBash.sh" >> ~/.zshrc
fi

# Unset unnecessary variables
unset CHECK_GIT WORKING_DIR
