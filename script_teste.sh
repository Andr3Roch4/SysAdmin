#!/bin/bash

help () {
    cat <<EOM
    Usage: $0 [Options1] param1 [Options2] param2
    Options1: Mandatory
    -b              Backup file/directory
    -r              Restore file/directory
    -l              List all backups
    -h or -help     Open this information\n
    
    param1: PATH to File/Directory

    Options2: Backup Scheduling
    -h          0-23 Hour every day
    -s          seg,ter,qua,qui,sex,sab,dom every week
    -d          1-31 day every month
    -m          1-12 month every year

    param2: Input for scheduling
EOM
    exit 0
}

help