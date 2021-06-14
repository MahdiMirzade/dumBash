#!/usr/bin/bash

# vim: foldmethod=marker 

#
#   __  __       _         _         __  __ _                   _
#  |  \/  | __ _| |__   __| |_   _  |  \/  (_)_ __ ______ _  __| | ___
#  | |\/| |/ _` | '_ \ / _` | | | | | |\/| | | '__|_  / _` |/ _` |/ _ \
#  | |  | | (_| | | | | (_| | |_| | | |  | | | |   / / (_| | (_| |  __/
#  |_|  |_|\__,_|_| |_|\__,_|\__, | |_|  |_|_|_|  /___\__,_|\__,_|\___|
#                            |___/
#
# This file is a part of `github.com/mahdymirzade/dumBash`.
#

# Configuration {{{
	
COLORIZE="true"
ASK_REPLACE="true"

# }}}

# Persian Letters Array {{{
PERSIAN_LETTERS=(
    'ش' 'ذ' 'ز' 'ی' 'ث' 'ب' 'ل' 'ا' 'ه' 'ت' 'ن' 'م' 'پ' 'د' 'خ' 'ح' 'ض' 'ق' 'س' 'ف' 'ع' 'ر' 'ص' 'ط' 'غ' 'ظ'
    'ؤ' '' 'ژ' 'ي' 'ٍ' 'إ' 'أ' 'آ' 'ّ' 'ة' '»' '«' 'ء' 'ٔ' ']' '[' 'ْ' 'ً' 'ئ' 'ُ' 'َ' 'ٰ' 'ٌ' 'ٓ' 'ِ\' 'ك'
    '‍' '۱' '۲' '۳' '۴' '۵' '۶' '۷' '۸' '۹' '۰'
    '÷' '\!' '٬' '٫' '﷼' '٪' '×' '،'
    'ج' 'چ' 'ک' 'گ' 'و' '؛'
)

# }}}

# English Letters Array{{{
ENGLISH_LETTERS=(
    'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 'u' 'v' 'w' 'x' 'y' 'z'
    'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z'
    '`' '1' '2' '3' '4' '5' '6' '7' '8' '9' '0'
    '~' '\!' '@' '\#' '\$' '\%' '\^' '\&'
    '[' ']' ';' "'" ',' '"'
)

# }}}

# Return texts in a new way {{{
function logger {

    # Colors
    WHITE="\e[0;97m"
    BLUE="\e[0;94m"
    YELlOW="\e[0;93m"
    GREEN="\e[0;92m"
    RED="\e[0;91m"
    RESET="\e[0m"

    # Inputs
    COLOR="$1"
    INPUT="$2"
    PREFX="$3"

    # Set null colors to white
    if [[ -z  $COLOR || $COLORIZE != "true" ]]; then
        COLOR="WHITE"
    fi
    
    # Customizable "No new line"
    if [[ $PREFX == "nobreak" ]]; then
        ADDON="-en"
    else
        ADDON="-e"
    fi

    # Return
    echo $ADDON "${!COLOR}$INPUT${reset}"
}

# }}}

# Handle command not found {{{
function command_not_found_handle {

    # Copy `input` to `new` variable
    NEW=$@

    # Replace $PersianLetters with $EnglishLetters
    for i in "${!PERSIAN_LETTERS[@]}"; do
        LETTER_FA="${PERSIAN_LETTERS[$i]}"
        LETTER_EN=${ENGLISH_LETTERS[$i]}
        NEW=${NEW//["$LETTER_FA"]/$LETTER_EN}
    done

    # Check the difference between old and new input
    DIFF_CHECK=$(diff <(printf "%s" "$@" ) <(printf "%s" "$NEW"))
    # DIFF_CHECK=$(printf "%s %s" "$@" "$NEW" | diff)

    # Check if there was any replaces in string
    if [[ -z $DIFF_CHECK ]]; then
        logger "RED" "bash: $@: command not found"
	return 1
    else
        # Check if we need to ask to replace command
        if [ $ASK_REPLACE == "true" ]; then
            # logger "red" "bash: $@: command not found, " "nobreak"
            logger "BLUE" "Did you mean ${NEW}? [y/N] " "nobreak"
            read s
	    case "${s}" in
		    [Yy][Ee][Ss]|Y|y)
			    logger "GREEN" "Running: " "nobreak"
			    logger "" "${NEW}..."
			    $NEW
			    if [ "$?" != 0 ];then
				    return 1
			    fi
			    ;;
		     [Nn][Oo]|N|n)
			    return 1
			    ;;
		    *)
			    return 1
			    ;;
	    esac
        else
            logger "YELLOW" "$@ -> $NEW"
            logger "RED" "bash: $new: command not found"
	    exit 1
        fi
    fi
}

# }}}

