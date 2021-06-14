#!/usr/bin/bash
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
# Configuration
colorize="true"
askreplace="true"

# Persian Letters Array
PersianLetters=(
    'ش' 'ذ' 'ز' 'ی' 'ث' 'ب' 'ل' 'ا' 'ه' 'ت' 'ن' 'م' 'پ' 'د' 'خ' 'ح' 'ض' 'ق' 'س' 'ف' 'ع' 'ر' 'ص' 'ط' 'غ' 'ظ'
    'ؤ' '' 'ژ' 'ي' 'ٍ' 'إ' 'أ' 'آ' 'ّ' 'ة' '»' '«' 'ء' 'ٔ' ']' '[' 'ْ' 'ً' 'ئ' 'ُ' 'َ' 'ٰ' 'ٌ' 'ٓ' 'ِ\' 'ك'
    '‍' '۱' '۲' '۳' '۴' '۵' '۶' '۷' '۸' '۹' '۰'
    '÷' '\!' '٬' '٫' '﷼' '٪' '×' '،'
)

# English Letters Array
EnglishLetters=(
    'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 'u' 'v' 'w' 'x' 'y' 'z'
    'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z'
    '`' '1' '2' '3' '4' '5' '6' '7' '8' '9' '0'
    '~' '\!' '@' '\#' '\$' '\%' '\^' '\&'
)

# Return texts in a new way
function logger {

    # Colors
    white="\e[0;97m"
    blue="\e[0;94m"
    yellow="\e[0;93m"
    green="\e[0;92m"
    red="\e[0;91m"
    reset="\e[0m"

    # Inputs
    color=$1
    input=$2
    prefx=$3

    # Set null colors to white
    if [[ ! $color || $colorize != "true" ]]; then
        color="white"
    fi
    
    # Customizable "No new line"
    if [[ $prefx == "nobreak" ]]; then
        addon="-en"
    else
        addon="-e"
    fi

    # Return
    echo $addon "${!color}$input${reset}"
}

# Handle command not found
function command_not_found_handle {

    # Copy `input` to `new` variable
    new=$@

    # Replace $PersianLetters with $EnglishLetters
    for i in "${!PersianLetters[@]}"; do
        letterFa="${PersianLetters[$i]}"
        letterEn=${EnglishLetters[$i]}
        new=${new//["$letterFa"]/$letterEn}
    done

    # Check the difference between old and new input
    diff=$(diff <(echo "$@" ) <(echo "$new"))

    # Check if there was any replaces in string
    if [[ ! $diff ]]; then
        logger "red" "bash: $@: command not found"
    else
        # Check if we need to ask to replace command
        if [[ $askreplace == "true" ]]; then
            logger "red" "bash: $@: command not found, " "nobreak"
            logger "blue" "Did you mean $new? [y/N] " "nobreak"
            read
            if [[ $REPLY -eq "y" || $REPLY -eq "Y" || $REPLY -eq "" ]]; then
                logger "green" "Running: " "nobreak"
                logger "" "$new..."
                $new
            fi
        else
            logger "yellow" "$@ -> $new"
            logger "red" "bash: $new: command not found"
        fi
    fi
}
