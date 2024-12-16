#!/bin/bash

q=caminho_26_3_20_backup.tar.zip
while IFS=, read col1 col2
do
    if [ $col1 == $q ]
    then
        rec_folder=$col2
    fi
done < /home/rocha/SysAdmin/teste.csv

echo $rec_folder