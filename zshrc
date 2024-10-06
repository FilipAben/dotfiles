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
alias c="cd \$(fd -t directory -H . $HOME| fzf)"
alias dou="docker compose up -d"
alias dod="docker compose down"
alias cn="vim ~/Notes/daily/\$(date +%Y-%m-%d).md"
alias sn="vim \$(fzf --walker-root=/home/filip/Notes/)"

# bun completions
[ -s "/Users/filip/.bun/_bun" ] && source "/Users/filip/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$BUN_INSTALL/bin:$PATH:$HOME/go/bin

# FZF config
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi
source <(fzf --zsh)

# rbenv config
eval "$(rbenv init - zsh)"

## VI mode config for zsh
bindkey -v
export KEYTIMEOUT=1
# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[2 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[6 q'
  fi
}
zle -N zle-keymap-select
echo -ne '\e[6 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[6 q' ;} # Use beam shape cursor for each new prompt.
export VI_MODE_SET_CURSOR=true
