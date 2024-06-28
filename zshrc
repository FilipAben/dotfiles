export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh
export EDITOR='/opt/homebrew/bin/nvim'
export FZF_DEFAULT_OPTS="--walker=file,dir,hidden,follow --walker-skip=.git,node_modules,target,Library"
export BAT_THEME="gruvbox-dark"
alias v="nvim"
alias vim="nvim"
alias ff="rg --line-number --with-filename . --field-match-separator ' ' | fzf --preview \"bat --color=always {1} --highlight-line {2}\" --preview-window ~8,+{2}-5 --bind 'enter:become(nvim +{2} {1})'"
alias c="cd && FZF_DEFAULT_COMMAND=\"fd -t directory -H\" cd \$(fzf)"
alias dou="docker compose up -d"
alias dod="docker compose down"


# bun completions
[ -s "/Users/filip/.bun/_bun" ] && source "/Users/filip/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$BUN_INSTALL/bin:$PATH
eval "$(rbenv init - zsh)"
eval "$(direnv hook zsh)"

# FZF config
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi
source <(fzf --zsh)
