if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git asdf direnv )

source $ZSH/oh-my-zsh.sh
alias bda='bin/dev/audit'
alias bdt='bin/dev/test'
alias bdu='bin/dev/update'
alias bdf='bin/dev/format --all'

PROMPT_EOL_MARK=''
export PATH="$PATH:"/usr/local/lib/node_modules/node/bin"";
export PATH=$PATH:~/.local/bin
export ELIXIR_ERL_OPTIONS="-kernel shell_history enabled"
export BAT_THEME="gruvbox-dark"
eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
