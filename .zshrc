ZSH_DISABLE_COMPFIX=true
# Path to your oh-my-zsh installation.
export ZSH=/Users/iriskuipers/.oh-my-zsh

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

# User configuration
export ES_HOME="/usr/local/Cellar/elasticsearch-1.7.5"
export JAVA_HOME="/usr/local/opt/openjdk"
# export JAVA_HOME="/Library/Java/JavaVirtualMachines/temurin-19.jdk/Contents/Home"
export PATH="$HOME/.rbenv/shims:$HOME/.rbenv/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.local/bin:$ES_HOME/bin:$JAVA_HOME"
export PATH=$PATH:$HOME/sources/go/bin
export PATH=$PATH:/Library/PostgreSQL/9.4/bin
export GOPATH="$HOME/sources/go"

# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
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
alias stu="vim ~/standup.md"
alias fb="vim ~/feedback.md"

# Edit files
alias zshrc="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias vimrc="vim ~/.vimrc"
alias gitconfig="vim ~/.gitconfig"

# Git
alias gmu="gl && if [ -f Gemfile.lock ]; then bundle _$(grep -A 1 "BUNDLED WITH" Gemfile.lock | grep -v "BUNDLED WITH" | awk '{$1=$1};1')_ install && be rake db:migrate; fi && if [ -f yarn.lock ]; then yarn; fi"
alias gcb="git cb"
alias gcba="git cba"
alias gclean="git cl"

# AWS
#alias connect_one="one && AWS_PROFILE=springest script/ec2ssh"
#alias connect_st="backend && AWS_PROFILE=studytube ~/studytube/connect.sh"

# Docker
alias srest="./gradlew :server:builddockerimage && docker-compose up"
#
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

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Rbenv
eval export PATH="/Users/irisbune/.rbenv/shims:${PATH}"
command rbenv rehash 2>/dev/null
rbenv() {
  local command
  command="$1"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash|shell)
    eval "$(rbenv "sh-$command" "$@")";;
  *)
    command rbenv "$command" "$@";;
  esac
}
eval "$(rbenv init -)"

#Postgresql
export PATH="/usr/local/opt/postgresql@11/bin:$PATH"
export GPG_TTY=$(tty)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
eval "$(rbenv init -)"
