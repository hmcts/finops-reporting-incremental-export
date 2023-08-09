#!/bin/bash
#  Set date command based on OS

platform=$(uname)
if [[ $platform == "Darwin" ]]; then
    date_command=$(which gdate)
elif [[ $platform == "Linux" ]]; then
    date_command=$(which date)
fi
