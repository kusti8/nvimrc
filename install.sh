#!/bin/bash

# set -eE -o functrace
# failure() {
#   local lineno=$1
#   local msg=$2
#   echo "Failed at $lineno: $msg"
# }
# trap 'failure ${LINENO} "$BASH_COMMAND"' ERR
shopt -s extglob

RELEASE_URL="https://github.com/kusti8/nvimrc/releases/download/v0.0.1"
extensions="coc-clangd coc-pyright"

checkCommand () {
    if ! command -v $1 &> /dev/null
    then
        echo "$1 could not be found"
        exit
    fi
}

addIfNotExist () {
    isInFile=$(cat $2 | grep -c "$1" || true)
    if [[ $isInFile -eq 0 ]]; then
        echo "$1" >> "$2"
    fi
}

handleFuse () {
    pushd $HOME/bin
    ./$1 --appimage-extract &> /dev/null
    rm -rf "$1-root"
    mv squashfs-root "$1-root/"
    rm ./$1
    ln -s $(pwd)/"$1-root"/usr/bin/$1 "$(pwd)/$1" 
    popd
}

checkCommand curl
checkCommand git
checkCommand unzip

HAS_FUSE=1
if ! command -v fusermount &> /dev/null
then
    HAS_FUSE=0
    echo "Proceding without fuse"
fi


mkdir -p $HOME/.config/nvim
cp -r ./!(.git) $HOME/.config/nvim

mkdir -p $HOME/bin
if [[ $PATH == ?(*:)$HOME/bin?(:*) ]]; then
  echo "PATH already contains bin"
else
    echo "export PATH=$HOME/bin:\$PATH" >> $HOME/.bashrc
fi

curl -fLo $HOME/bin/nvim $RELEASE_URL/nvim.appimage
chmod +x $HOME/bin/nvim
addIfNotExist "alias vim='nvim'" "$HOME/.bashrc"
echo $HAS_FUSE
if [ $HAS_FUSE -eq 0 ]; then
    handleFuse nvim
fi

curl -fLo $HOME/bin/tmux $RELEASE_URL/tmux.appimage
chmod +x $HOME/bin/tmux
ln -s $HOME/.config/nvim/.tmux.conf $HOME/.tmux.conf
lang=$(locale | grep LANGUAGE | cut -d= -f2 | cut -d_ -f1)
if (echo $lang | grep -iqF utf-8) || (echo $lang | grep -iqF utf8); then
    echo "Already has utf8"
else
    addIfNotExist 'export LANG="C.utf8"' "$HOME/.bashrc"
    addIfNotExist 'export LC_ALL="C.utf8"' "$HOME/.bashrc"
fi
if [ $HAS_FUSE -eq 0 ]; then
    handleFuse tmux
    addIfNotExist "alias tmux='TERMINFO=$HOME/bin/tmux-root/usr/lib/terminfo tmux'" "$HOME/.bashrc"
fi

if [ -d $HOME/.fzf ]; then
    rm -rf $HOME/.fzf
fi
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install --all
source ~/.fzf.bash

curl -fLo $HOME/bin/rg $RELEASE_URL/rg
chmod +x $HOME/bin/rg

if [ ! -d $HOME/.nvm ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
fi
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"  # This loads nvm
nvm install --no-progress node
nvm use node
npm i -g yarn

if [ ! -f "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" ]; then
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
fi

~/bin/nvim --headless +PlugInstall +qall
~/bin/nvim --headless --headless +"CocInstall -sync $extensions|qa"

curl -fLo $HOME/bin/oh-my-posh https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64
chmod +x $HOME/bin/oh-my-posh
mkdir -p $HOME/.poshthemes
curl -fLo $HOME/.poshthemes/themes.zip https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip
unzip -o -q $HOME/.poshthemes/themes.zip -d $HOME/.poshthemes
chmod u+rw $HOME/.poshthemes/*.json
rm $HOME/.poshthemes/themes.zip

addIfNotExist "source $HOME/.config/nvim/powerline.bash" "$HOME/.bashrc"

yarn cache clean

echo "Now run source ~/.bashrc"
