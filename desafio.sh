#!/bin/bash

# Criado por: André Rocha 12/2024
# Este script recebe um argumento 
# com o path para o ficheiro dos utilizadores
# e uma flag opcional(-v)

while IFS=",", read col1 col2 col3 col4
do
    # registar user (verificar se ja existe e se username ja usado)
    # dar sudo
    # set pw expiration
    # ficheiro sysAdmin.txt com mudança de dono
    # if -v fazer echos no loop
done < input_desafio.csv
echo "All users have been correctly set up."