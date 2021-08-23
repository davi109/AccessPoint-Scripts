export PATH=/bin:/sbin:/usr/bin:/usr/sbin;
ifconfig wlan0 > /dev/null
err=$?

#Script para realizar o scan da interface wlan para detectar vizinhos

if [ "$err" -eq 1 ]
	then
	iw phy0 interface add wlan0 type station
	ifconfig wlan0 up
fi

logger 'Iniciando escaneamento da interface wireless'
 
iwinfo wlan0 scan > /tmp/scan-result.txt
grep Cell /tmp/scan-result.txt | awk '{print $5;}' | sort -u > /tmp/neighborhood.txt
