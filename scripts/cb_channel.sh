#!/bin/bash
export PATH=/bin:/sbin:/usr/bin:/usr/sbin;

verificacao=$(cat /usr/share/controller/scripts/channel_mode)

caminho=/usr/share/controller/scripts

sleep $(($RANDOM%5))

if [ $verificacao = "auto" ]; then

	#Cria 3 arquivos, um com todos os canais proximos utilizados, outro com as potencias, e um arquivo better_channel com o melhor canal

	channel11=0
	channel6=0
	channel1=0
	contador1=0
	contador2=0

	logger "Iniciando procedimento de selecao automatica de canais"

	re="\bChannel*"
	echo -n > /tmp/list_channel
	echo -n > /tmp/list_power

	$caminho/scan.sh

	cat /tmp/scan-result.txt | grep -e Channel: -e Signal:| while read LINE
	do
		TEST=$(echo $LINE | awk '{ print $3 }')
		if [[ "$TEST" =~ $re ]] 
		then
			comando=$(echo $LINE | awk '{print $4}')
			echo $comando >> /tmp/list_channel
		else
			comando=$(echo $LINE | awk '{print $2}')
			echo $comando >> /tmp/list_power
			
		fi

	done

	while read line 
	do
		channel[$contador1]=$line
		contador1=$(($contador1+1)) 
	done < /tmp/list_channel

	while read line 
	do
		pot[$contador2]=$(bc <<< "$line+100")
		contador2=$(($contador2+1)) 
	done < /tmp/list_power

	tam_vetor=${#channel[@]}

	for ((i=0; i<$tam_vetor; i++))
	do
		if [ ${channel[$i]} -eq 1 ]
		then
			channel1=$(bc <<< "$channel1+${pot[$i]}")
		elif [ ${channel[$i]} -eq 2 ]
		then
			channel1=$(bc <<< "$channel1+(0.75*${pot[$i]})")
		elif [ ${channel[$i]} -eq 3 ]
		then
			channel1=$(bc <<< "$channel1+(0.5*${pot[$i]})")
			channel6=$(bc <<< "$channel6+(0.25*${pot[$i]})")
		elif [ ${channel[$i]} -eq 4 ]
		then
			channel1=$(bc <<< "$channel1+(0.25*${pot[$i]})")
			channel6=$(bc <<< "$channel6+(0.5*${pot[$i]})")
		elif [ ${channel[$i]} -eq 5 ]
		then
			channel6=$(bc <<< "$channel6+(0.75*${pot[$i]})")
		elif [ ${channel[$i]} -eq 6 ]
		then
			channel6=$(bc <<< "$channel6+${pot[$i]}")
		elif [ ${channel[$i]} -eq 7 ]
		then
			channel6=$(bc <<< "$channel6+(0.75*${pot[$i]})")
		elif [ ${channel[$i]} -eq 8 ]
		then
			channel6=$(bc <<< "$channel6+(0.5*${pot[$i]})")
			channel11=$(bc <<< "$channel11+(0.25*${pot[$i]})")
		elif [ ${channel[$i]} -eq 9 ]
		then
			channel6=$(bc <<< "$channel6+(0.25*${pot[$i]})")
			channel11=$(bc <<< "$channel11+0.5*${pot[$i]}") 
		elif [ ${channel[$i]} -eq 10 ]
		then
			channel11=$(bc <<< "$channel11+(0.75*${pot[$i]})")
		elif [ ${channel[$i]} -eq 11 ]
		then	
			channel11=$(bc <<< "$channel11+${pot[$i]}")
		fi

	done

	menor=10000

	R=$(echo "$menor > $channel6" | bc)

	if [ $R = 1 ]
		then 
		menor=$channel6
		a=6
	fi

	R=$(echo "$menor > $channel11" | bc)

	if [ $R = 1 ]
		then
		menor=$channel11
		a=11
	fi

	R=$(echo "$menor > $channel1" | bc)	

	if [ $R = 1 ] 
		then
		menor=$channel1
		a=1
	fi	

	echo $a > /tmp/better_channel

	canal=$(uci get wireless.radio0.channel)
	melhor=$(cat /tmp/better_channel)
	logger "Current channel $canal"

	if [ $((canal)) -ne $((melhor)) ]
		then
		if [ -z $1 ]
		then 
			$caminho/change_channel.sh $melhor
		else
			$caminho/change_channel.sh $melhor 1
		fi
		
		logger "Channel switched to $melhor" 
	fi

	echo "Channel 11: $channel11"
	echo "Channel 6: $channel6"
	echo "Channel 1: $channel1"
fi
