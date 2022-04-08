#!/bin/bash

# LINE Notify Token - Media > "Send to".
TOKEN="t5mH0cweopoTHJm6kJxR8VnAsdR40WgorXozWV3XNkT"

NOW=$(date +"%Y%m%d%H%M%S")
# Line Notify notice message.
notice1="
Service status zabbix
$NOW
Status[OK]
"
# Line Notify notice message.
notice2="
Service status zabbix
$NOW
Status[Filed]
"

for i in `ps -ef |grep zabbix |wc -l`
        do  
            #echo "$i"
            if [ $i -gt 1 ]; then
            curl https://notify-api.line.me/api/notify -H "Authorization: Bearer ${TOKEN}" -d "message=${notice1}"
            exit 0
            else
            curl https://notify-api.line.me/api/notify -H "Authorization: Bearer ${TOKEN}" -d "message=${notice2}" 
            fi
            exit 0
        done


        