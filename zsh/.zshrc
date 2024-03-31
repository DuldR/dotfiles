### P10k Config - Must be at top
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### Aliases
alias bda='bin/dev/audit'
alias bdt='bin/dev/test'
alias bdu='bin/dev/update'
alias rm='rm -i'
alias rmrf='rm -rfi'

### ZSH Config
source $ZSH/oh-my-zsh.sh
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git asdf direnv zsh-autosuggestions)
PROMPT_EOL_MARK=''

### Path Stuffs
export PATH="$PATH:"/usr/local/lib/node_modules/node/bin"";
export PATH=$PATH:~/.local/bin
export PATH=$PATH:$HOME/.tmux/plugins/tmuxifier/bin

# Misc Exports
export ELIXIR_ERL_OPTIONS="-kernel shell_history enabled"
export EDITOR="nvim"
export BAT_THEME="gruvbox-dark"

# Evals
eval "$(tmuxifier init -)"
eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"

# Final p10k eval, must be at the bottom
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
