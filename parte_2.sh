#!/bin/bash

# Criado por: André Rocha 18/12/2024
# Este script automatiza a realização de backups e restauros
# Permite agendar ou executar backups 
# Recebe pelo menos 2 argumentos para operações de backup e restauro
# Pode receber apenas 1 argumento para as flags de help(-h) e list(-l)


# Função para help
help () {
    cat <<EOM
    Usage: $0 [Options1] param1 [Options2] param2
    Options1:
    -b              Schedule a backup with a cronjob
    -e              Execute a backup 
    -r              Restore a backup
    -l              List all backups
    -h              Open this information
    
    param1: PATH to Directory/File

    Options2: Backup Scheduling
    -M          Input minutes (0 - 59)
    -H          Input hour (0 - 23)
    -d          Input day of month (1 - 31)
    -m          Input month (1 - 12)
    -s          Input day of week (0 - 6) (Sunday=0)

    param2: Input for scheduling

    Examples:
    $0 -b /home/andre/Sysadmin -m 1,7
    $0 -e /home/andre/Sysadmin
    $0 -r /home/andre/backups/17_12_2024_Sysadmin_backup.tar.gz
EOM
    exit 0
}

# Função para verificação backup
backup_verification () {
    if [ -n "$1" ] && ( [ -d "$1" ] || [ -f "$1" ] ) && [ -r "$1" ]
    then
        return 0
    else
        return 1
    fi
}

# Função para verificação do schedule de backup
backup_schedule_verification () {
    if echo $2 | grep -E ",|-" &>/dev/null
    then
        IFS=",-"
        for i in $2
        do
            if eval echo $1 | grep $i &>/dev/null
            then
                continue
            else
                return 1
            fi
        done
        return 0
    elif eval echo $1 | grep $2 &>/dev/null
    then
        return 0
    else
        return 1
    fi
}

# Indicação que script precisa de pelo menos 1 argumento ou no máximo 4 para correr
if [ $# -lt 1 ]
then
    help
fi

# Diretório e logs para guardar backups
backup_dir () {
    user=$(whoami)
    # Se for o root a usar o script usar o /var/backups
    if [ "$(id -u)" -eq 0 ]
    then 
        if [ ! -f /var/backups/logs.txt ]
        then
            if [ ! -d /var/backups ]
            then
                mkdir /var/backups
            fi
            # Criação de ficheiro de logs
            touch /var/backups/logs.txt
        fi
        # Destino dos backups
        dest_path="/var/backups"
        logs_path="/var/backups/logs.txt"
    # Se for outro user a correr o script criar uma pasta de backups na home do user
    else
        if [ ! -f /home/$user/backups/logs.txt ]
        then
            if [ ! -d /home/$user/backups ]
            then
                mkdir /home/$user/backups
            fi
            # Criação de ficheiro de logs
            touch /home/$user/backups/logs.txt
        fi
        # Destino dos backups
        dest_path="/home/$user/backups"
        logs_path="/home/$user/backups/logs.txt"
    fi
}

# Default point para o schedule
cron_M="0"
cron_H="0"
cron_d="*"
cron_m="*"
cron_s="*"

# Logica para cada flag
while getopts :b:e:r:lh opt
do
    case $opt in
        b) 
            # Agendar backup
            backup_dir
            # Verificação se existe caminho para pasta e se user tem permissão para realizar o backup
            backup_target=$OPTARG
            # Tratamento da cronologia para o crontab
            while getopts :M:H:d:m:s: opt
            do
                case $opt in
                    s)
                        # Agendar para dia/s da semana
                        range={0..6}
                        if backup_schedule_verification $range $OPTARG
                        then
                            cron_s=$OPTARG
                        else
                            echo -e "Must provide a valid schedule range.\nTry $0 -h for more information."
                            exit 1
                        fi
                    ;;
                    m)
                        # Agendar para mês/es  
                        range={1..12}
                        if backup_schedule_verification $range $OPTARG
                        then
                            cron_m=$OPTARG
                            if [ "$cron_d" == "*" ]
                            then
                                cron_d="1"
                            fi
                        else
                            echo -e "Must provide a valid schedule range.\nTry $0 -h for more information."
                            exit 1
                        fi
                    ;;
                    d)
                        # Agendar para dia/s do mês
                        range={1..31}
                        if backup_schedule_verification $range $OPTARG
                        then
                            cron_d=$OPTARG
                        else
                            echo -e "Must provide a valid schedule range.\nTry $0 -h for more information."
                            exit 1
                        fi
                    ;;
                    H)
                        # Agendar para hora/s
                        range={0..23}
                        if backup_schedule_verification $range $OPTARG
                        then
                            cron_H=$OPTARG
                        else
                            echo -e "Must provide a valid schedule range.\nTry $0 -h for more information."
                            exit 1
                        fi
                    ;;
                    M)
                        # Agendar para minuto/s
                        range={0..59}
                        if backup_schedule_verification $range $OPTARG
                        then
                            cron_M=$OPTARG
                        else
                            echo -e "Must provide a valid schedule range.\nTry $0 -h for more information."
                            exit 1
                        fi
                    ;;
                esac
            done
            if backup_verification $backup_target
            then
                script=$(pwd $0)/$(basename $0)
                cron_command="$script -e $backup_target"
                cron="$cron_M $cron_H $cron_d $cron_m $cron_s"
                # Introdução do cronjob no crontab
                (crontab -l ; echo "$cron $cron_command") | crontab -
                echo "Cronjob has been set. The following line has been used: $cron $cron_command."
                exit 0
            else
                echo "Must specify valid target path of backup. Try -h for more information."
                exit 1
            fi
        ;;
        e)
            # Realizar backup no momento
            backup_dir
            # Verificação se existe caminho para pasta e se user tem permissão para realizar o backup
            backup_target=$OPTARG
            if backup_verification $backup_target
            then
                # Utilizar apenas a data e o nome da pasta, no nome do ficheiro de backup
                date=$(date +%d_%m_%y)
                dir_name=${backup_target##*/}
                # Backup file path
                backup_file=$dest_path"/"$date"_"$dir_name"_backup.tar.gz"
                # Backup no momento
                tar -czvf $backup_file $backup_target
                echo "Backup of $backup_target into $backup_file complete."
                echo "$backup_file,$backup_target" >> $logs_path
                echo "Log file updated."
                exit 0
            else
                echo "Must specify valid target path of backup. Try -h for more information."
                exit 1
            fi
        ;;
        r) 
            # Realizar restauro
            backup_dir
            # Verificação se existe caminho para ficheiro de restauro
            restore_file=$OPTARG
            if [ -n $restore_file ] && [ -f $restore_file ] && [ -r $restore_file ]
            then
                while IFS=",", read col1 col2
                do
                    if [ $col1 == $restore_file ]
                    then
                        restore_target=$col2
                    else
                        continue
                    fi
                done < $logs_path
                # Se ficheiro for encontrado nos logs e tivermos permissões, realizar restauro do diretorio
                if [ -d $restore_target ]
                then
                    rm -rf $restore_target/*
                elif [ -f $restore_target ]
                then
                    rm -rf $restore_target
                else
                    continue
                fi
                tar -xzvf $restore_file -C /
                echo "$restore_target has been restored."
                exit 0
            else
                echo "Couldn't find backup file in logs, or you don't have permissions to restore target folder."
                exit 1
            fi
        ;;
        l) 
            # Lista de backups realizados pelo user
            backup_dir
            # Listar a partir do ficheiro de logs do user
            if [ -s $logs_path ]
            then
                while IFS=",", read col1 col2
                do
                    echo "FILE:$col1    TARGET:$col2"
                done < $logs_path
            else
                echo "No backups done by this user."
            fi
            exit 0
        ;;
        h)
            help
        ;;
        :)
            echo -e "Must provide an argument for some flags.\nTry $0 -h for more information."
            exit 1
        ;;
        *) 
            help
        ;;
    esac
done