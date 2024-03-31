# dotfiles

## Neovim Stow Command
stow --dir=nvim/ --target=/home/garrett/.config/nvim .

## Run Deez

### TMUX
prefix + I to install plugins

### Resurrecting TMUX
`cp ./tmux_layouts/tmux_resurrect_master.txt ~/.local/share/tmux/resurrect`

symlink last to master

`ln -sfn last tmux_resurrect_master.txt`

restore with prefix + ctrl-S

### LSP Install within nvim
:Mason

marksman
elixir_lsp
gopls

### Treesitter Commands within nvim
:TSInstall 

markdown
elixir
go

## Dependencies
bat
zsh
delta

