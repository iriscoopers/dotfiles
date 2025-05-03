# Vim aliases and configurations
alias v='vim'
alias vi='vim'
alias nv='nvim'

# Set Vim as default editor if not already set
if [ -z "$EDITOR" ]; then
  export EDITOR='vim'
fi

if [ -z "$VISUAL" ]; then
  export VISUAL='vim'
fi

# Neovim specific settings
if command -v nvim >/dev/null 2>&1; then
  alias vim='nvim'
  export EDITOR='nvim'
  export VISUAL='nvim'
fi 