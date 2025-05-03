# GitHub specific configurations and aliases
alias ghpr='gh pr create'
alias ghprv='gh pr view'
alias ghprl='gh pr list'
alias ghi='gh issue'
alias ghil='gh issue list'
alias ghic='gh issue create'

# Set GitHub CLI editor if not already set
if [ -z "$GH_EDITOR" ]; then
  export GH_EDITOR='vim'
fi 