#!/bin/bash

set -e
set -o pipefail

clear

echo "╔═════════════════════════════╗"
echo "║     Criador de Projetos     ║"
echo "╚═════════════════════════════╝"

echo ""

read -p "Digite o nome do projeto: " projeto

if [[ -z "$projeto" ]]; then 
	echo "O nome não pode estar vazio!"
	exit 1
fi

if [[ -d "$projeto" ]]; then
	echo "O projeto já possuí o mesmo nome nesta pasta!"
	exit 1
fi 

dataDeCriacao=$(date +%d/%m/%Y\ %H:%M:%S)

echo ""

echo "Criando pastas iniciais..."
mkdir "$projeto"
cd "$projeto"

read -p "Digite o nome da pasta para os códigos: " pastaInicial
if [[ -z "$pastaInicial" ]]; then
	pastaInicial="src"
	echo "Definindo como $pastaInicial"
fi
if [[ -d "$pastaInicial" ]]; then
	echo ""
	echo "$pastaInicial já possuí este mesmo nome na pasta $projeto"
	echo ""
else
	mkdir "$pastaInicial"
fi 

read -p "Digite o nome da pasta para as ferramentas do projeto: " pastaUtilidades
if [[ -z "$pastaUtilidades" ]]; then
	pastaUtilidades="util"
	echo "Definindo como $pastaUtilidades"
fi
if [[ -d "$pastaUtilidades" ]]; then
	echo ""
	echo "$pastaUtilidades já possuí este mesmo nome na pasta $projeto"
	echo ""
else
	mkdir "$pastaUtilidades"
fi 
echo "Sucesso ao criar as pastas"

echo ""

read -p "Digite o nome do arquivo para a pasta $projeto: " arquivoPrincipal
echo ""
if [[ -z "$arquivoPrincipal" ]]; then
	echo "O arquivo de $projeto não pode estar vazio!"
	echo "Definindo como Main.java..."
	arquivoPrincipal="Main"
fi

echo ""
read -p "Digite o nome do arquivo para a pasta $pastaUtilidades: " arquivoUtilidades
echo ""
if [[ -z "$arquivoUtilidades" ]]; then
	echo "O arquivo de $pastaUtilidades não pode estar vazio!"
	echo "Definindo como Utilidades.java"
	arquivoUtilidades="Utilidades"
fi

echo ""
read -p "Digite o nome do arquivo para a pasta $pastaInicial: " arquivoInicial
echo ""
if [[ -z "$arquivoInicial" ]]; then
	echo "O arquivo de $pastaInicial não pode estar vazio!"
	echo "Definindo como Codigo.java"
	arquivoInicial="Codigo"
fi
	
echo ""

echo "Criando o arquivo $arquivoPrincipal.java..."
cat << EOF > "$arquivoPrincipal".java
import $pastaInicial.$arquivoInicial;

public class $arquivoPrincipal {
	public static void main(String[] args) {
		new $arquivoInicial();
	}
}
EOF

echo ""

echo "Criando o arquivo de licença..."
echo "1 - MIT"
echo "2 - Apache 2.0"
echo "3 - GPL v3.0"
echo "4 - GPL v2.0"
echo "5 - Nenhuma licença"
read -p "Digite o número da licença desejada: " licenca

case "$licenca" in
    1)
        licenca="mit"
        ;;
    2)
        licenca="apache-2.0"
        ;;
    3)
        licenca="gpl-3.0"
        ;;
    4)
        licenca="gpl-2.0"
        ;;
    5)
        licenca="Nenhuma"
        ;;
    *)
        echo "Erro: Opção inválida"
        licenca="Nenhuma"
        ;;
esac

if [ "$licenca" = "Nenhuma" ]; then
    echo "Nenhuma licença escolhida"
else
    echo "Fazendo o donwload da licença..."
    curl -sL "https://raw.githubusercontent.com/github/choosealicense.com/gh-pages/_licenses/${licenca}.txt" > LICENSE
    
    if [[ -f "LICENSE" && -s "LICENSE" ]]; then
		echo "Arquivo de licença baixado com sucesso"
    else
        echo "Erro: Falha ao baixar a licença."
    fi
fi

echo ""

echo "Criando o arquivo $arquivoInicial.java..."
cd "$pastaInicial"
cat << EOF > "$arquivoInicial".java
package $pastaInicial;

public class $arquivoInicial {
	public $arquivoInicial() {
		System.out.println("Hello World");
	}
}
EOF

echo ""

echo "Criando o arquivo $arquivoUtilidades.java..."
cd ..
cd "$pastaUtilidades"
cat << EOF > "$arquivoUtilidades".java
package $pastaUtilidades;

public class $arquivoUtilidades {
	public $arquivoUtilidades() {
		System.out.println("Utilidades");
	}
}
EOF
cd ..

echo ""

data=$(date +%d/%m/%Y\ %H:%M:%S)
echo "Criando o arquivo VERSOES.md..."
read -p "Digite o nome da primeira versão do projeto: " versao
if [[ -z "$versao" ]]; then
    versao="1.0.0"
fi
read -p "Digite a descrição da versão: " descricaoVersao
if [[ -z "$descricaoVersao" ]]; then
    descricaoVersao="Versão inicial do projeto"
fi

# Cálculo dinâmico para o cabeçalho do VERSOES.md
tituloVersoes="Versões do projeto: $projeto"
tamanhoVersoes=${#tituloVersoes}
larguraVersoes=$(( tamanhoVersoes + 10 ))
linhaVersoes=$(printf '═%.0s' $(seq 1 $larguraVersoes))
espacosVersoes="     "

cat << EOF > VERSOES.md
╔${linhaVersoes}╗
║${espacosVersoes}${tituloVersoes}${espacosVersoes}║
╚${linhaVersoes}╝

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Nome: $projeto
Versão atual: $versao

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Versão - Descrição - Data

$versao - $descricaoVersao - $data
EOF
echo "Sucesso ao criar os arquivos"

echo ""

echo "Criando o arquivo README.md..."
read -p "Digite uma curta descrição do projeto para o arquivo README.md: " descricaoReadme
if [[ -z "$descricaoReadme" ]]; then
    if [[ "$licenca" != "Nenhuma" ]]; then
        descricaoReadme="Olá, este é meu projeto com a licença $licenca e foi criado em $dataDeCriacao"
    else
        descricaoReadme="Olá, este é meu projeto que não possui licença e foi criado em $dataDeCriacao"
    fi
fi

# Cálculo dinâmico para o cabeçalho do README.md
tituloReadme="README de $projeto"
tamanhoReadme=${#tituloReadme}
larguraReadme=$(( tamanhoReadme + 10 ))
linhaReadme=$(printf '═%.0s' $(seq 1 $larguraReadme))
espacosReadme="     "

cat << EOF > README.md
╔${linhaReadme}╗
║${espacosReadme}${tituloReadme}${espacosReadme}║
╚${linhaReadme}╝

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Nome: $projeto
Versão atual: $versao
Desenvolvedor: Desconhecido
Data de criação: $dataDeCriacao

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$descricaoReadme
EOF

echo ""

echo "╔════════════════════════════╗"
echo "║     Informações gerais     ║"
echo "╚════════════════════════════╝"
echo ""
echo "Nome: $projeto"
echo "Licença: $licenca"
echo "Arquivo principal: $arquivoPrincipal"
echo "Versão: $versao"

echo ""

echo "Lembrete! Você pode alterar os resultados manualmente caso necessário"

echo ""

read -p "Pressione ENTER para finalizar..."
