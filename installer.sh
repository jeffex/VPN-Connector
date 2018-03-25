#!/bin/bash

## Verifica se esta rodando como root
if [[ $UID -ne 0 ]]; then
	echo "O instalador não esta sendo executado como root!!"
	echo "Execute o instalador como root!!"
	exit 1
fi

## Verifica se o diretório já existe
ls /opt/VPN-connector &> /dev/null
if [[ $? -ne 0 ]]; then
	mkdir /opt/VPN-connector
	if [[ $? -eq 0 ]]; then
		echo "Pasta criada...."
	else
		echo "Erro ao criar pasta!!"
		exit 1
	fi
else
	echo "Pasta ja existente..."
fi

cp ./* /opt/VPN-connector
if [[ $? -eq 0 ]]; then
	echo "Arquivos copiados...."
else
	echo "Erro ao copiar arquivos!!"
	exit 1
fi

ln -s /opt/VPN-connector/connect.sh /usr/local/bin/vpn-connect
if [[ $? -eq 0 ]]; then
	echo "Link criado...."
else
	echo "Erro ao criar link!!"
	exit 1
fi

echo "Instalação realizada com sucesso!!!"