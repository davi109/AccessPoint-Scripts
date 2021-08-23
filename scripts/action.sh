#!/bin/bash
export PATH=/bin:/sbin:/usr/bin:/usr/sbin;

. /usr/share/libubox/jshn.sh

caminho=/usr/share/controller/scripts
 
json_init
json_load_file $caminho/result.json


json_get_var teste sucesso

if [[ $teste -eq 1 ]]; then

	json_select "mudancas" > /dev/null                                                   
		                                                                  
	if [[ $? -eq 0 ]] #verifica se existe o objeto mudancas no arquivo json                                                           
	then                                                                      
		if json_is_a include_black array                                            
		then                                                                    
		  json_select include_black                                                         
		  idx=1                                                                   
		  while json_is_a ${idx} string  ## iterate over data inside "lan" object 
		  do                                                                      
		    json_get_var mac $idx
			                                         
		    $caminho/include_blacklist.sh "$mac"
			                                                  
		    idx=$(( idx + 1 ))                                                    
		  done
		  json_select ..                                                                    
		fi

		if json_is_a exclude_black array
		then
		  json_select exclude_black
		  idx=1
		  while json_is_a ${idx} string  ## iterate over data inside "lan" object
		  do
		    json_get_var mac $idx

		    $caminho/exclude_blacklist.sh "$mac"

		    idx=$(( idx + 1 ))
		  done
		  json_select ..
		fi

		json_get_var value_ssid ssid
		if [ -n "$value_ssid" ] #verifica se existe o objeto ssid
		then
			$caminho/change_ssid.sh "$value_ssid"
		fi
		
		json_get_var value_type_password type_password
		if [ -n "$value_type_password" ] #verifica se existe o objeto type_password
		then
			if [ "$value_type_password" = "default" ]
			then
				json_get_var value_password password
				$caminho/password.sh 0 "$value_password"
			else
				json_get_var value_password password
				json_get_var value_wpa2_server wpa2_server
				$caminho/password.sh 1 "$value_password" "$value_wpa2_server"
			fi
		fi
		
		json_get_var value_channel_mode channel_mode
		if [ -n "$value_channel_mode" ]
		then
			if [ "$value_channel_mode" = "auto" ]
			then
				echo "auto" > $caminho/channel_mode
				$caminho/cb_channel.sh 1
			else
				echo "manual" > $caminho/channel_mode
				json_get_var value_channel channel
				if [ -n "$value_channel" ] #verifica se existe o objeto channel
				then
					$caminho/change_channel.sh $value_channel 1
				fi
			fi

		fi

		json_get_var value_reboot reboot
                if [ -n "$value_reboot" ] #verifica se existe o objeto reboot
                then
			echo "dsad"
                        reboot       
                else
			wifi
                fi
			                                                                
	else                                                                      
		echo "Nada a fazer"                                    
	fi 
else
	echo "Json invalido"
fi
