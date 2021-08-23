export PATH=/bin:/sbin:/usr/bin:/usr/sbin;

logger 'Coletando lista de Macs da blacklist'

uci get wireless.@wifi-iface[0].maclist | sed 's/ /\n/g' > /tmp/blacklist.txt
