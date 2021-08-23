export PATH=/bin:/sbin:/usr/bin:/usr/sbin;

logger 'Excluindo da lista negra'

uci del_list wireless.@wifi-iface[0].maclist="$1"
uci commit wireless
