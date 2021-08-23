export PATH=/bin:/sbin:/usr/bin:/usr/sbin;

logger 'Alterando ssid'

uci set wireless.@wifi-iface[0].ssid="$1"
uci commit wireless
#wifi
