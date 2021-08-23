export PATH=/bin:/sbin:/usr/bin:/usr/sbin;

logger 'Alterando canal de operacao'

uci set wireless.radio0.channel="$1"

if [ -z $2 ]
then
	echo "das"
	uci commit wireless
	wifi
else
	if [ $2 -eq 1 ]
	then
		uci commit wireless
	else
		echo "Parametro invalido"
	fi
fi
