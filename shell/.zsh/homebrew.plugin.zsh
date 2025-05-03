# Homebrew configuration
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

# Homebrew aliases
alias brewup='brew update && brew upgrade && brew cleanup'
alias brewdeps='brew deps --installed'
alias brewleaves='brew leaves' 