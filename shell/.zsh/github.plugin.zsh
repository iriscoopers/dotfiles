# GitHub specific configurations and aliases
alias ghpr='gh pr create'
alias ghprv='gh pr view'
alias ghprl='gh pr list'
alias ghi='gh issue'
alias ghil='gh issue list'
alias ghic='gh issue create'

# Set GitHub CLI editor if not already set
if [ -z "$GH_EDITOR" ]; then
  export GH_EDITOR='nvim'
fi 

gfzf() {
  gh pr list -S $1 | fzf | awk '{print $1}'	fi 
}	

# $1 = db action; setup or migrate will become db:setup or db:migrate	
gmu() {	
  dbaction="db:$1"	

  gl && [ -f Gemfile.lock ] && bundle _$(grep -A 1 "BUNDLED WITH" Gemfile.lock | grep -v "BUNDLED WITH" | awk '{$1=$1};1')_ install && be rails $dbaction && [ -f yarn.lock ] && yarn	
}	
