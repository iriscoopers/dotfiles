#!/usr/bin/env zsh

echo "Starting installation\n\n"

echo "Installing Ohmyzsh\n\n"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Installing cask\n\n"
brew install cask

echo "Installing packages\n\n"

brew install ruby rbenv vim tmux fzf ripgrep --HEAD universal-ctags/universal-ctags/universal-ctags

rbenv rehash

echo "What ruby version would you like to install?"
echo "Available versions are:"
rbenv install -l

read rv

print "Installing ruby version $rv \n\n"
rbenv install $rv

print "Installing bundler\n\n"
gem install bundler

print "Installing tmuxinator\n\n"
gem install tmuxinator

echo "Installing Vundle\n\n"

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

echo "Installing Powerline fonts\n\n"
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts && ./install.sh

echo "Installed, now removing the fonts folder\n\n"
cd ..
rm -rf fonts

echo "Create symlinks\n\n"

FOLDERS="ack,git,shell,tmux,vim"

DOT_FILES=$HOME/dotfiles

for folder in $(echo $FOLDERS | sed "s/,/ /g")
do
  ln -s ~/dotfiles/$folder/.* $HOME
done

ln -s ~/dotfiles/git/git_template ~

echo "Setting global gitignore\n\n"
git config --global core.excludesfile ~/.gitignore

echo "====== DONE :) ======="
