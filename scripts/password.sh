export PATH=/bin:/sbin:/usr/bin:/usr/sbin;

logger 'Alterando metodo de autenticacao do ponto de acesso'

if [ $1 -eq 0 ]
then 
	#Modo padrão
	uci set wireless.@wifi-iface[0].encryption='psk2+tkip+aes'
	uci set wireless.@wifi-iface[0].key="$2"
	uci commit wireless
else
	#Modo wpa2
	uci set wireless.@wifi-iface[0].server="$3"
	uci set wireless.@wifi-iface[0].encryption='wpa2'
	uci set wireless.@wifi-iface[0].key="$2"
	uci commit wireless
fi	
