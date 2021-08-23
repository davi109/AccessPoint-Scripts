export PATH=/bin:/sbin:/usr/bin:/usr/sbin;

logger 'Adicionando a lista negra'

uci add_list wireless.@wifi-iface[0].maclist="$1"
uci commit wireless
