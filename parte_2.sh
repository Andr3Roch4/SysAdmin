#!/bin/bash

# Criado por: André Rocha 12/2024
# Este script automatiza a realização de backups e restauros
# Recebe 3 argumentos para operações de backup(-b) e restauro(-r)
# Pode receber apenas 1 argumento as flags de help(-h) e list(-l)

case $1 in
    
    -b) echo "b"

    -r) echo "r"

    -l) echo "l"

    -h) echo "h"