export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh
export EDITOR='/home/linuxbrew/.linuxbrew/bin/nvim'
export FZF_DEFAULT_OPTS="--walker=file,dir,hidden,follow --walker-skip=.git,node_modules,target,Library"
export BAT_THEME="gruvbox-dark"
export PATH=${PATH}:${HOME}/.fly/bin:${HOME}/.local/bin

# bun
export BUN_INSTALL="$HOME/.bun"

# golang config
export GOROOT=/usr/local/go
export GOPATH=$HOME/go

# PATH
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
export PATH=$HOME/bin:/usr/local/bin:$BUN_INSTALL/bin:$PATH:$HOME/go/bin


# ALIASES
alias v="nvim"
alias vim="nvim"
alias frm="fzf | xargs rm"
alias ff="rg --line-number --with-filename . --field-match-separator ' ' | fzf --preview \"bat --color=always {1} --highlight-line {2}\" --preview-window ~8,+{2}-5 --bind 'enter:become(nvim +{2} {1})'"
alias c="cd \$(fd -t directory -H . $HOME| fzf)"
alias dou="docker compose up -d"
alias dod="docker compose down"
alias cn="vim ~/Notes/daily/\$(date +%Y-%m-%d).md"
alias sn="vim +\"cd ~/Notes\" +\"FzfLua files\""
alias vpnup="sudo gpclient connect -u faben --as-gateway devgtw3.isabelcorp.be"
alias v="vim +\"FzfLua files\""

# fzf config
source <(fzf --zsh)

echo -ne '\e[6 q' # Use beam shape cursor on startup.
# preexec() { echo -ne '\e[6 q' ;} # Use beam shape cursor for each new prompt.
# export VI_MODE_SET_CURSOR=true

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# linux homebrew config
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# rbenv config
eval "$(rbenv init - zsh)"
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3)"
