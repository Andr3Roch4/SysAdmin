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
    -h          Input hour (0 - 23)
    -d          Input day of month (1 - 31)
    -m          Input month (1 - 12)
    -s          Input day of week (0 - 6) (Sunday=0 or 7)

    param2: Input for scheduling
EOM
    exit 0
}

# Indicação que script precisa de pelo menos 1 argumento ou no máximo 4 para correr
if [ $# -lt 1 ] || [ $# -gt 4 ]
then
    echo "Try $0 -h for more information."
    exit 1
fi

# Só precisamos de fazer backup de dir?

# Diretório e logs para guardar backups
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


# Lógica dependendo do primeiro argumento
case $1 in
    # Realizar backup
    -b) 
        # Verificação se existe caminho para pasta e se user tem permissão para realizar o backup
        if [ -n $2 ] && [ -d $2 ]
        then
            if ls $2 &>/dev/null
            then
                continue
            else
                echo "You dont have permissions to perform this backup. Run script as owner of directory."
                exit 1
            fi
        else
            echo "Must specify valid target path of backup. Try -h for more information."
            exit 1
        fi
        # Se existir o 3º argumento agendar o backup
        if [ -n $3 ]
        then
            # Backup com schedule
            cron_command="$0 -b $2"
            case $3 in
                -h)
                    # Backup a hora/s referida
                    # Se referidas mais que uma hora
                    if echo $4 | grep , &>/dev/null
                    then
                        IFS=","
                        for i in $4
                        do
                            if echo {0..23} | grep $i &>/dev/null
                            then
                                continue
                            else
                                echo "Must provide an hour range of 0 to 23."
                                exit 1
                            fi
                        done
                        # Cronjob a ser introduzido na crontab
                        cron="0 $4 * * * $cron_command"
                    # Se for intervalo de horas
                    elif echo $4 | grep - &>/dev/null
                    then
                        IFS="-"
                        for i in $4
                        do
                            if echo {0..23} | grep $i &>/dev/null
                            then
                                continue
                            else
                                echo "Must provide an hour range of 0 to 23."
                                exit 1
                            fi
                        done
                        # Cronjob a ser introduzido na crontab
                        cron="0 $4 * * * $cron_command"
                    # Se for apenas uma hora referida
                    elif echo {0..23} | grep $4 &>/dev/null
                    then
                        # Cronjob a ser introduzido na crontab
                        cron="0 $4 * * * $cron_command"
                    else
                        echo "Must provide an hour range of 0 to 23."
                        exit 1
                    fi
                ;;
                -d)
                    # Backup a dia/s do mês
                    # Se referidos mais que um dia
                    if echo $4 | grep , &>/dev/null
                    then
                        IFS=","
                        for i in $4
                        do
                            if echo {1..31} | grep $i &>/dev/null
                            then
                                continue
                            else
                                echo "Must provide a day range of 1 to 31."
                                exit 1
                            fi
                        done
                        # Cronjob a ser introduzido na crontab
                        cron="0 0 $4 * * $cron_command"
                    # Intervalo de dias
                    elif echo $4 | grep - &>/dev/null
                    then
                        IFS="-"
                        for i in $4
                        do
                            if echo {1..31} | grep $i &>/dev/null
                            then
                                continue
                            else
                                echo "Must provide a day range of 1 to 31."
                                exit 1
                            fi
                        done
                        # Cronjob a ser introduzido na crontab
                        cron="0 0 $4 * * $cron_command"
                    # Apenas 1 dia referido
                    elif echo {1..31} | grep $4 &>/dev/null
                    then
                        # Cronjob a ser introduzido na crontab
                        cron="0 0 $4 * * $cron_command"
                    else
                        echo "Must provide a day range of 1 to 31."
                        exit 1
                    fi
                ;;
                -m)
                    # Backup a mês
                    # Se referidos mais que um mês
                    if echo $4 | grep , &>/dev/null
                    then
                        IFS=","
                        for i in $4
                        do
                            if echo {1..12} | grep $i &>/dev/null
                            then
                                continue
                            else
                                echo "Must provide a month range of 1 to 12."
                                exit 1
                            fi
                        done
                        # Cronjob a ser introduzido na crontab
                        cron="0 0 1 $4 * $cron_command"
                    # Intervalode meses
                    elif echo $4 | grep - &>/dev/null
                    then
                        IFS="-"
                        for i in $4
                        do
                            if echo {1..12} | grep $i &>/dev/null
                            then
                                continue
                            else
                                echo "Must provide a month range of 1 to 12."
                                exit 1
                            fi
                        done
                        # Cronjob a ser introduzido na crontab
                        cron="0 0 1 $4 * $cron_command"
                    # Apenas 1 mês referido
                    elif echo {1..12} | grep $4 &>/dev/null
                    then
                        # Cronjob a ser introduzido na crontab
                        cron="0 0 1 $4 * $cron_command"
                    else
                        echo "Must provide a month range of 1 to 12."
                        exit 1
                    fi
                ;;
                -s)
                    # Backup a dia/s da semana
                    # Se referidos mais que um dia da semana
                    if echo $4 | grep , &>/dev/null
                    then
                        IFS=","
                        for i in $4
                        do
                            if echo {0..6} | grep $i &>/dev/null
                            then
                                continue
                            else
                                echo "Must provide a week day in the range of 0(sunday) to 6(saturday)."
                                exit 1
                            fi
                        done
                        # Cronjob a ser introduzido na crontab
                        cron="0 0 * * $4 $cron_command"
                    # Intervalo de dias da semana
                    elif echo $4 | grep - &>/dev/null
                    then
                        IFS="-"
                        for i in $4
                        do
                            if echo {0..6} | grep $i &>/dev/null
                            then
                                continue
                            else
                                echo "Must provide a week day in the range of 0(sunday) to 6(saturday)."
                                exit 1
                            fi
                        done
                        # Cronjob a ser introduzido na crontab
                        cron="0 0 * * $4 $cron_command"
                    # Apenas 1 dia da semana
                    elif echo {0..6} | grep $4 &>/dev/null
                    then
                        # Cronjob a ser introduzido na crontab
                        cron="0 0 * * $4 $cron_command"
                    else
                        echo "Must provide a week day in the range of 0(sunday) to 6(saturday)."
                        exit 1
                    fi
                ;;
                *) 
                    # Se 3º argumento for inválido
                    echo -e "Invalid schedule command option.\nTry $0 -h for more information."
                    exit 1
                ;;
            esac
            # Introdução do cronjob no crontab
            (crontab -l ; echo "$cron") | crontab -
            echo "Cronjob has been set. The following line has been used: $cron."
        # Se não existir 3º argumento realizar backup
        else
            # Utilizar apenas a data e o nome da pasta no nome do ficheiro de backup
            date=$(date +%d_%m_%y)
            dir_name=${$2##*/}
            # Backup file path
            backup_file=$dest_path"/"$date"_"$dir_name"_backup.tar.gz"
            # Backup no momento
            tar -czvf $backup_file $2
            echo "Backup of $2 into $backup_file complete."
            echo "$backup_file,$2" >> $logs_path
            echo "Log file updated."
        fi
    ;;
    # Realizar restauro
    -r) 
        # Verificação se existe caminho para ficheiro de restauro
        if [ -n $2 ] && [ -f $2 ]
        then
            while IFS=",", read col1 col2
            do
                if [ $col1 == $2 ]
                then
                    rec_folder=$col2
                else
                    continue
                fi
            done < $logs_path
            # Se ficheiro for encontrado nos logs realizar restauro do diretorio
            if $rec_folder
            then
                tar -xzvf $2 $rec_folder
                echo "$rec_folder has been restored."
            else
                echo "Couldn't find backup file in logs."
            fi
        else
            echo "Must specify valid target path for restore file. Try -h for more information."
            exit 1
        fi
    ;;
    # Lista de backups realizados pelo user
    -l) 
        # Listar a partir do ficheiro de logs do user
        while IFS=",", read col1 col2
        do
            echo "File             Directory"
            echo "$col1            $col2"
        done < $logs_path
    ;;
    -h|-help)
        help
    ;;
    *) 
        echo -e "Invalid command option.\nTry $0 -h for more information."
        exit 1
    ;;
esac