#!/bin/bash

# Criado por: André Rocha 15/12/2024
# Este script automatiza instalação de pacotes,
# criação de contas de utilizador e
# gestão de permissões, em linux

# Script deve ser corrido como root
if [ "$(id -u)" -ne 0 ]
then
    exit 1
fi


# Parte 1 - Automatização

# Garantir que o apt esta atualizado
apt update
apt upgrade -y


# 1.1 Pedido de software por parte de um docente

# Verificação do Python
if python3 -V
then
    echo "Python already installed"
else
    # Se não estiver instalado, instalar o Python
    apt install python3 -y
    echo "Python has been installed"
fi

# Instalação da lista de pacotes
for pacote in numpy pandas ansible net-tools
do
    # Se for pacote de python instalar pelo pip3
    if [ "$pacote" == "net-tools" ]
    then
        apt install $pacote -y
    else
        pip3 install $pacote
    fi
    echo "$pacote has been installed!"
done


# 1.1.1 Listar todos os pacotes instalados
apt list


# 1.2 Criação de contas de aluno

touch ~/alunos.txt
# Criação da conta de aluno
for aluno in "Lucas Almeida" "Beatriz Santos" "Gabriel Costa"
do
    # Atribuição do username segundo a mesma numenclatura
    lista_nome=($aluno)
    username=${lista_nome[0]:0:1}${lista_nome[1]:0:7}
    username=${username,,}
    # Se username não existir, criar o novo user
    if id "$username" &>/dev/null 
    then
        echo "User $username already exists."
    else
        useradd -m $username
        chage -d 0 $username
        # Adicinar o nome completo do aluno para o ficheiro
        echo $aluno >> ~/alunos.txt
        mkdir /home/$username/SistemasOperativos
        chown $user:$user /home/$username/SistemasOperativos
        # Criação de variavel com o username dos alunos
        users=$users$username" "
        echo "$username account has been created for $aluno."
    fi
done
echo "All user accounts have been created."

# Alterações de permissão
for user in $users
do
    if id "$user" &>/dev/null
    then
        # Copia do ficheiro para pasta de cada aluno
        cp ~/alunos.txt /home/$user/SistemasOperativos/
        chown $user:$user /home/$user/SistemasOperativos/alunos.txt
        # Alterações para o Lucas Almeida
        if [ "$user" == "lalmeida" ]
        then
            usermod -aG sudo,adm $user
            echo "$user is now an Administrator."
        # Alterações para a Beatriz Santos
        elif [ "$user" == "bsantos" ]
        then
            chmod 600 /home/$user/SistemasOperativos/alunos.txt
            echo "Changed Beatriz permissions for her file."
        # Alterações para o Gabriel Costa
        elif [ "$user" == "gcosta" ]
        then
            chmod u+rwx /home/$user/SistemasOperativos
            echo "Changed Gabriel permissions for his directory."
        fi
    else
        echo "$user doesn't exist."    
    fi
done

# Remoção do ficheiro original
rm ~/alunos.txt

# 1.2.1 Listar todos os utilizadores do sistema
cat /etc/passwd

# 1.3 Alteração de contas de aluno

# Remoção conta Lucas Almeida
if id "lalmeida" &>/dev/null
then 
    userdel -r lalmeida
    echo "lalmeida user has been removed."
else
    echo "lalmeida doesn't exist."
fi

# Alteração de atributos da password
for user in bsantos gcosta
do
    if id "$user" &>/dev/null
    then
        chage -M 365 $user
        chage -W 7 $user
        echo "Password settings have been set for user $user."
    else
        echo "$user doesn't exist."
    fi
done                                                                                                                                                                                                                                                                                                                                                                       

# 1.4 Verificação de permissões
# Se Biatriz estiver no group de sudo, remove-la
if getent group sudo | grep bsantos &>/dev/null
then
    deluser bsantos sudo
    echo "Biatriz no longer has permission to install packages."
else
    echo "Beatriz doesn't have permission to install packages."
fi