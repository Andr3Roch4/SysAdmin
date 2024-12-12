#!/bin/bash

for aluno in "Lucas Almeida" "Beatriz Santos" "Gabriel Costa"
do
    lista_nome=($aluno)
    primeiro_nome=${lista_nome[0],}
    ultimo_nome=${lista_nome[1],}
    username=${primeiro_nome:0:1}${ultimo_nome:0:7}
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

echo $users