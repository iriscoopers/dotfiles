#!/usr/bin/env zsh

echo "Starting installation"

echo "Installing Ohmyzsh"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Installing packages"

brew install ruby bundler rbenv vim tmux fzf ripgrep --HEAD universal-ctags/universal-ctags/universal-ctags

echo "Installing Vundle"

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

echo "Installing Powerline fonts"
git clone https://github.com/powerline/fonts.git --depth=1

echo "Create symlinks"

FOLDERS="ack,git,shell,tmux,vim"

DOT_FILES=$HOME/dotfiles

for folder in $(echo $FOLDERS | sed "s/,/ /g")
do
  ln -s ~/dotfiles/$folder/.* $HOME
done

ln -s ~/dotfiles/git/git_template ~/.git_template


echo "Set global gitignore"
git config --global core.excludesfile ~/.gitignore
