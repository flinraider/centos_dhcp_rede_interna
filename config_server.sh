#!/usr/bin/env bash
############################################
# Autor: Leonardo Teixeira                 #
# Server: Servidor DHCP                    #
# CENTOS 7 - 8 e REDHAT derivados          #
# kernel 4.18.0-383.el8.x86_64             #
############################################

echo "configurando rede EXTERNA"
echo "digite o nome da rede EXTERNA"
read ENAME

echo "digite seu ip fixo + PREFIX"
read IP_EXTERNO

echo "digite seu gateway"
read GTW

echo "digite seu DNS"
read DNS

echo "digite nome do dispositivo de rede Exemplo: enp0s3"
read EDEVICE

echo "definindo rede EXTERNA"
nmcli c add con-name $ENAME type ethernet ifname $EDEVICE ipv4.method manual ipv4.address $IP_EXTERNO ipv4.gateway $GTW ipv4.dns $DNS connection.zone external

echo "configurando rede INTERNA"
echo "digite o nome da rede INTERNA"
read INAME

echo "digite seu ip fixo + PREFIX"
read IP_INTERNO

echo "digite nome do dispositivo de rede"
read IDEVICE

echo "definando rede INTERNA"
nmcli c add con-name $INAME type ethernet ifname $IDEVICE ipv4.method manual ipv4.address $IP_INTERNO connection.zone internal

echo "confiurando firewalld"
sudo firewall-cmd --set-default-zone=internal
sudo firewall-cmd --reload

echo "definindo o Hostname"
read NAME_SERVER
sudo hostnamectl set-hostname $NAME_SERVER

echo "instalando dependencias"
sudo yum install dhcp-server -y

echo "backup arquivo original"
mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.bkp

echo "editando arquivo"
cat > /etc/dhcp/dhcpd.conf << "EOF"
log-facility local7;
option domain-name "empresa.com.br";
option domain-name-servers 8.8.8.8,8.8.4.4;
default-lease-time 1800;
max-lease-time 7200;
min-lease-time 1000;
authoritative;
subnet 200.0.113.0 netmask 255.255.255.0 {
    range 200.0.113.2 200.0.113.254;
    option routers 200.0.113.1;
}

## exemplo para algum dispositivo especificp ou servidor ####
# host desktop-linux {
#       hardware ethernet 08:00:27:cb:76:c8;
#       fixed-address 200.0.113.10;
# }

EOF
