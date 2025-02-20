#!/bin/bash

# Criado por: André Rocha 12/2024
# Este script recebe dois argumentos
# um com a lista de utilizadores a adicionar ao sistema
# e outro com a lista de pacotes a instalar
# Este script deve ser corrido com permiçoes root

if [ "$(id -u)" -ne 0 ]
then
    exit 1
fi

# Parte 1 - Instalação de pacotes

if python3 -V
then
    echo "Python already installed"
else
    apt install python3 -y &>/dev/null
    echo "Python has been installed"
fi

for pacote in python3-numpy python3-pandas ansible net-tools
do
    
    apt install $pacote -y &>/dev/null
    echo "$pacote has been installed!"
done

apt list | grep -E "numpy|pandas|ansible|net-tools"


# Parte 2 - Adicionar utilizadores

touch ~/utilizadores.txt
var $users
for utilizador in ...
do
    if id "$utilizador" &>/dev/null 
    then
        echo "User $utilizador already exists."
    else
        useradd -m "$utilizador"
        chage -d 0 "$utilizador"
        echo "$utilizador" > ~/utilizadores.txt
        mkdir /home/"$utilizador"/SistemasOperativos
        users="$users $utilizadores"
    fi
done

for utilizador in ...
do
    cp ~/utilizadores.txt /home/"$utilizador"/SistemasOperativos 
done

usermod -aG sudo,adm lalmeida

chown bsantos:bsantos /home/bsantos/SistemasOperativos/utilizadores.txt
chmod 600 /home/bsantos/SistemasOperativos/utilizadores.txt

chmod u+rwx /home/gcosta/SistemasOperativos

cat /etc/passwd

userdel -r lalmeida

usermod -c "55119" bsantos
usermod -c "53912" gcosta

for user in bsantos gcosta
do    
    chage -M 365 $user
    chage -W 7 $user
done

getent group sudo