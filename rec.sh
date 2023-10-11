#!/usr/bin/env bash

#COR
green="\033[32;1m"
red="\033[31;1m"
purple="\033[35;1m"
orange="\033[33;1m"
cor="\033[m"
#========================================================================================================================================

#INTRO===================================================================================================================================
cat <<EOF

Script de Recuperação de Arquivos (FILE CARVING)
Autor: Luciano Ramone 2023
Versão: 1.0
Descrição: Este script permite a recuperação de arquivos perdidos ou deletados (com perca de metadados).
Uso: Apenas ir preenchendo os requisitos como: tipos de arquivos (jpg,png etc..), local da midia (/dev/sdb etc..)
Será criado um diretório vazio chamado backupDATAeHORA, então só aguardar a recuperação dos arquivos...

Formatos aceitos: jpg, gif, png, bmp, avi, exe, mpg, wav, riff, wmv, mov, pdf, ole, doc, zip, rar, htm, cpp, mp4
Para recuperar todos use: all
EOF
sleep 1s
echo ""

#=========================================================================================================================================

#VERIFICAÇÃO DE USUARIO ROOT=============================================================================================================
(($UID > 0)) && { echo -e "${red}Entre com usuario ROOT... ${cor}" ; exit 1 ;}

#VERIFICAÇÃO DO FOREMOST
if ! type -p foremost >/dev/null; then
   echo -e "${green}INSTALANDO FOREMOST... ${cor}"
   apt install foremost
fi
#=========================================================================================================================================

#IDENTIFICAR DISPOSITIVO CONECTADO USB====================================================================================================
listagem=`fdisk -l | grep -A1000 "Boot"`

echo -e "${green}Listagem dos dispositivos conectados: \n ${cor}"

if [[ -z $listagem ]]; then
   echo -e "${red}INSIRA DISPOSITIVO USB E TENTE NOVAMENTE ${cor}"
   exit 1
else
   echo -e "${purple}${listagem} ${cor}"
fi

read -s -p "Aperte ENTER para continuar..." conn
if [[ $conn == * ]]; then
 echo " "
  echo " "
fi
#=========================================================================================================================================

#INICIANDO FOREMOST=======================================================================================================================
read -p "Tipos/extensões de arquivos (separados por virgula,) all para todos: " formato	#TIPOS DE ARQUIVOS
   sleep 1s
read -e -p "Local do dispositivo (ex: /dev/sdb): " disp	#LOCAL DO DISPOSITIVO
echo ""

bk="backup_`date +%H%M%S_%d%m`"		#CRIAR DIRETÓRIO VAZIO PARA ARMAZENAR ARQUIVOS
echo -e "${green}Foi gerada uma pasta de nome DIA e HORA no diretório atual... ${cor}"
   sleep 1s
echo ""


foremost -v -t $formato -o $bk $disp &>/dev/null		#INICIANDO FOREMOST E A MAGICA ACONTECENDO

 sleep 2s
 
 echo -e "${orange}RECUPERANDO ARQUIVOS ${formato} ... ${cor}"
 sleep 2s
 	

cat <<EOF
Todos arquivos recuperados estão dentro da pasta criada e contendo o nome do tipo
exemplo: PNG JPG etc...
Todos os arquivos sofrem perda de METADADOS e vem com os titulos numerados.
Foi gerado arquivo de log contendo todas informações e arquivos recuperados dentro da pasta
chamado 'audit.txt'
  
Foremost | Kali Linux | Shell Scripting
  
					Criado por Ram0n3 - 2023
				

EOF

 echo -e "${orange}OPERAÇÃO CONCLUIDA EM: $(date +%d/%m/%Y) $(date +%H:%M:%S) ${cor}"
#==========================================================================================================================================

#fdisk -l | grep -A1000 "Boot" 

