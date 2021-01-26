#!/bin/bash




TENANT=`cat ./info | grep TENANT | awk -F : '{ print $2 }'`
echo ""
echo "		As seguintes redes serão criadas no Tenant $TENANT"


export OS_TENANT_NAME=$TENANT

openstack project show $OS_TENANT_NAME

echo $OS_TENANT_NAME

P_NAME_PRD=`cat ./info | grep P_NAME_PRD | awk -F : '{ print $2 }'`
echo "		private_`echo $TENANT`_prd    Subnet $P_NAME_PRD/22"

PO1=`echo $P_NAME_PRD | awk -F "." '{ print $1}'`
SO1=`echo $P_NAME_PRD | awk -F "." '{ print $2}'`
TO1=`echo $P_NAME_PRD | awk -F "." '{ print $3}'`


B_NAME_PRD=`cat ./info | grep B_NAME_PRD | awk -F : '{ print $2 }'`
echo "		backup_`echo $TENANT`_prd     Subnet $B_NAME_PRD/22"

PO2=`echo $B_NAME_PRD | awk -F "." '{ print $1}'`
SO2=`echo $B_NAME_PRD | awk -F "." '{ print $2}'`
TO2=`echo $B_NAME_PRD | awk -F "." '{ print $3}'`


P_NAME_HML=`cat ./info | grep P_NAME_HML | awk -F : '{ print $2 }'`
echo "		private_`echo $TENANT`_hml    Subnet $P_NAME_HML/22"

PO3=`echo $P_NAME_HML | awk -F "." '{ print $1}'`
SO3=`echo $P_NAME_HML | awk -F "." '{ print $2}'`
TO3=`echo $P_NAME_HML | awk -F "." '{ print $3}'`


B_NAME_HML=`cat ./info | grep B_NAME_HML | awk -F : '{ print $2 }'`
echo "		backup_`echo $TENANT`_hml     Subnet $B_NAME_HML/22"

PO4=`echo $B_NAME_HML | awk -F "." '{ print $1}'`
SO4=`echo $B_NAME_HML | awk -F "." '{ print $2}'`
TO4=`echo $B_NAME_HML | awk -F "." '{ print $3}'`



INTERNET=`cat ./info | grep INTERNET | awk -F : '{ print $2 }'`
echo "		internet 	Subnet $INTERNET/22"

PO5=`echo $INTERNET | awk -F "." '{ print $1}'`
SO5=`echo $INTERNET | awk -F "." '{ print $2}'`
TO5=`echo $INTERNET | awk -F "." '{ print $3}'`


echo ""

read -p "Está correto $foo? [sn]" answer
if [[ $answer = s ]] ; then

echo "		Criando as redes....."

openstack subnet list

openstack network create private_`echo $TENANT`_prd 2>/dev/null

openstack subnet create subnet-private_`echo $TENANT`_prd --network private_`echo $TENANT`_prd --subnet-range $P_NAME_PRD/22 --dhcp --gateway $PO1.$SO1.$TO1.1 --allocation-pool start=$PO1.$SO1.$TO1.20,end=$PO1.$SO1.`expr $TO1 + 3`.254 --dns-nameserver 10.13.31.11 --dns-nameserver 10.13.31.12 --dns-nameserver 10.3.31.11 --dns-nameserver 10.131.0.37 --host-route destination=169.254.169.254/32,gateway=$PO1.$SO1.$TO1.1 --host-route destination=10.0.0.0/8,gateway=$PO1.$SO1.$TO1.1 2>/dev/null
echo "		-----------------------------------------------------------------"
echo "		Rede private_`echo $TENANT`_prd criada"
openstack subnet list | grep private_`echo $TENANT`_prd
echo "		-----------------------------------------------------------------"



openstack network create backup_`echo $TENANT`_prd 2>/dev/null

openstack subnet create subnet-backup_`echo $TENANT`_prd --network backup_`echo $TENANT`_prd --subnet-range $B_NAME_PRD/22 --dhcp --gateway=$PO2.$SO2.$TO2.1 --allocation-pool start=$PO2.$SO2.$TO2.20,end=$PO2.$SO2.`expr $TO2 + 3`.254 --dns-nameserver 10.13.31.11 --dns-nameserver 10.13.31.12 --dns-nameserver 10.3.31.11 --dns-nameserver 10.131.0.37 --host-route destination=169.254.169.254/32,gateway=$PO2.$SO2.$TO2.1 --host-route destination=10.0.0.0/8,gateway=$PO2.$SO2.$TO2.1 2>/dev/null
echo "		-----------------------------------------------------------------"
echo "		Rede  backup_`echo $TENANT`_prd criada"
openstack subnet list | grep backup_`echo $TENANT`_prd
echo "		-----------------------------------------------------------------"



openstack network create private_`echo $TENANT`_hml 2>/dev/null

openstack subnet create subnet-private_`echo $TENANT`_hml --network private_`echo $TENANT`_hml --subnet-range $P_NAME_HML/22 --dhcp --gateway=$PO3.$SO3.$TO3.1 --allocation-pool start=$PO3.$SO3.$TO3.20,end=$PO3.$SO3.`expr $TO3 + 3`.254 --dns-nameserver 10.13.31.11 --dns-nameserver 10.13.31.12 --dns-nameserver 10.3.31.11 --dns-nameserver 10.131.0.37 --host-route destination=169.254.169.254/32,gateway=$PO3.$SO3.$TO3.1 --host-route destination=10.0.0.0/8,gateway=$PO3.$SO3.$TO3.1 

echo "		-----------------------------------------------------------------"
echo "		Rede private_`echo $TENANT`_hml criada"
openstack subnet list | grep private_`echo $TENANT`_hml
echo "		-----------------------------------------------------------------"



openstack network create backup_`echo $TENANT`_hml 2>/dev/null

openstack subnet create subnet-backup_`echo $TENANT`_hml --network backup_`echo $TENANT`_hml --subnet-range $B_NAME_HML/22 --dhcp --gateway=$PO4.$SO4.$TO4.1 --allocation-pool start=$PO4.$SO4.$TO4.20,end=$PO4.$SO4.`expr $TO4 + 3`.254 --dns-nameserver 10.13.31.11 --dns-nameserver 10.13.31.12 --dns-nameserver 10.3.31.11 --dns-nameserver 10.131.0.37 --host-route destination=169.254.169.254/32,gateway=$PO4.$SO4.$TO4.1 --host-route destination=10.0.0.0/8,gateway=$PO4.$SO4.$TO4.1 2>/dev/null
echo "		-----------------------------------------------------------------"
echo "		Rede backup_`echo $TENANT`_hml criada"
openstack subnet list | grep backup_`echo $TENANT`_hml
echo "		-----------------------------------------------------------------"


openstack network create internet 2>/dev/null

openstack subnet create subnet-internet --network internet --subnet-range $INTERNET/22 --dhcp --allocation-pool start=$PO5.$SO5.$TO5.20,end=$PO5.$SO5.$TO5.254 --dns-nameserver 200.221.11.100 --dns-nameserver 200.221.11.101 2>/dev/null

echo "		-----------------------------------------------------------------"
echo "		Rede internet criada"
openstack subnet list | grep internet
echo "		-----------------------------------------------------------------"
echo ""
echo "		-----------------------------------------------------------------"
echo "		redes criadas segue abaixo"

echo "		-----------------------------------------------------------------"
openstack subnet list


else

echo "		Nenhuma rede foi criada"

fi



echo "		Agora vamos criar as rede de interligação"



# Para a criação das redes de interligação é necessário que o usuário seja admin do Tenant.

unset OS_USERNAME
unset OS_PASSWORD

export OS_USERNAME=admin
export OS_PASSWORD="xxxxxxxxx"


REDE_I_PROD=`cat ./info | grep REDE_I_PROD | awk -F : '{ print $2 }'`
VLAN_PROD=`cat ./info | grep VLAN_PROD  | awk -F : '{ print $2 }'`
echo "		connector-vlan`echo $VLAN_PROD`_PROD  Subnet $REDE_I_PROD/29"

PO6=`echo $REDE_I_PROD | awk -F "." '{ print $1}'`
SO6=`echo $REDE_I_PROD | awk -F "." '{ print $2}'`
TO6=`echo $REDE_I_PROD | awk -F "." '{ print $3}'`
QO6=`echo $REDE_I_PROD | awk -F "." '{ print $4}'`

REDE_I_BKP=`cat ./info | grep REDE_I_BKP | awk -F : '{ print $2 }'`
VLAN_HML=`cat ./info | grep VLAN_HML  | awk -F : '{ print $2 }'`
echo "		connector-vlan`echo $VLAN_HML`_PROD  Subnet $REDE_I_BKP/29"


PO7=`echo $REDE_I_BKP | awk -F "." '{ print $1}'`
SO7=`echo $REDE_I_BKP | awk -F "." '{ print $2}'`
TO7=`echo $REDE_I_BKP | awk -F "." '{ print $3}'`
QO7=`echo $REDE_I_BKP | awk -F "." '{ print $4}'`


read -p "Está correto $foo? [sn]" answer
if [[ $answer = s ]] ; then



openstack network create --no-share --provider-network-type vlan --provider-physical-network connector --provider-segment $VLAN_PROD --enable connector-vlan`echo $VLAN_PROD`_PRD

openstack subnet create subnet-connector-vlan`echo $VLAN_PROD`_PRD --network connector-vlan`echo $VLAN_PROD`_PRD --subnet-range $REDE_I_PROD/29 --dhcp --gateway $PO6.$SO6.$TO6.`expr $QO6 + 2` --allocation-pool start=$PO6.$SO6.$TO6.`expr $QO6 + 3`,end=$PO6.$SO6.$TO6.`expr $QO6 + 6`


openstack network create --no-share --provider-network-type vlan --provider-physical-network connector --provider-segment $VLAN_HML --enable connector-vlan`echo $VLAN_HML`_BKP

openstack subnet create subnet-connector-vlan`echo $VLAN_HML`_BKP --network connector-vlan`echo $VLAN_HML`_BKP --subnet-range $REDE_I_BKP/29 --dhcp --gateway $PO7.$SO7.$TO7.`expr $QO7 + 2` --allocation-pool start=$PO7.$SO7.$TO7.`expr $QO7 + 3`,end=$PO7.$SO7.$TO7.`expr $QO7 + 6`


else
echo ""
echo "		As redes de interligação não foram criadas"


fi

echo "		Agora será realizado a interligaçao dos routers com as redes"
echo ""

#Voltando as permissões apenas no tenant

export OS_USERNAME=conftenant
export OS_PASSWORD="xxxxxxxxx"


read -p "     Deseja criar o router1 $foo? [sn]" answer
if [[ $answer = s ]] ; then
openstack router create router1
echo "		router 1 criado"
fi

read -p "     	Deseja criar o router-backup $foo? [sn]" answer
if [[ $answer = s ]] ; then
openstack router create router-backup
echo "     	router-backup criado"
fi

echo "-----------------------------------------------------------------RESUMO-----------------------------------------------------------"
echo "		->Redes"
openstack subnet list

echo ""
echo "		->Roteadores"
openstack router list

echo "		->  O roteador router1 será associado as redes  private_`echo $TENANT`_prd, private_`echo $TENANT`_hml e connector-vlan`echo $VLAN_PROD`_PRD"
echo "    	->  O roteador router-backup será associado as redes  backup_`echo $TENANT`_prd, backup_`echo $TENANT`_hml e connector-vlan`echo $VLAN_HML`_BKP"
echo "    	->  O roteador roteador-rede-privada será associado a rede internet"


read -p "     	Confirma $foo? [sn]" answer
if [[ $answer = s ]] ; then


#Routers e subnets PRIVATE
neutron router-interface-add $(neutron router-list | grep  router1 | awk '{print $2}') $(neutron subnet-list | grep private_`echo $TENANT`_prd | awk '{print $2}')

neutron router-interface-add $(neutron router-list | grep  router1 | awk '{print $2}') $(neutron subnet-list | grep private_`echo $TENANT`_hml | awk '{print $2}')

neutron router-interface-add $(neutron router-list | grep  router1 | awk '{print $2}') $(neutron subnet-list | grep connector-vlan`echo $VLAN_PROD`_PRD | awk '{print $2}')

#Routers e subnets BACKUP
neutron router-interface-add $(neutron router-list | grep  router-backup | awk '{print $2}') $(neutron subnet-list | grep backup_`echo $TENANT`_prd | awk '{print $2}')

neutron router-interface-add $(neutron router-list | grep  router-backup | awk '{print $2}') $(neutron subnet-list | grep backup_`echo $TENANT`_hml | awk '{print $2}')

neutron router-interface-add $(neutron router-list | grep  router-backup | awk '{print $2}') $(neutron subnet-list | grep connector-vlan`echo $VLAN_HML`_BKP | awk '{print $2}')

#Router Internet
neutron router-interface-add $(neutron router-list | grep  roteador-rede-privada | awk '{print $2}') $(neutron subnet-list | grep -i internet | awk '{print $2}')

else

echo "		Nenhum alteraçao nos routers foi feita"

fi
