#!/usr/bin/env bash

# vim: foldmethod=marker

# Linux or BSD?
OS_TYPE=$(uname -o)

# Current working directory
if [[ -n $1 ]]; then
	WORKING_DIR="$1"
else
	WORKING_DIR="${PWD}"
fi
# Colorize
printf "1. %s\n2. %s\n" "Enable Colorize" "Disable Colorize"
read -p ">>> " COLORIZE_YES_NO

# Case statements for Colorize
case "${COLORIZE_YES_NO}" in
    [Ee][Nn][Aa][Bb][Ll][Ee]|1)
	case "${OS_TYPE}" in
	    *[Gg][Nn][Uu]/[Ll][Ii][Nn][Uu][Xx]*)
		sed -i "s,COLORIZE=\"false\",COLORIZE=\"true\", "  ${WORKING_DIR}/dumBash.sh
	    ;;
	    *[Ff][Rr][Ee][Bb][Ss][Dd]*)
		sed -i "" "s,COLORIZE=\"false\",COLORIZE=\"true\", "  ${WORKING_DIR}/dumBash.sh
	    ;;
	esac
    ;;
    [Dd][Ii][Ss][Aa][Bb][Ll][Ee]|2)
	case "${OS_TYPE}" in
	    *[Gg][Nn][Uu]/[Ll][Ii][Nn][Uu][Xx]*)
		sed -i "s,COLORIZE=\"true\",COLORIZE=\"false\", "  ${WORKING_DIR}/dumBash.sh
	    ;;
	    *[Ff][Rr][Ee][Bb][Ss][Dd]*)
		sed -i "" "s,COLORIZE=\"true\",COLORIZE=\"false\", "  ${WORKING_DIR}/dumBash.sh
	    ;;
	esac
    ;;
    *)
	printf "Failed.\n"
	exit 1
    ;;
esac

# Ask Replace
printf "1. %s\n2. %s\n" "Enable Ask Replace" "Disable Ask Replace"
read -p ">>> " ASK_REPLACE_YES_NO

# Case statements for Ask Replace
case "${ASK_REPLACE_YES_NO}" in 
    [Ee][Nn][Aa][Bb][Ll][Ee]|1)
	case "${OS_TYPE}" in
	    *[Gg][Nn][Uu]/[Ll][Ii][Nn][Uu][Xx]*)
		sed -i "s,ASK_REPLACE=\"false\",ASK_REPLACE=\"true\", "  ${WORKING_DIR}/dumBash.sh
		exit 0
	    ;;
	    *[Ff][Rr][Ee][Bb][Ss][Dd]*)
		sed -i "" "s,ASK_REPLACE=\"false\",ASK_REPLACE=\"true\", "  ${WORKING_DIR}/dumBash.sh
		exit 0
	    ;;
	esac
    ;;
    [Dd][Ii][Ss][Aa][Bb][Ll][Ee]|2)
	case "${OS_TYPE}" in
	    *[Gg][Nn][Uu]/[Ll][Ii][Nn][Uu][Xx]*)
		sed -i "s,ASK_REPLACE=\"true\",ASK_REPLACE=\"false\", "  ${WORKING_DIR}/dumBash.sh
		exit 0
	    ;;
	    *[Ff][Rr][Ee][Bb][Ss][Dd]*)
		sed -i "" "s,ASK_REPLACE=\"true\",ASK_REPLACE=\"false\", "  ${WORKING_DIR}/dumBash.sh
		exit 0
	    ;;
        esac
    ;;
    *)
	printf "Failed.\n"
	exit 1
    ;;
esac

unset OS_TYPE  COLORIZE_YES_NO ASK_REPLACE_YES_NO WORKING_DIR
