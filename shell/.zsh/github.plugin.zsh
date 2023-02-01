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
