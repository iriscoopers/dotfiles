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

# $1 = db action; setup or migrate will become db:setup or db:migrate
gmu() {
  dbaction="db:$1"

  gl && [ -f Gemfile.lock ] && bundle _$(grep -A 1 "BUNDLED WITH" Gemfile.lock | grep -v "BUNDLED WITH" | awk '{$1=$1};1')_ install && be rails $dbaction && [ -f yarn.lock ] && yarn
}
