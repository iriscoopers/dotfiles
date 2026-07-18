#!/usr/bin/env zsh

echo "Starting installation\n\n"

echo "Installing Ohmyzsh\n\n"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

if [[ $(command -v brew) == "" ]]; then
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Updating Homebrew"
  brew update
fi

source $HOME/.zshrc

echo "Create symlinks\n\n"

# All symlinking lives in scripts/update.sh, which is also safe to re-run later
# to pick up new files and drop obsolete ones. Any .zshrc oh-my-zsh just wrote
# is moved aside to .zshrc.bak by that script.
DOT_FILES="${0:A:h}"
"$DOT_FILES/scripts/update.sh"

# .gitconfig is copied rather than symlinked so machine-local settings (user
# email, signing keys) never end up as changes in the repo. update.sh knows to
# leave it alone.
if [[ -f $HOME/.gitconfig ]]; then
  echo "Keeping existing ~/.gitconfig\n\n"
else
  cp "$DOT_FILES/git/.gitconfig" $HOME
fi

echo "Setting global gitignore\n\n"
git config --global core.excludesfile ~/.gitignore

echo "Installing cask\n\n"
brew install cask

echo "Installing packages\n\n"
brew install ruby rbenv vim nvim tmux fzf ripgrep

# .NET SDK for C# development (Roslyn LSP requires `dotnet` on PATH)
brew install dotnet

# Reinstantiate the shell to load changes
source $HOME/.zshrc

echo "What ruby version would you like to install?"
echo "Available versions are:"
rbenv install -l

read rv

print "Installing ruby version $rv \n\n"
rbenv install $rv

rbenv global $rv
rbenv rehash

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

echo "============ Done installing ============"

# Reinstantiate the shell to load changes
source $HOME/.zshrc

echo "====== DONE :) ======="
