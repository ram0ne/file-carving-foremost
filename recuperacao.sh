#!/usr/bin/env bash
#
# recuperacao.sh - Script de Recuperação de Arquivos (FILE CARVING)
# Autor: Luciano Ramone (Ram0n3) - 2023
# Versão: 1.0
#
# Descrição: Permite a recuperação de arquivos perdidos ou deletados
#            (com perda de metadados) usando o foremost.
#

# ============================================================
# CORES
# ============================================================
readonly green="\033[32;1m"
readonly red="\033[31;1m"
readonly purple="\033[35;1m"
readonly orange="\033[33;1m"
readonly cor="\033[m"

# ============================================================
# FUNÇÕES
# ============================================================

mostrar_intro() {
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
}

verificar_root() {
    if (( UID > 0 )); then
        echo -e "${red}Entre com usuario ROOT... ${cor}"
        exit 1
    fi
}

verificar_foremost() {
    if ! type -p foremost >/dev/null; then
        echo -e "${green}INSTALANDO FOREMOST... ${cor}"
        apt install foremost
    fi
}

listar_dispositivos() {
    local listagem
    listagem=$(fdisk -l | grep -A1000 "Boot")

    echo -e "${green}Listagem dos dispositivos conectados: \n ${cor}"

    if [[ -z $listagem ]]; then
        echo -e "${red}INSIRA DISPOSITIVO USB E TENTE NOVAMENTE ${cor}"
        exit 1
    fi

    echo -e "${purple}${listagem} ${cor}"

    read -s -p "Aperte ENTER para continuar..." conn
    echo " "
    echo " "
}

solicitar_dados() {
    # TIPOS DE ARQUIVOS
    read -p "Tipos/extensões de arquivos (separados por virgula,) all para todos: " formato
    sleep 1s

    # LOCAL DO DISPOSITIVO
    read -e -p "Local do dispositivo (ex: /dev/sdb): " disp
    echo ""
}

recuperar_arquivos() {
    # CRIAR DIRETÓRIO VAZIO PARA ARMAZENAR ARQUIVOS
    bk="backup_$(date +%H%M%S_%d%m)"

    echo -e "${green}Foi gerada uma pasta de nome DIA e HORA no diretório atual... ${cor}"
    sleep 1s
    echo ""

    sleep 2s
    echo -e "${orange}RECUPERANDO ARQUIVOS ${formato} ... ${cor}"
    sleep 2s

    # INICIANDO FOREMOST E A MAGICA ACONTECENDO
    if ! foremost -v -t "$formato" -o "$bk" "$disp" &>/dev/null; then
        echo -e "${red}ERRO ao executar o foremost. Verifique o dispositivo e o formato informados. ${cor}"
        exit 1
    fi
}

mostrar_final() {
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
}

# ============================================================
# PRINCIPAL
# ============================================================

main() {
    mostrar_intro
    verificar_root
    verificar_foremost
    listar_dispositivos
    solicitar_dados
    recuperar_arquivos
    mostrar_final
}

main "$@"
