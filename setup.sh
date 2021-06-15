#!/usr/bin/env bash

if [ -n "$1" ];then
	WORKING_DIR="$1"
else WORKING_DIR="."
fi

CHECK_GIT=$(git -C "${WORKING_DIR}" remote -v 2>&- | \
	grep -E "Dark-Rail/dumBash.git|MahdyMirzade/dumBash.git")
if [ -n "${CHECK_GIT}" ];then
	printf "%s\n" "source ~/dumBash/dumBash.sh" >> ~/.bashrc
fi

unset CHECK_GIT WORKING_DIR
