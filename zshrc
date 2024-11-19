export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh
export EDITOR='/usr/bin/nvim'
export BAT_THEME="gruvbox-dark"
export PATH=${PATH}:${HOME}/.fly/bin:${HOME}/.local/bin

alias v="nvim"
alias vim="nvim"
alias ff="rg --line-number --with-filename . --field-match-separator ' ' | fzf --preview \"bat --color=always {1} --highlight-line {2}\" --preview-window ~8,+{2}-5 --bind 'enter:become(nvim +{2} {1})'"
alias c="cd \$(fd -t directory -H . $HOME| fzf)"
alias dou="docker compose up -d"
alias dod="docker compose down"
alias cn="vim ~/Notes/daily/\$(date +%Y-%m-%d).md"
alias sn="vim +\"cd ~/Notes\" +\"FzfLua files\""
alias vpnup="sudo gpclient connect -u faben --as-gateway devgtw3.isabelcorp.be"
alias v="vim +\"FzfLua files\""
fzf-git-branch() {
    git rev-parse HEAD > /dev/null 2>&1 || return

    git branch --color=always --all --sort=-committerdate |
        grep -v HEAD |
        fzf --height 50% --ansi --no-multi --preview-window right:65% \
            --preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' |
        sed "s/.* //"
}

fzf-git-checkout() {
    git rev-parse HEAD > /dev/null 2>&1 || return

    local branch

    branch=$(fzf-git-branch)
    if [[ "$branch" = "" ]]; then
        echo "No branch selected."
        return
    fi

    # If branch name starts with 'remotes/' then it is a remote branch. By
    # using --track and a remote branch name, it is the same as:
    # git checkout -b branchName --track origin/branchName
    if [[ "$branch" = 'remotes/'* ]]; then
        git checkout --track $branch
    else
        git checkout $branch;
    fi
}

alias gb='fzf-git-branch'
alias gco='fzf-git-checkout'

# fzf config
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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
