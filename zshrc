export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh
export EDITOR='/opt/homebrew/bin/nvim'
export FZF_DEFAULT_COMMAND="fd -H"
alias v="nvim"
alias vim="nvim"
alias vf="FZF_DEFAULT_COMMAND=\"fd -H --type file\" fzf --bind 'enter:become(nvim {})'"
alias cf="FZF_DEFAULT_COMMAND=\"fd -H --type directory\" cd \$(fzf)"

alias f="fzf"


# bun completions
[ -s "/Users/filip/.bun/_bun" ] && source "/Users/filip/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$BUN_INSTALL/bin:$PATH
eval "$(rbenv init - zsh)"
eval "$(direnv hook zsh)"
