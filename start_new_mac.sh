#!/bin/bash


function check_install_xcode()
{
   chk_code=NOK

   echo "Verificando se o Xcode esta instalado: "

   gcc --version  && chk_code=OK
   
   if [ "$chk_code" == "NOK" ]
   then
      xcode-select --install

      echo "instale o xcode e depois digite <enter> para continuar"
      echo "aguardando instalacao"

      read x
   else
      echo "xcode instalado, continuando..."
   fi
}

function check_install_rosetta()
{
   # esse mac eh ARM?
   arch=`uname -p`

   if [ "$arch" == "arm" ]
   then
	echo "Esse eh um mac com arquitetura ARM, talvez seja necessario instalar o Rosetta"
        sudo  softwareupdate --install-rosetta --agree-to-license
   fi
}

function pyenv() {
    cur_dir=`pwd`
    ENV_NAME=$1
    VIRTUALENV_DIR=~/python
    ENV_DIRNAME="$VIRTUALENV_DIR/$ENV_NAME"
    cd $VIRTUALENV_DIR
    if [ ! -d "$ENV_DIRNAME" ]; then
        python3 -m venv "$ENV_NAME"
    fi
    source $ENV_NAME/bin/activate
    cd $cur_dir
}

function check_install_ansible()
{

   # cria diretorio para guardar os venv python
   if [ ! -d ~/python ]
   then
      mkdir ~/python
   fi

   # instala ansible
   pyenv ansible
   pip install --upgrade pip
   pip3 install ansible
}

function install_ansible_requirements()
{
   echo "Instalando dependencias do ansible"
   ansible-galaxy install -r requirements.yml
}

# main (tipo...)

check_install_xcode
check_install_rosetta
check_install_ansible
echo $(pwd)
install_ansible_requirements

ansible-playbook --ask-become-pass main.yml

echo "para rodar novamente, use ansible-playbook --ask-become-pass main.yml"
echo "mas antes carregue o ambiente do ansible com um source ~/python/ansible/bin/activate"

