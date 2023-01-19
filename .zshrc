# ZSH_DISABLE_COMPFIX=true
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="robbyrussell"
ZSH_THEME="miloshadzic"
# ZSH_THEME="avit"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git bundler macos rake ruby brew vundle)

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
#if [[ -n $SSH_CONNECTION ]]; then
#  export EDITOR='vim'
#else
#  export EDITOR='mvim'
#fi
export EDITOR='vim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

alias sc="source ~/.zshrc"

# Navigation
alias stunt="cd ~/projects/stunt"
alias dotfiles="cd ~/dotfiles"
alias tebi="cd ~/projects/tebi"
alias tebis="cd ~/projects/tebi_scripts"

# Edit files
alias zshrc="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias vimrc="vim ~/.vimrc"
alias gitconfig="vim ~/.gitconfig"
alias stu="vim ~/standup.md"
alias fb="vim ~/feedback.md"

# Git
# git pull master ruby
alias gmur="gl && if [ -f Gemfile.lock ]; then bundle _$(grep -A 1 "BUNDLED WITH" Gemfile.lock | grep -v "BUNDLED WITH" | awk '{$1=$1};1')_ install && be rake db:migrate; fi && if [ -f yarn.lock ]; then yarn; fi"
# git pull and build Tebi
alias gmut="ggpull && ./gradlew buildDockerImage"
alias gcb="git cb"
alias gcba="git cba"
alias gclean="git cl"

# AWS
#alias connect_one="one && AWS_PROFILE=springest script/ec2ssh"
#alias connect_st="backend && AWS_PROFILE=studytube ~/studytube/connect.sh"

# Docker
alias dcup="docker-compose up"
# Tebi
alias sreb="./gradlew :server:builddockerimage"
alias breb="./gradlew :backoffice:builddockerimage"
alias ereb="./gradlew :ecomclient:builddockerimage"
alias jsreb="./gradlew :jsapp:builddockerimage"
alias reball="./gradlew buildDockerImage"
alias srest="sreb && dcup"
alias brest="breb && dcup"
alias erest="ereb && dcup"
alias jsrest="jsreb && dcup"
alias restall="reball && dcup"

# Ruby
# Automatically load rbenv
eval "$(rbenv init -)"

#Postgresql
export GPG_TTY=$(tty)

#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

### Tools
# Tmuxinator
alias mux=tmuxinator

# Github PRs
# $1 = action
# $2 = flag
# $3 = search
gprs() {
  zparseopts -E -A opts a: s: f:

  gh pr $opts[-a] $(gfzf $opts[-s]) $opts[-f]
}

gfzf() {
  gh pr list -S $1 | fzf | awk '{print $1}'
}

ctags=/usr/local/bin/ctags

# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

# PATH configuration
export JAVA_HOME=/Applications/Android\ Studio.app/Contents/jre/Contents/Home
export PATH="${JAVA_HOME}/bin/:${PATH}"
