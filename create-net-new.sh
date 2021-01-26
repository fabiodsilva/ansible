#!/bin/bash 

clear

TENANT=`cat ./info | grep TENANT | awk -F : '{ print $2 }'`

echo ""
echo ""
echo -n "		Qual ambiente será criado Glete ou Tamboré? ? (G)lete/(T)amboré/(S)air? "
read resposta
echo ""
case "$resposta" in
    g|G|"")

	echo	"		Aplicando as váriaveis de ambiente para Glete"
#        export OS_AUTH_URL=https://keystone.br-sp1.openstack.uolcloud.com.br:5000/v2.0
	export OS_AUTH_URL=http://10.137.131.244:35357/v3

	export OS_TENANT_NAME=$TENANT

	# unsetting v3 items in case set
	unset OS_PROJECT_ID
	unset OS_PROJECT_NAME
	unset OS_USER_DOMAIN_NAME
	unset OS_INTERFACE

	export OS_AUTH_URL=http://10.137.131.244:35357/v3
	export CINDER_ENDPOINT_TYPE='internalURL'
	export GLANCE_ENDPOINT_TYPE='internalURL'
	export KEYSTONE_ENDPOINT_TYPE='internalURL'
	export NOVA_ENDPOINT_TYPE='internalURL'
	export NEUTRON_ENDPOINT_TYPE='internalURL'
	export OS_INTERFACE=internal
	export OS_ENDPOINT_TYPE=internalURL
	export PS1='[\u@\h \W(keystone_adminV3)]\$ '
	export PYTHONWARNINGS='ignore:Certificate has no, ignore:A true SSLContext object is not available'
	export OS_IDENTITY_API_VERSION=3
	export OS_PROJECT_DOMAIN_NAME=Default
	export OS_USER_DOMAIN_NAME=Default



#	export OS_REGION_NAME="br-sp1"
#	if [ -z "$OS_REGION_NAME" ]; then unset OS_REGION_NAME; fi
#	
#	export OS_ENDPOINT_TYPE=publicURL
#	export OS_IDENTITY_API_VERSION=2

    ;;
    T|t)

	echo    "               Aplicando as váriaveis de ambiente para Tamboré"
	export OS_AUTH_URL=https://keystone.br-sp2.openstack.uolcloud.com.br:5000/v2.0
	export OS_TENANT_NAME=$TENANT
	
	# unsetting v3 items in case set
	unset OS_PROJECT_ID
	unset OS_PROJECT_NAME
	unset OS_USER_DOMAIN_NAME
	unset OS_INTERFACE
	export OS_REGION_NAME="br-sp2"
	if [ -z "$OS_REGION_NAME" ]; then unset OS_REGION_NAME; fi
	export OS_ENDPOINT_TYPE=publicURL
	export OS_IDENTITY_API_VERSION=2
    
    ;;
    s|S)
        echo 	"		Saindo..."
	exit 1
    ;;
    *)
        echo "Opção inválida"
	exit 1
    ;;
esac

echo ""
read -p 	"		Digite o usuário $foo" user_c


unset senha_c
prompt="		Digite a senha:"
while IFS= read -p "$prompt" -r -s -n 1 char
do
    if [[ $char == $'\0' ]]
    then
        break
    fi
    prompt='*'
    senha_c+="$char"
done
echo

echo ""
export OS_USERNAME=$user_c
export OS_PASSWORD=$senha_c
echo ""



echo ""






TENANT=`cat ./info | grep TENANT | awk -F : '{ print $2 }'`

echo 	"		Todas as configurações serão aplicadas no Tenant --> $TENANT"

read -p "		Está correto $foo? [sn]" answer
if [[ $answer = s ]] ; then
echo ""

echo 	"		As seguintes redes serão criadas no Tenant $TENANT"

P_NAME_PRD=`cat ./info | grep P_NAME_PRD | awk -F : '{ print $2 }'`
echo 	"		private_b2w_`echo $TENANT`_prd 	Subnet $P_NAME_PRD/24"

PO1=`echo $P_NAME_PRD | awk -F "." '{ print $1}'`
SO1=`echo $P_NAME_PRD | awk -F "." '{ print $2}'`
TO1=`echo $P_NAME_PRD | awk -F "." '{ print $3}'`


B_NAME_PRD=`cat ./info | grep B_NAME_PRD | awk -F : '{ print $2 }'`
echo 	"		backup_b2w_`echo $TENANT`_prd 	Subnet $B_NAME_PRD/24"
 
PO2=`echo $B_NAME_PRD | awk -F "." '{ print $1}'`
SO2=`echo $B_NAME_PRD | awk -F "." '{ print $2}'`
TO2=`echo $B_NAME_PRD | awk -F "." '{ print $3}'`


P_NAME_HML=`cat ./info | grep P_NAME_HML | awk -F : '{ print $2 }'`
echo 	"		private_b2w_`echo $TENANT`_hml 	Subnet $P_NAME_HML/24"

PO3=`echo $P_NAME_HML | awk -F "." '{ print $1}'`
SO3=`echo $P_NAME_HML | awk -F "." '{ print $2}'`
TO3=`echo $P_NAME_HML | awk -F "." '{ print $3}'`


B_NAME_HML=`cat ./info | grep B_NAME_HML | awk -F : '{ print $2 }'`
echo 	"		backup_b2w_`echo $TENANT`_hml 	Subnet $B_NAME_HML/24"

PO4=`echo $B_NAME_HML | awk -F "." '{ print $1}'`
SO4=`echo $B_NAME_HML | awk -F "." '{ print $2}'`
TO4=`echo $B_NAME_HML | awk -F "." '{ print $3}'`



INTERNET=`cat ./info | grep INTERNET | awk -F : '{ print $2 }'`
echo 	"		internet		Subnet $INTERNET/24"

PO5=`echo $INTERNET | awk -F "." '{ print $1}'`
SO5=`echo $INTERNET | awk -F "." '{ print $2}'`
TO5=`echo $INTERNET | awk -F "." '{ print $3}'`




read -p "		Está correto $foo? [sn]" answer
if [[ $answer = s ]] ; then


clear

echo 	"		Criando as redes....."

openstack subnet list

openstack network create private_b2w_`echo $TENANT`_prd 2>/dev/null

openstack subnet create subnet-private_b2w_`echo $TENANT`_prd --network private_b2w_`echo $TENANT`_prd --subnet-range $P_NAME_PRD/24 --dhcp --gateway $PO1.$SO1.$TO1.1 --allocation-pool start=$PO1.$SO1.$TO1.20,end=$PO1.$SO1.$TO1.254 --dns-nameserver 10.13.31.11 --dns-nameserver 10.13.31.12 --dns-nameserver 10.3.31.11 --dns-nameserver 10.131.0.37 --host-route destination=169.254.169.254/32,gateway=$PO1.$SO1.$TO1.1 --host-route destination=10.0.0.0/8,gateway=$PO1.$SO1.$TO1.1 2>/dev/null
echo	"		-----------------------------------------------------------------"
echo 	"		Rede private_b2w_`echo $TENANT`_prd criada"
openstack subnet list | grep private_b2w_`echo $TENANT`_prd
echo 	"		-----------------------------------------------------------------"

openstack network create backup_b2w_`echo $TENANT`_prd 2>/dev/null

openstack subnet create subnet-backup_b2w_`echo $TENANT`_prd --network backup_b2w_`echo $TENANT`_prd --subnet-range $B_NAME_PRD/24 --dhcp --gateway=$PO2.$SO2.$TO2.1 --allocation-pool start=$PO2.$SO2.$TO2.20,end=$PO2.$SO2.$TO2.254 --dns-nameserver 10.13.31.11 --dns-nameserver 10.13.31.12 --dns-nameserver 10.3.31.11 --dns-nameserver 10.131.0.37 --host-route destination=169.254.169.254/32,gateway=$PO2.$SO2.$TO2.1 --host-route destination=10.0.0.0/8,gateway=$PO2.$SO2.$TO2.1 2>/dev/null
echo 	"		-----------------------------------------------------------------"
echo 	"		Rede  backup_b2w_`echo $TENANT`_prd criada"
openstack subnet list | grep backup_b2w_`echo $TENANT`_prd
echo 	"		-----------------------------------------------------------------"

openstack network create private_b2w_`echo $TENANT`_hml 2>/dev/null

openstack subnet create subnet-private_b2w_`echo $TENANT`_hml --network private_b2w_`echo $TENANT`_hml --subnet-range $P_NAME_HML/24 --dhcp --gateway=$PO3.$SO3.$TO3.1 --allocation-pool start=$PO3.$SO3.$TO3.20,end=$PO3.$SO3.$TO3.254 --dns-nameserver 10.13.31.11 --dns-nameserver 10.13.31.12 --dns-nameserver 10.3.31.11 --dns-nameserver 10.131.0.37 --host-route destination=169.254.169.254/32,gateway=$PO3.$SO3.$TO3.1 --host-route destination=10.0.0.0/8,gateway=$PO3.$SO3.$TO3.1 2>/dev/null
echo 	"		-----------------------------------------------------------------"
echo 	"		Rede private_b2w_`echo $TENANT`_hml criada"
openstack subnet list | grep private_b2w_`echo $TENANT`_hml
echo 	"		-----------------------------------------------------------------"

openstack network create backup_b2w_`echo $TENANT`_hml 2>/dev/null

openstack subnet create subnet-backup_b2w_`echo $TENANT`_hml --network backup_b2w_`echo $TENANT`_hml --subnet-range $B_NAME_HML/24 --dhcp --gateway=$PO4.$SO4.$TO4.1 --allocation-pool start=$PO4.$SO4.$TO4.20,end=$PO4.$SO4.$TO4.254 --dns-nameserver 10.13.31.11 --dns-nameserver 10.13.31.12 --dns-nameserver 10.3.31.11 --dns-nameserver 10.131.0.37 --host-route destination=169.254.169.254/32,gateway=$PO4.$SO4.$TO4.1 --host-route destination=10.0.0.0/8,gateway=$PO4.$SO4.$TO4.1 2>/dev/null
echo 	"		-----------------------------------------------------------------"
echo 	"		Rede backup_b2w_`echo $TENANT`_hml criada"
openstack subnet list | grep backup_b2w_`echo $TENANT`_hml
echo 	"		-----------------------------------------------------------------"


openstack network create internet 2>/dev/null

openstack subnet create subnet-internet --network internet --subnet-range $INTERNET/24 --dhcp --allocation-pool start=$PO5.$SO5.$TO5.20,end=$PO5.$SO5.$TO5.254 --dns-nameserver 200.221.11.100 --dns-nameserver 200.221.11.101 2>/dev/null
echo 	"		-----------------------------------------------------------------"
echo 	"		Rede internet criada"
openstack subnet list | grep internet 
echo 	"		-----------------------------------------------------------------"
clear
echo ""
echo 	"		-----------------------------------------------------------------"
echo 	"		redes criadas segue abaixo"

echo 	"		-----------------------------------------------------------------"

openstack subnet list


else

echo ""
echo 	"		Verifique as informações no arquivo info. Nenhuma rede foi realizada"

fi



echo 	"		Agora vamos criar as rede de interligação"
echo ""


echo 	"		Para a criação das redes de interligação é necessário que o usuário seja admin."
echo ""
read -p "		Digite o usuário admin $foo" user

unset senha
prompt="                Digite a senha:"
while IFS= read -p "$prompt" -r -s -n 1 char
do
    if [[ $char == $'\0' ]]
    then
        break
    fi
    prompt='*'
    senha+="$char"
done
echo

echo ""
export OS_USERNAME=$user
export OS_PASSWORD="$senha"


echo ""

REDE_I_PROD=`cat ./info | grep REDE_I_PROD | awk -F : '{ print $2 }'`
VLAN_PROD=`cat ./info | grep VLAN_PROD  | awk -F : '{ print $2 }'`
echo 	"		connector-vlan`echo $VLAN_PROD`_PROD  Subnet $REDE_I_PROD/29"

PO6=`echo $REDE_I_PROD | awk -F "." '{ print $1}'`
SO6=`echo $REDE_I_PROD | awk -F "." '{ print $2}'`
TO6=`echo $REDE_I_PROD | awk -F "." '{ print $3}'`
QO6=`echo $REDE_I_PROD | awk -F "." '{ print $4}'`

REDE_I_BKP=`cat ./info | grep REDE_I_BKP | awk -F : '{ print $2 }'`
VLAN_HML=`cat ./info | grep VLAN_HML  | awk -F : '{ print $2 }'`
echo 	"		connector-vlan`echo $VLAN_HML`_PROD  Subnet $REDE_I_BKP/29"


PO7=`echo $REDE_I_BKP | awk -F "." '{ print $1}'`
SO7=`echo $REDE_I_BKP | awk -F "." '{ print $2}'`
TO7=`echo $REDE_I_BKP | awk -F "." '{ print $3}'`
QO7=`echo $REDE_I_BKP | awk -F "." '{ print $4}'`


read -p "		Está correto $foo? [sn]" answer
if [[ $answer = s ]] ; then

echo 	"		Criando as redes de interligação....."

openstack network create --no-share --provider-network-type vlan --provider-physical-network connector --provider-segment $VLAN_PROD --enable connector-vlan`echo $VLAN_PROD`_PRD

openstack subnet create subnet-connector-vlan`echo $VLAN_PROD`_PRD --network connector-vlan`echo $VLAN_PROD`_PRD --subnet-range $REDE_I_PROD/29 --dhcp --gateway $PO6.$SO6.$TO6.`expr $QO6 + 2` --allocation-pool start=$PO6.$SO6.$TO6.`expr $QO6 + 3`,end=$PO6.$SO6.$TO6.`expr $QO6 + 6`


openstack network create --no-share --provider-network-type vlan --provider-physical-network connector --provider-segment $VLAN_HML --enable connector-vlan`echo $VLAN_HML`_BKP

openstack subnet create subnet-connector-vlan`echo $VLAN_HML`_BKP --network connector-vlan`echo $VLAN_HML`_BKP --subnet-range $REDE_I_BKP/29 --dhcp --gateway $PO7.$SO7.$TO7.`expr $QO7 + 2` --allocation-pool start=$PO7.$SO7.$TO7.`expr $QO7 + 3`,end=$PO7.$SO7.$TO7.`expr $QO7 + 6`


else

echo 	"		Verifique as informações no arquivo info. As redes de interligação não foram criadas"


fi

echo 	"		Agora será realizado a interligaçao dos routers com as redes"
echo ""

echo 	"		Voltando as permissões apenas no tenant"
echo ""
export OS_USERNAME=$user_c
export OS_PASSWORD=$senha_c
echo ""



read -p "     		Deseja criar o router1 $foo? [sn]" answer
if [[ $answer = s ]] ; then
openstack router create router1
echo "     router 1 criado"
fi

read -p "		Deseja criar o router-backup $foo? [sn]" answer
if [[ $answer = s ]] ; then
openstack router create router-backup
echo 	"		router-backup criado"
fi

clear

echo 	"		-----------------------------------------------------------------RESUMO-----------------------------------------------------------"
echo 	"		-> Redes"
openstack subnet list

echo ""
echo 	"		-> Roteadores"
openstack router list

echo 	"		->  O roteador router1 será associado as redes  private_b2w_`echo $TENANT`_prd, private_b2w_`echo $TENANT`_hml e connector-vlan`echo $VLAN_PROD`_PRD"
echo 	"		->  O roteador router-backup será associado as redes  backup_b2w_`echo $TENANT`_prd, backup_b2w_`echo $TENANT`_hml e connector-vlan`echo $VLAN_HML`_BKP"
echo 	"		->  O roteador roteador-rede-privada será associado a rede internet"
 

read -p "     Está correto $foo? [sn]" answer
if [[ $answer = s ]] ; then


#Routers e subnets PRIVATE
neutron router-interface-add $(neutron router-list | grep  router1 | awk '{print $2}') $(neutron subnet-list | grep private_b2w_`echo $TENANT`_prd | awk '{print $2}')

neutron router-interface-add $(neutron router-list | grep  router1 | awk '{print $2}') $(neutron subnet-list | grep private_b2w_`echo $TENANT`_hml | awk '{print $2}')

neutron router-interface-add $(neutron router-list | grep  router1 | awk '{print $2}') $(neutron subnet-list | grep connector-vlan`echo $VLAN_PROD`_PRD | awk '{print $2}')

#Routers e subnets BACKUP
neutron router-interface-add $(neutron router-list | grep  router-backup | awk '{print $2}') $(neutron subnet-list | grep backup_b2w_`echo $TENANT`_prd | awk '{print $2}')

neutron router-interface-add $(neutron router-list | grep  router-backup | awk '{print $2}') $(neutron subnet-list | grep backup_b2w_`echo $TENANT`_hml | awk '{print $2}')

neutron router-interface-add $(neutron router-list | grep  router-backup | awk '{print $2}') $(neutron subnet-list | grep connector-vlan`echo $VLAN_HML`_BKP | awk '{print $2}')

#Router Internet
neutron router-interface-add $(neutron router-list | grep  roteador-rede-privada | awk '{print $2}') $(neutron subnet-list | grep -i internet | awk '{print $2}')


#Criando as rotas default para os routers: router1 e router-backup


echo "Criando as rotas default para os routers: router1 e router-backup"


neutron router-update --admin-state-up True --route destination=0.0.0.0/0,nexthop=$PO6.$SO6.$TO6.`expr $QO6 + 1` router1

neutron router-update --admin-state-up True --route destination=0.0.0.0/0,nexthop=$PO7.$SO7.$TO7.`expr $QO7 + 1` router-backup



else

echo "      Verifique as informações no arquivo info. Nenhum alteraçao nos routers foi feita"

fi

else 

echo	"		Verifique as informações no arquivo info. "

fi




