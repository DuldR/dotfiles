# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"
# ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git asdf direnv fzf)

source $ZSH/oh-my-zsh.sh
alias bda='bin/dev/audit'
alias bdt='bin/dev/test'
alias bdu='bin/dev/update'
alias bdf='bin/dev/format --all'
alias rm='rm -i'
alias cat='bat'

DENO_INSTALL="/Users/gjulaka/.deno"

PROMPT_EOL_MARK=''

export ASDF_DATA_DIR=$HOME/.asdf

export PATH="$ASDF_DATA_DIR/shims:$PATH"
export PATH="$PATH:/opt/nvim-linux64/bin"
export PATH="$DENO_INSTALL/bin:$PATH"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:"/usr/local/lib/node_modules/node/bin"";
export PATH=$PATH:~/.local/bin

export ELIXIR_ERL_OPTIONS="-kernel shell_history enabled"
export BAT_THEME="gruvbox-dark"
export GIT_MIT_AUTHORS_TIMEOUT="10080"
export EDITOR="nvim"


# eval "$(direnv hook zsh)"
eval "$(atuin init zsh --disable-up-arrow)"
eval "$(zoxide init zsh)"
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
