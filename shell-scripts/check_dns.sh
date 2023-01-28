#!/bin/bash

#########################################################################
# Este script testa a propagação de um DNS e retorna seu endereço       #
# ele executa durante 5 minutos, caso não resolva, termina com erro.    #
#                                                                       #
# - Para utilizar, executar passando DNS como parametro                 #
#       ./check_dns.sh <DNS>                                            #
# Ex.:  ./check_dns.sh "google.com.br"                                  #
#                                                                       #
#########################################################################

# Valida parametro de DNS
if [ ! $# -eq 1 ]; then
        echo "Execução inválida, verifique no script, um exemplo de execução."
        exit 1
fi

DNS=$1
COUNT=0
TIMEOUT=5

while true ;
do
        # Caso nslookup execute com sucesso, ele retorna 0, logo EXIT_CODE=0
        nslookup $DNS &> /dev/null
        EXIT_CODE=$?
        TIME_EXECUTION=$(($COUNT * $TIMEOUT))

        # Caso resolva o DNS com sucesso, retorna cheio de perfume e encerra loop
        if [ $EXIT_CODE -eq 0 ] ; then
                # Retorna apenas o ip da saída do comando
                ADDRESS=$(nslookup $DNS | sed -n '6p' | cut -d ":" -f 2)
                
                clear
                echo "DNS propagado!"
                echo "$DNS              <--->           $ADDRESS"
                echo ""
                echo "$TIME_EXECUTION segundos de execução."
                echo "##################################################"
                exit 0
        fi

        # Caso passe 5 minutos (300 segundos) encerra o loop com erro
        if [ $COUNT -gt $((300 / $TIMEOUT)) ] ; then
                clear
                echo "Algo de errado não está certo! já se passaram 5 minutos, sua anta!"
                exit 1
        fi

        # Progresso do script
        clear
        echo "Testando propagação de: $DNS"
        echo "Ainda não propagado (timeout de $TIMEOUT segundos, tempo máximo 5 minutos)...."
        echo "Executando há $TIME_EXECUTION segundos."

        # Controle do loop
        sleep $TIMEOUT
        COUNT=$(($COUNT + 1))
done
