#!/bin/bash

# Criado por: André Rocha 18/12/2024
# Este script recebe um argumento 
# com o path para o ficheiro dos utilizadores
# e uma flag opcional(-v)

# Set v_flag
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

# Com o shift do indice do opt o argumento vai ser sempre $1
shift $((OPTIND - 1))

# Verificação se existe caminho
if [ -z $1 ] && [ -f $1 ]
then
    echo "Must provide a path to a file."
    exit 1
fi

# Script deve ser corrido como root
if [ "$(id -u)" -ne 0 ]
then
    echo "Must run as root user."
    exit 1
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
        # Add user
        useradd -m $username
        # Set pw expiration
        chage -M $pw $username
        users+=$username
        # Atribuir admin
        if [ $adm == "yes" ]
        then
            usermod -aG sudo $username
        fi
        # ficheiro sysAdmin.txt com mudança de dono
        if [ $file == "yes" ]
        then
            touch /home/$username/sysAdmin.txt
            chown $username:$username /home/$username/sysAdmin.txt
        fi
    fi

    # if -v fazer echos no loop
    if [ "$v_flag" = true ]
    then
        echo "$user user has been created with $username username. Line $line done."
        line=$((line + 1))
    fi
done < $1
echo "All users have been correctly set up."