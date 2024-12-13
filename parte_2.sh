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
if [ ! $1 ]
then
    echo "Try to run the script with -h argument for more information."
    exit 1
fi

# Só precisamos de fazer backup de dir?
# Verificação se user tem permissão para realizar o backup
if $2
then
    if [ -d $2 ] && ls $2 &>/dev/null
    then 
        continue
    else
        echo "You dont have permissions to perform this backup. Run script as root user."
        exit 1
    fi
fi

# Diretório e logs de backup
if [ ! -f /mnt/backups/logs.txt ]
then
    if [ ! -d /mnt/backups ]
    then
        mkdir /mnt/backups
    fi
    touch /mnt/backups/logs.txt
    # date +%d/%m/%y
fi

# Destino dos backups
dest_path="/mnt/backups"

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
            # Backup com schedule
            case $3 in
                h)
                ;;
                s)
                ;;
                d)
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
                m)
                ;;
            esac
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