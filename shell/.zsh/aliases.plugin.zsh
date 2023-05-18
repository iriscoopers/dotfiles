# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

alias sc="source ~/.zshrc"

# Navigation
alias stunt="cd ~/projects/stunt"
alias dotfiles="cd ~/dotfiles"

# Edit files
alias zshrc="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias vimrc="vim ~/.vimrc"
alias gitconfig="vim ~/.gitconfig"
alias notes="vim ~/projects/rompslomp_notes.md"
alias til="vim ~/blog.md"

# Git
# git pull master ruby
#alias gmu="gl && [ -f Gemfile.lock ] && bundle _$(grep -A 1 "BUNDLED WITH" Gemfile.lock | grep -v "BUNDLED WITH" | awk '{$1=$1};1')_ install && be rake db:migrate && [ -f yarn.lock ] && yarn"

alias gcb="git cb"
alias gcba="git cba"
alias gclean="git cl"

# Rompslomp
#alias rgmu="gmu
