#!/usr/bin/env zsh

echo "Starting installation\n\n"

echo "Create symlinks\n\n"

FOLDERS="ack,shell,tmux,vim"

DOT_FILES=$HOME/dotfiles

for folder in $(echo $FOLDERS | sed "s/,/ /g") # Regex: replace ',' with a space
do
  ln -s ~/dotfiles/$folder/.* $HOME
done

# Special handling for Neovim config
# Ensure the .config/nvim directory exists
mkdir -p $HOME/.config/nvim

# Create symlink for Neovim config
ln -s $DOT_FILES/config/nvim/init.vim $HOME/.config/nvim/init.vim

# Copy and symlink git stuff
cp ~/dotfiles/git/.gitconfig ~

ln -s ~/dotfiles/git/.gitignore $HOME
ln -s ~/dotfiles/git/git_template $HOME/.git_template

echo "Setting global gitignore\n\n"
git config --global core.excludesfile ~/.gitignore

# Reinstantiate the shell to load changes
exec $SHELL

echo "Installing Ohmyzsh\n\n"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Revert the name change of our zshrc done by Ohmyzsh
rm $HOME/.zshrc
mv $HOME/.zshrc.pre-oh-my-zsh $HOME/.zshrc

# Reinstantiate the shell to load changes
exec $SHELL

if [[ $(command -v brew) == "" ]]; then
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Updating Homebrew"
  brew update
fi

echo "Installing cask\n\n"
brew install cask

# Reinstantiate the shell to load changes
exec $SHELL

echo "Installing packages\n\n"
brew install ruby rbenv vim nvim tmux fzf ripgrep --HEAD universal-ctags/universal-ctags/universal-ctags

echo "What ruby version would you like to install?"
echo "Available versions are:"
rbenv install -l

read rv

print "Installing ruby version $rv \n\n"
rbenv install $rv

rbenv global $rv
rbenv rehash

# Reinstantiate the shell to load changes
exec $SHELL

print "Installing bundler\n\n"
gem install bundler

print "Installing tmuxinator\n\n"
gem install tmuxinator

echo "Installing vim-plug\n\n"

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Installing Powerline fonts\n\n"
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts && ./install.sh

echo "Installed, now removing the fonts folder\n\n"
cd ..
rm -rf fonts

# Reinstantiate the shell to load changes
exec $SHELL

echo "====== DONE :) ======="
