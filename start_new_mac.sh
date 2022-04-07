#!/bin/bash

xcode-select --install

echo "instale o xcode e depois digite <enter> para continuar"
echo "aguardando instalacao"

read x

pyenv() {
    ENV_NAME=$1
    VIRTUALENV_DIR=~/python
    ENV_DIRNAME="$VIRTUALENV_DIR/$ENV_NAME"
    cd $VIRTUALENV_DIR
    if [ ! -d "$ENV_DIRNAME" ]; then
        python3 -m venv "$ENV_NAME"
    fi
    source $ENV_NAME/bin/activate
}


# cria diretorio para guardar os venv python
if [ ! -d ~/python ]
then
    mkdir python
fi

# instala ansible
pyenv ansible
pip install --upgrade pip
pip3 install ansible

# cria diretorio para guardar projetos git
if [ ! -d ~/git ]
then
    mkdir ~/git
fi

# clona/atualiza git mac-dev
cd ~/git
if [ ! -d mac-dev-playbook ]
then
  git clone https://github.com/geerlingguy/mac-dev-playbook.git
else
  cd mac-dev-playbook
  git pull
fi

cd ~/git/mac-dev-playbook

ansible-galaxy install -r requirements.yml

if [ -f ~/default.config.yml ]
then
    echo "movendo arquivo default.config.yml para a receita"
    mv ~/default.config.yml .
fi

ansible-playbook --ask-become-pass main.yml

echo "para rodar novamente, use ansible-playbook --ask-become-pass main.yml"


