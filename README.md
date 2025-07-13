# dotfiles

## Neovim Stow Command
stow --dir=nvim/ --target=/home/garrett/.config/nvim .

## Run Deez

### TMUX

# Install Tmux Plugin
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Run the install
prefix + I to install plugins

### Resurrecting TMUX
`cp ./tmux_layouts/tmux_resurrect_master.txt ~/.local/share/tmux/resurrect`

symlink last to master

`ln -sfn ~/.local/share/tmux/resurrect/tmux_resurrect_master.txt ~/.local/share/tmux/resurrect/last`

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

