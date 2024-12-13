#!/bin/bash

for aluno in "Lucas Almeida" "Beatriz Santos" "Gabriel Costa"
do
    lista_nome=($aluno)
    username=${lista_nome[0]:0:1}${lista_nome[1]:0:7}
    username=${username,,}
    #if id "$username" &>/dev/null 
    #then
        #echo "User $username already exists."
    #else
        #useradd -m $username
        #chage -d 0 $username
        #echo $aluno >> ~/alunos.txt
        #mkdir /home/$username/SistemasOperativos
    users=$users$username" "
done

for user in $users
do
    echo $user
done