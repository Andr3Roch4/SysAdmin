#!/bin/bash

   
v_flag=false

# Parse flag opcional
while getopts v opt
do 
    case $opt in
        v)
            v_flag=true
        ;;
        *)
            echo "Usage: $0 [-v] argument"
            exit 1
        ;;
    esac
done
shift $((OPTIND - 1))

if [ $v_flag = true ]
then
    echo $v_flag
else
    echo "No arg"
    exit 1
fi
