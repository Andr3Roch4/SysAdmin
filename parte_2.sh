#!/bin/bash

# Criado por: André Rocha 12/2024
# Este script automatiza a realização de backups e restauros
# Recebe 3 argumentos para operações de backup(-b) e restauro(-r)
# Pode receber apenas 1 argumento as flags de help(-h) e list(-l)


# Função para help
help () {
    cat <<EOM
    Usage: $0 [Options1] param1 [Options2] param2
    Options1: Mandatory
    -b              Backup directory
    -r              Restore directory
    -l              List all backups
    -h or -help     Open this information\n
    
    param1: PATH to Directory/File

    Options2: Backup Scheduling
    -h          0-23 Hour every day
    -s          seg,ter,qua,qui,sex,sab,dom every week
    -d          1-31 day every month
    -m          1-12 month every year

    param2: Input for scheduling
EOM
    exit 0
}

# Indicação que script precisa de pelo menos 1 argumento para correr
if [ ! $# ]
then
    echo "Try $0 -h for more information."
    exit 1
fi

# Só precisamos de fazer backup de dir?
# Verificação se user tem permissão para realizar o backup
if $2
then
    if [ -d $2 ]
    then
        if ls $2 &>/dev/null
        then
            continue
        else
            echo "You dont have permissions to perform this backup. Run script as root user."
            exit 1
        fi
    else
        echo "Must provide a valid directory path."
        exit 1
    fi
fi

# Diretório e logs de backup
user=$(whoami)
if [ "$(id -u)" -eq 0 ]
then 
    if [ ! -f /var/backups/logs.txt ]
    then
        if [ ! -d /var/backups ]
        then
            mkdir /var/backups
        fi
        touch /var/backups/logs.txt
    fi
    # Destino dos backups
    dest_path="/var/backups"
    logs_path="/var/backups/logs.txt"
else
    if [ ! -f /home/$user/backups/logs.txt ]
    then
        if [ ! -d /home/$user/backups ]
        then
            mkdir /home/$user/backups
        fi
        touch /home/$user/backups/logs.txt
    fi
    # Destino dos backups
    dest_path="/home/$user/backups"
    logs_path="/home/$user/backups/logs.txt"
fi

    # date +%d/%m/%y

# Lógica dependendo do primeiro argumento
case $1 in
    # Realizar backup. Verificação se existe caminho para pasta ou ficheiro.
    -b) if [ ! $2 ]
        then
            echo "Must specify target path of backup. Try -h for more information."
            exit 1
        fi
        if $3
        then
            if [ "$(id -u)" -ne 0 ]
            then
                echo "Must have root permission to schedule a backup cronjob."
                exit 1
            else
                # Backup com schedule
                case $3 in
                    -h)
                    ;;
                    -s)
                    ;;
                    -d)
                        week=(seg ter qua qui sex sab dom)
                        if cat "$week" | grep "$4"
                        then
                            # crontab
                            # Preciso fazer um script para correr no crontab (e criar logs)?
                        else
                            echo -e "Specify correct day of the week from:\nseg ter qua qui sex sab dom"
                            exit 1
                        fi
                    ;;
                    -m)
                    ;;
                    *) echo -e "Invalid command option.\nTry $0 -h for more information."
                    ;;
                esac
            fi
        else
            # Backup no momento
            
        fi
    ;;
    # Realizar restauro. Verificação se existe caminho para ficheiro de restauro.
    -r) if [ ! $2 ]
        then
            echo "Must specify path of recovery file. Try -h for more information."
            exit 1
        fi
        # Restauro
    ;;
    # Lista de backups realizados
    -l) 
        # Ficheiro de logs? dia de backup,caminho do ficheiro de backup,caminho do diretorio que levou backup
    ;;
    -h|-help)
        help
    ;;
    *) echo -e "Invalid command option.\nTry $0 -h for more information."
    ;;
esac