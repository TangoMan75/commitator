#!/bin/bash

echo #######################
echo # TangoMan Commitator #
echo #######################
echo

## Converting valid date to epoch format (starting from 00:00)
function format-date() {
    if [ -z "$1" ] || [ -z "$(date -d"$1" -I 2>/dev/null)" ] && [ -z "$(date -d@$1 -I 2>/dev/null)" ]; then
        echo ''
    elif [ -n "$(date -d@$1 -I 2>/dev/null)" ]; then
        # date is valid as epoch format but missing @
        date -d"$(date -d@$1 -I)" +%s
    else
        # date is valid converting to epoch format
        date -d"$(date -d$1 -I)" +%s
    fi
}

## Generate fake commits
function generate-commits() {
    # check git directory
    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        echo 'error: not a git repository (or any of the parent directories)'
        return 1
    fi

    # check git user configured
    if [ -z "$(git config --global user.name)" ] && [ -z "$(git config --global user.email)" ]; then
        echo 'error: missing git default account identity'
        return 1
    fi

    local DAY
    local END
    local FILENAME
    local FOLDER
    local COUNT
    local RND
    local RND_TIME
    local START
    local TIME_MACHINE

    START=$(format-date "$1")
    if [ -z "$START" ]; then
        START=$(date -d'last week' +%s)
    fi

    END=$(format-date "$2")
    if [ -z "$END" ]; then
        END=$(date +%s)
    fi

    # check valid parameters
    if [ $START -gt $END ]; then
        echo 'error: Start later than end'
        return 1
    fi

    for TIME_MACHINE in $(seq $START 86400 $END); do
        # get destination date folder, eg: 1970-01-01
        FOLDER=$(date -d@${TIME_MACHINE} -I)
        # get day in english
        DAY=$(LANG=C date -d@${TIME_MACHINE} +%A)
        # no contributions posted on Saturdays and Sundays
        if [ "$DAY" != 'Saturday' ] && [ "$DAY" != 'Sunday' ];then
            # create destination folder
            echo -e "mkdir -p ./fixtures/${FOLDER}\n"
            mkdir -p ./fixtures/${FOLDER}
            # random fake commit quantity
            RND=$(( ($RANDOM % 5) + 1 ))
            for COUNT in $(seq 1 $RND); do
                # $RANDOM returns an integer from 0 to 32767 (signed 16-bit integer)
                RND_TIME=$(( $TIME_MACHINE + (($RANDOM % 24)*3600) + ($RANDOM % 3600) ))
                FILENAME="$(date -d@${RND_TIME} +%Y-%m-%d_%H-%M-%S)_(${COUNT})"
                # create empty file
                echo "touch ./fixtures/${FOLDER}/${FILENAME} --date=@$RND_TIME"
                touch ./fixtures/${FOLDER}/${FILENAME} --date=@$RND_TIME
                # stage and commit new file into git history
                git add ./fixtures/${FOLDER}/${FILENAME}
                echo "git commit --date=\"${RND_TIME}\" -m \"${FILENAME}\""
                git commit --date="${RND_TIME}" -m "${FILENAME}"
                echo -e "\n"
            done
        fi
    done
}

## Generate fake branches
function generate-branches() {
    # check git directory
    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        echo 'error: not a git repository (or any of the parent directories)'
        return 1
    fi

    # check git user configured
    if [ -z "$(git config --global user.name)" ] && [ -z "$(git config --global user.email)" ]; then
        echo 'error: missing git default account identity'
        return 1
    fi

    local QUANTITY=$1
    local BRANCH_NAME
    local I
    local RND

    # Amount reset to default when not positive integer
    if [[ ! "$QUANTITY" =~ ^[0-9]+$ ]]; then
        QUANTITY=1
    fi

    for (( I=1; I<=$QUANTITY; I++ )); do
        RND=$(( (RANDOM % 10) + 1 ))
        BRANCH_NAME="branch_${I}"

        echo "git checkout -b ${BRANCH_NAME}"
        git checkout -b ${BRANCH_NAME}

        generate-commits $START $END

        echo 'git checkout master'
        git checkout master
    done
}

## Prompt user valid start date
read -p "When do you want commits to start from ? ($(date -d'last week' -I)) :" START
START=$(format-date "$START")
if [ -z "$START" ]; then
    START=$(date -d'last week' +%s)
fi

## Prompt user valid stop date
read -p "When do you want commits to stop ? ($(date -I)) :" END
END=$(format-date "$END")
if [ -z "$END" ]; then
    END=$(date +%s)
fi

## Prompt generate branches
read -p 'How many extra branches do you want to generate ? (0) :' BRANCH_COUNT
if [[ ! $BRANCH_COUNT =~ ^[0-9]+$ ]]; then
    BRANCH_COUNT=0
fi

echo "Generating commits from: $(date -d@$START -I) to: $(date -d@$END -I)"

generate-commits $START $END

if [ $BRANCH_COUNT -gt 0 ]; then
    generate-branches $BRANCH_COUNT
fi

