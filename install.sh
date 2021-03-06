#!/bin/bash

# set -eE -o functrace
# failure() {
#   local lineno=$1
#   local msg=$2
#   echo "Failed at $lineno: $msg"
# }
# trap 'failure ${LINENO} "$BASH_COMMAND"' ERR
set -e
shopt -s extglob
shopt -s dotglob
shopt -s expand_aliases

RELEASE_URL="https://github.com/kusti8/nvimrc/releases/download/v0.0.1"
extensions="coc-clangd coc-pyright coc-json coc-docker coc-sh"

checkCommand () {
    if ! command -v $1 &> /dev/null
    then
        echo "$1 could not be found"
        exit
    fi
}

checkCCompilerExists() {
    if ! command -v gcc &> /dev/null
    then
        if ! command -v clang &> /dev/null
        then
            echo "C Compiler could not be found"
            exit
        fi
    fi
}

checkCppCompilerExists() {
    if ! command -v g++ &> /dev/null
    then
        if ! command -v clang++ &> /dev/null
        then
            echo "C++ Compiler could not be found"
            exit
        fi
    fi
}

checkIfInUse () {
    # Check if a file is currently being executed
    if [ -n "$(lsof -t $1)" ]
    then
        echo "File $1 is in use"
        exit
    fi
}

addIfNotExist () {
    isInFile=$(cat $2 | grep -c "$1" || true)
    if [[ $isInFile -eq 0 ]]; then
        echo "$1" >> "$2"
    fi
}

copyFiles () {
    mkdir -p $HOME/.config/nvim
    find . -type f -not -path '*/.git/*' -exec cp '{}' "$HOME/.config/nvim/{}" \;
}

handleFuse () {
    cp $HOME/bin/$1 /tmp/$1
    pushd /tmp
    ./$1 --appimage-extract &> /dev/null
    rm -rf "$1-root"
    mv squashfs-root "$1-root/"
    rm ./$1
    cp -r "$1-root/" "$HOME/bin/$1-root/"
    popd
    pushd $HOME/bin
    rm -rf ./$1
    ln -s $(pwd)/"$1-root"/usr/bin/$1 "$(pwd)/$1" 
    popd
}

setAliases () {
    # ALIASES
    addIfNotExist "alias lg='lazygit'" "$HOME/.bashrc"
    addIfNotExist "alias tm='tmux new -t'" "$HOME/.bashrc"
    addIfNotExist "alias tma='tmux attach -d -t'" "$HOME/.bashrc"
    addIfNotExist "alias tml='tmux list-sessions'" "$HOME/.bashrc"
}

prepHomeBin () {
    mkdir -p $HOME/bin
    if [[ $PATH == "$HOME/bin?(:*)" ]]; then
    echo "PATH already contains bin and is first"
    else
        echo "export PATH=$HOME/bin:\$PATH" >> $HOME/.bashrc
    fi
    export PATH=$HOME/bin:$PATH
}

setUtf8() {
    lang=$(locale | grep LANG | cut -d= -f2)
    if (echo $lang | grep -iqF utf-8) || (echo $lang | grep -iqF utf8); then
        echo "Already has utf8"
    else
        addIfNotExist 'export LANG="C.utf8"' "$HOME/.bashrc"
        addIfNotExist 'export LC_ALL="C.utf8"' "$HOME/.bashrc"
    fi
}

queryPackageInstallMethod() {
    echo "Manual method is recommended for linux 64bit, brew sudo
    for mac or where you have sudo access, and brew nonsudo as a last resort"
    read -p "Install method (m)anual/(b)rew sudo/brew (n)onsudo:" method
    
    if [[ "$method" == "m" ]]; then
        installPackagesManual
    elif [[ "$method" == "b" ]]; then
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        addIfNotExist 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' $HOME/.bashrc
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        installPackagesHomebrew
    elif [[ "$method" == "n" ]]; then
        checkCppCompilerExists
        git clone https://github.com/Homebrew/brew ~/.brew
        eval "$(~/.brew/bin/brew shellenv)"
        addIfNotExist 'eval "$(~/.brew/bin/brew shellenv)"' "$HOME/.bashrc"
        brew update --force --quiet
        checkCommand g++
        installPackagesHomebrew
    else
        echo "Invalid method"
        exit 1
    fi
}

installPackagesHomebrew() {
    brew install neovim
    brew install tmux
    brew install rg
    brew install lazygit
    brew install fd
    brew install oh-my-posh
}

installPackagesManual() {
    # nvim
    rm -rf $HOME/bin/nvim $HOME/bin/nvim-root
    curl -fLo $HOME/bin/nvim $RELEASE_URL/nvim.appimage
    chmod +x $HOME/bin/nvim

    # tmux
    rm -rf $HOME/bin/tmux $HOME/bin/tmux-root
    curl -fLo $HOME/bin/tmux $RELEASE_URL/tmux.appimage
    chmod +x $HOME/bin/tmux

    #ripgrep
    curl -fLo $HOME/bin/rg $RELEASE_URL/rg
    chmod +x $HOME/bin/rg

    #lazygit
    curl -fLo $HOME/bin/lazygit $RELEASE_URL/lazygit
    chmod +x $HOME/bin/lazygit

    #fd
    curl -fLo $HOME/bin/fd $RELEASE_URL/fd
    chmod +x $HOME/bin/fd

    #oh-my-posh
    curl -fLo $HOME/bin/oh-my-posh https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64
    chmod +x $HOME/bin/oh-my-posh

    if [ $HAS_FUSE -eq 0 ]; then
        handleFuse nvim
        handleFuse tmux
        addIfNotExist "alias tmux='TERMINFO=$HOME/bin/tmux-root/usr/lib/terminfo tmux'" "$HOME/.bashrc"
        export TERMINFO=$HOME/bin/tmux-root/usr/lib/terminfo
    fi
}

installNvim () {
    addIfNotExist "alias vim='nvim'" "$HOME/.bashrc"
}

installTmux () {
    rm -f $HOME/.tmux.conf
    ln -sf $HOME/.config/nvim/.tmux.conf $HOME/.tmux.conf
    rm -rf $HOME/.tmux/plugins/*
    git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
    ~/.tmux/plugins/tpm/scripts/install_plugins.sh
    ~/.tmux/plugins/tpm/scripts/update_plugin.sh all
}

installFzf () {
    if [ -d $HOME/.fzf ]; then
        rm -rf $HOME/.fzf
    fi
    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
    $HOME/.fzf/install --all
    source ~/.fzf.bash
}

installRg () {
    echo "Installed rg"
}

installLazygit () {
    mkdir -p $HOME/.config/lazygit
    ln -sf $HOME/.config/nvim/config.yml $HOME/.config/lazygit/config.yml
}

installFd () {
    echo "Installed fd"
}

installNode () {
    if [ ! -d $HOME/.nvm ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    fi
    export NVM_DIR="$HOME/.nvm"
    source "$NVM_DIR/nvm.sh"  # This loads nvm
    nvm install --no-progress --default v16.15.0
    nvm use v16.15.0
    npm i -g yarn
}

installVimPlug () {
    rm -rf $HOME/.local/share/nvim/plugged
    if [ ! -f "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" ]; then
        sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    fi

    nvim --headless +PlugInstall +qall
    nvim --headless --headless +"CocInstall -sync $extensions|qa"
}

installOhMyPosh () {
    mkdir -p $HOME/.poshthemes
    curl -fLo $HOME/.poshthemes/themes.tar.gz $RELEASE_URL/themes.tar.gz
    tar xf $HOME/.poshthemes/themes.tar.gz -C $HOME/.poshthemes
    chmod u+rw $HOME/.poshthemes/*.json
    rm $HOME/.poshthemes/themes.tar.gz

    addIfNotExist "source $HOME/.config/nvim/powerline.bash" "$HOME/.bashrc"
}


checkCommand curl
checkCommand git
checkCommand make
checkCCompilerExists

if [ $# -eq 1 ]; then
    if [ $1 == "--copy" ]; then
        copyFiles
        exit 0
    fi
fi

checkIfInUse "$HOME/bin/tmux"
checkIfInUse "$HOME/bin/nvim"

HAS_FUSE=0
# if ! command -v fusermount &> /dev/null
# then
#     HAS_FUSE=0
#     echo "Proceding without fuse"
# fi

# Copy config in
copyFiles

# Set bashrc if its not set in bash_profile
if [ ! -f $HOME/.bash_profile ]; then
    echo ". \$HOME/.bashrc" >> $HOME/.bash_profile
fi


setAliases
prepHomeBin
setUtf8

queryPackageInstallMethod
installNvim
installTmux
installFzf
installLazygit
installFd
installNode
installVimPlug
installOhMyPosh

yarn cache clean
npm cache clean --force

echo "Now run source ~/.bashrc"
echo "Also remember to do :Copilot setup"
