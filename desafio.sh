#!/bin/bash

# Criado por: André Rocha 12/2024
# Este script recebe um argumento 
# com o path para o ficheiro dos utilizadores
# e uma flag opcional(-v)

# Script deve ser corrido como root
if [ "$(id -u)" -ne 0 ]
then
    exit 1
fi

# Atribuição de argumentos
if [ $# -gt 1 ]
then
    csv=$2
    v_flag=$1
else
    csv=$1
fi

declare -i line=1
while IFS=",", read user adm pw file
do
    # Ignorar a primeira linha
    if [ $user == "usernames" ]
    then 
        continue
    fi
    # registar user (verificar se ja existe e se username ja usado)
    first_name=${user%_*}
    last_name=${user##*_}
    username=${first_name:0:1}${last_name:0:7}
    if id "$username" &>/dev/null 
    then
        echo "User $username already exists."
    else
        useradd -m $username
        users+=$username
    fi

    # Atribuir admin
    if [ $adm == "yes" ]
    then
        usermod -aG sudo $username
    fi

    # Set pw expiration
    chage -M $pw $username
    
    # ficheiro sysAdmin.txt com mudança de dono
    if [ $file == "yes" ]
    then
        touch /home/$username/sysAdmin.txt
        chown $username:$username /home/$username/sysAdmin.txt
    fi
    # if -v fazer echos no loop
    if [[ $v_flag == "-v" ]]
    then
        echo "$user user has been created with $username username. Line $line done."
        line=$((line + 1))
    fi
done < $csv
echo "All users have been correctly set up."