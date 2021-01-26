#!/bin/bash


if [ -z "$1" ];
  then
    	echo "		Coloque como argumentos vlan rede Tenant"
	echo "	 	ex: ./create-net-toolbox.sh 192.168.50.0 500 nome_tenant"
	echo " 		obs: sem a mascara, padrão /27"
	exit 1
fi


if [ -z "$2" ];
  then
        echo "          Coloque como argumentos vlan rede Tenant"
        echo "          ex: ./create-net-toolbox.sh 192.168.50.0 500 nome_tenant"
        echo "          obs: sem a mascara, padrão /27"
        exit 1
fi

if [ -z "$3" ];
  then
        echo "          Coloque como argumentos vlan rede Tenant"
        echo "          ex: ./create-net-toolbox.sh 192.168.50.0 500 nome_tenant"
        echo "          obs: sem a mascara, padrão /27"
        exit 1
fi




echo    "               toolbox-uoldiveo-$2  Subnet: $1 Tenant: $3"


unset OS_TENANT_NAME
export OS_TENANT_NAME=$3


PO6=`echo $1 | awk -F "." '{ print $1}'`
SO6=`echo $1 | awk -F "." '{ print $2}'`
TO6=`echo $1 | awk -F "." '{ print $3}'`
QO6=`echo $1 | awk -F "." '{ print $4}'`

read -p "               Está correto $foo? [sn]" answer
if [[ $answer = s ]] ; then

echo    "               Criando as redes de interligação....."

echo "openstack network create --no-share --provider-network-type vlan --provider-physical-network toolbox --provider-segment $2 --enable toolbox-uoldiveo-$2"

echo "openstack subnet create subnet-toolbox-uoldiveo-`echo $2` --network toolbox-uoldiveo-$2 --subnet-range $1/27 --dhcp --gateway $PO6.$SO6.$TO6.`expr $QO6 + 1` --allocation-pool start=$PO6.$SO6.$TO6.`expr $QO6 + 5`,end=$PO6.$SO6.$TO6.`expr $QO6 + 28`"

fi
