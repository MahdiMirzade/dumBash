#!/usr/bin/env bash

# vim: foldmethod=marker

# Configuration
COLORIZE="true"
ASK_REPLACE="true"

# Persian Letters Array
PERSIAN_LETTERS=(
    'ش' 'ذ' 'ز' 'ی' 'ث' 'ب' 'ل' 'ا' 'ه' 'ت' 'ن' 'م' 'پ' 'د' 'خ' 'ح' 'ض' 'ق' 'س' 'ف' 'ع' 'ر' 'ص' 'ط' 'غ' 'ظ'
    'ؤ' '\' 'ژ' 'ي' 'ٍ' 'إ' 'أ' 'آ' 'ّ' 'ة' '»' '«' 'ء' 'ٔ' ']' '[' 'ْ' 'ً' 'ئ' 'ُ' 'َ' 'ٰ' 'ٌ' 'ٓ' 'ِ\' 'ك'
    '‍' '۱' '۲' '۳' '۴' '۵' '۶' '۷' '۸' '۹' '۰'
    '÷' '\!' '٬' '٫' '﷼' '٪' '×' '،'
    'ج' 'چ' 'ک' 'گ' 'و' '؛'
)

# English Letters Array
ENGLISH_LETTERS=(
    'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 'u' 'v' 'w' 'x' 'y' 'z'
    'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z'
    '`' '1' '2' '3' '4' '5' '6' '7' '8' '9' '0'
    '~' '\!' '@' '\#' '\$' '\%' '\^' '\&'
    '[' ']' ';' "'" ',' '"'
)

# Return texts in a new way
function logger () {

    # Colors
    WHITE="\e[0;97m"
    BLUE="\e[0;94m"
    YELLOW="\e[0;93m"
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
    if [[ $BASH ]]; then
        echo $ADDON "${!COLOR}$INPUT${RESET}"
    elif [[ $ZSH_NAME ]]; then
        echo $ADDON "${(P)COLOR}$INPUT${RESET}"
    fi
}

# Handle command not found
function command_not_found_handler () {

    # Copy `input` to `new` variable
    NEW=$*

    # Replace $PersianLetters with $EnglishLetters
    ARRLEN=${#PERSIAN_LETTERS[@]}
    for ((i = 0 ; i < $ARRLEN ; i++)); do
        LETTER_FA="${PERSIAN_LETTERS[$i]}"
        LETTER_EN=${ENGLISH_LETTERS[$i]}
        NEW=${NEW//["$LETTER_FA"]/$LETTER_EN}
    done

    # Check the difference between old and new input
    DIFF_CHECK=$(diff <(printf "%s" "$*" ) <(printf "%s" "$NEW"))
    # DIFF_CHECK=$(printf "%s %s" "$*" "$NEW" | diff)

    # Check if there was any replaces in string
    if [[ -z $DIFF_CHECK ]]; then
        logger "RED" "bash: $*: command not found"
	return 1
    else
        # Check if we need to ask to replace command
        if [[ $ASK_REPLACE == "true" ]]; then
            # logger "red" "bash: $*: command not found, " "nobreak"
            logger "BLUE" "Did you mean ${NEW}? [y/N] " "nobreak"
            read ASK
	    case "${ASK}" in
		    [Yy][Ee][Ss]|Y|y|[غِ][ثٍ][سئ]|[غِ][سئ]|ص|ب|د|صحیح|بله|درست|یس|غ|ِ)
			    logger "GREEN" "Running: " "nobreak"
			    logger "" "${NEW}"
			    if [ "${NEW}" == "exit" ]; then
				    TEMP_VAR="$(ps -p $(ps -p $$ -o ppid=))"
				    TEMP_VAR="$(printf "%s" "${TEMP_VAR}" | awk 'NR==2 {print $1}')"
				    kill -s TERM "${TEMP_VAR}"
			    fi
			    eval $NEW
			    if [ "$?" -ne 0 ];then
				    return 1
			    fi
			    ;;

		    '')
        		    logger "GREEN" "Running: " "nobreak"
        		    logger "" "${NEW}"
        		    if [ "${NEW}" == "exit" ]; then
                		    TEMP_VAR="$(ps -p $(ps -p $$ -o ppid=))"
                		    TEMP_VAR="$(printf "%s" "${TEMP_VAR}" | awk 'NR==2 {print $1}')"
                		    kill -s TERM "${TEMP_VAR}"
        		    fi
        		    eval $NEW
        		    if [ "$?" -ne 0 ]; then
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
            logger "YELLOW" "$* -> $NEW"
            logger "GREEN" "Running: " "nobreak"
            logger "" "${NEW}..."
            eval $NEW
	    exit 1
        fi
    fi
}

# Handle command not found - bash function
function command_not_found_handle () {
    command_not_found_handler $*
}
