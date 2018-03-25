#!/bin/bash

## Nome: connect.sh
## Descricao: Script que conecta a serviços de VPN via terminal
## Autor: Jeronimo Luis Ferreira Filho
## E-mail: jeluis10@gmail.com
## Versão: 0.1
## Data: 24/03/2018

## Verifica se esta rodando como root
if [[ $UID -ne 0 ]]; then
	echo "O script não esta sendo executado como root!!"
	echo "Execute o script como root!!"
	exit 1
fi

## Variaveis
diretorio="/opt/VPN-connector"
userpassfile="${diretorio}/userpass.txt"
VPNs[1]="VPNBook-Alemanha"
VPNs[2]="VPNBook-Canada"
VPNs[3]="VPNBook-Euro-1"
VPNs[4]="VPNBook-Euro-2"
VPNs[5]="VPNBook-US-1"
VPNs[6]="VPNBook-US-2"
VPNs[7]="FreeVPN-im"
VPNs[8]="FreeVPN-it"
VPNs[9]="FreeVPN-me"
VPNs[10]="FreeVPN-se"
## Fim variáveis

## Funções

## Salva o usuario e senha recebidos via parametro em um arquivo de texto
function set_userpassfile(){
	echo $1 > ${userpassfile}
	echo $2 >> ${userpassfile}
}

## Inicia a VPN. Função recebe como parametro a opção da VPN escolhida.
function set_VPN(){
	openvpn --config ${diretorio}/${VPNs[$1]}.ovpn --auth-user-pass ${userpassfile}
}

## Fim funções

## Mostra as opções de VPNs disponíveis
echo -e "Qual VPN deseja utilizar?"
for (( i = 1; i < 11; i++ )); do
	echo "[$i] = ${VPNs[$i]}"

done
## Lê a opção selecionada pelo usuário
echo "Digite a opção desejada: "
read opcao
## Pega o username e password atualizado do site e coloca no arquivo userpass.txt
## Se for selecionado um valor de 1 a 6 pega os dados da VPNBook, caso contrario pega da FreeVPN
if [[ ${opcao} -gt 0 ]] && [[ ${opcao} -lt 7 ]]; then
	username=$(curl -s https://www.vpnbook.com/freevpn | grep -i -m 1 "username" | cut -d ">" -f 3 | cut -d "<" -f 1)
	password=$(curl -s https://www.vpnbook.com/freevpn | grep -i -m 1 "password" | cut -d ">" -f 3 | cut -d "<" -f 1)
	set_userpassfile ${username} ${password}	
	set_VPN ${opcao}
elif [[ ${opcao} -gt 6 ]] && [[ ${opcao} -lt 11 ]]; then
	case ${opcao} in
		"7" )
			username=$(curl -s https://www.freevpn.im/accounts/ | grep -o -E "Username:[<]\/b>\S[a-zA-Z0-9]+" | cut -d">" -f 2 | sed "s/[^[:alnum:]]//g")
			password=$(curl -s https://www.freevpn.im/accounts/ | grep -o -E "Password:<\/b>\s[a-zA-Z0-9]+" | cut -d">" -f 2 | sed "s/[^[:alnum:]]//g")
			set_userpassfile ${username} ${password}
			set_VPN ${opcao}
		;;
		"8" )
			username=$(curl -s https://freevpn.it/accounts/ | grep -o -E "Username:[<]\/b>\S[a-zA-Z0-9]+" | cut -d">" -f 2 | sed "s/[^[:alnum:]]//g")
			password=$(curl -s https://freevpn.it/accounts/ | grep -o -E -m 1 "Password:<\/b>\s[a-zA-Z0-9]+" | cut -d">" -f 2 | sed "s/[^[:alnum:]]//g")
			set_userpassfile ${username} ${password}
			set_VPN ${opcao}
		;;
		"9" )
			username=$(curl -s https://freevpn.me/accounts/ | grep -o -E "Bundle.+Username:</b>\s[a-zA-Z0-9]+" | grep -o -E "Username:</b>\s[a-zA-Z0-9]+" | cut -d">" -f 2 | sed "s/[^[:alnum:]]//g")
			password=$(curl -s https://freevpn.me/accounts/ | grep -o -E "Bundle.+Password:\S</b>[a-zA-Z0-9]+" | grep -o -E "Password:\S</b>[a-zA-Z0-9]+" | cut -d">" -f 2 | sed "s/[^[:alnum:]]//g")
			set_userpassfile ${username} ${password}
			set_VPN ${opcao}
		;;
		"10" )
			username=$(curl -s https://www.freevpn.se/accounts/ | grep -o -E "Username:</b>\S[a-zA-Z0-9]+" | cut -d">" -f 2 | sed "s/[^[:alnum:]]//g")
			password=$(curl -s https://www.freevpn.se/accounts/ | grep -o -E "Password:\S</b>[a-zA-Z0-9]+" | cut -d">" -f 2 | sed "s/[^[:alnum:]]//g")
			set_userpassfile ${username} ${password}
			set_VPN ${opcao}
		;;
	esac
else
	echo "Digite uma opcao entre 1-10"
fi
