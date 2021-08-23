export PATH=/bin:/sbin:/usr/bin:/usr/sbin;

logger 'Coletando informações dos clientes associados'

iw wlan0 station dump | grep Station | awk '{print $2}' > /tmp/ca.txt
