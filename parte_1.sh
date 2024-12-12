#!/bin/bash

# Criado por: André Rocha 12/2024
# Este script automatiza instalação de pacotes,
# criação de contas de utilizador e
# gestão de permissões, em linux

if [ "$(id -u)" -ne 0 ]
then
    exit 1
fi

# Parte 1 - Automatização

apt update
apt upgrade -y

# 1.1 Pedido de software por parte de um docente
if python3 -V
then
    echo "Python already installed"
else
    apt install python3 -y
    echo "Python has been installed"
fi

for pacote in numpy pandas ansible net-tools
do
    if [ "$pacote" == "net-tools" ]
    then
        apt install $pacote -y
    else
        pip3 install $pacote
    fi
    echo "$pacote has been installed!"
done

# 1.1.1 Listar todos os pacotes instalados
apt list | grep -E "numpy|pandas|ansible|net-tools"


# 1.2 Criação de contas de aluno

touch ~/alunos.txt
for aluno in "Lucas Almeida" "Beatriz Santos" "Gabriel Costa"
do
    lista_nome=($aluno)
    primeiro_nome=${lista_nome[0],}
    ultimo_nome=${lista_nome[1],}
    username=${primeiro_nome:0:1}${ultimo_nome:0:7}
    if id "$username" &>/dev/null 
    then
        echo "User $username already exists."
    else
        useradd -m $username
        chage -d 0 $username
        echo $aluno >> ~/alunos.txt
        mkdir /home/$username/SistemasOperativos
        users=$users$username" "
        echo "$username account has been created for $aluno."
    fi
done
echo "All user accounts have been created."

for user in $users
do
    cp ~/alunos.txt /home/$user/SistemasOperativos/
    if [ $user == "lalmeida" ]
    then
        usermod -aG sudo,adm $user
        echo "$user is now an Administrator."
    elif [ $user == "bsantos" ]
    then
        chown $user:$user /home/$user/SistemasOperativos/alunos.txt
        chmod 600 /home/$user/SistemasOperativos/alunos.txt
        echo "Changed Beatriz permissions for her file."
    elif [ $user == "gcosta" ]
    then
        chmod u+rwx /home/$user/SistemasOperativos
        echo "Changed Gabriel permissions for his directory."
    fi    
done

# 1.2.1 Listar todos os utilizadores do sistema
cat /etc/passwd

# 1.3 Alteração de contas de aluno

userdel -r lalmeida
echo "lalmeida user has been removed."

for user in bsantos gcosta
do 
    chage -M 365 $user
    chage -W 7 $user
    echo "Password settings have been set for user $user."
done                                                                                                                                                                                                                                                                                                                                                                       

# 1.4 Verificação de permissões
if getent group sudo | grep bsantos &>/dev/null
then
    deluser bsantos sudo
    echo "A beatriz deixou de ter capacidade para instalar pacotes."
else
    echo "A Beatriz já não tem capacidade de instalar pacotes."
fi