#!/bin/bash

   
username () {
    first_name=${1%_*}
    last_name=${1##*_}
    username=${first_name:0:1}${last_name:0:7}
    echo $username
}

username=$(username $1)

echo "$username"