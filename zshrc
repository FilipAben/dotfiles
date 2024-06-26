export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh
export EDITOR='/opt/homebrew/bin/nvim'
alias v="nvim"
alias vf="fzf --bind 'enter:become(nvim {})'"
alias f="fzf"


# bun completions
[ -s "/Users/filip/.bun/_bun" ] && source "/Users/filip/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$BUN_INSTALL/bin:$PATH
eval "$(rbenv init - zsh)"
eval "$(direnv hook zsh)"
