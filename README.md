# centos_dhcp_rede_interna
configurando automaticamente rede externa e interna e criando servidor dhcp

instale o git com comando 

*sudo yum install git*

depois verifique seus dispositivos de rede com 

*nmcli device s*

e depois execute o script 

*chmod +x config_server.sh && sudo ./config_server.sh
