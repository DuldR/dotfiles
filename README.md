# Dotfiles

Personal configuration files for development environment.

## 🚀 What's Included

- **Neovim** - Text editor configuration with LSP support
- **Tmux** - Terminal multiplexer with plugin management
- **Zsh** - Shell configuration
- **Git Delta** - Better git diffs
- **Bat** - Cat replacement with syntax highlighting

### Language Support

- **Elixir** - LSP and syntax highlighting
- **Go** - LSP and syntax highlighting
- **Markdown** - LSP and syntax highlighting

## 📋 Prerequisites

- Git
- A supported Linux distribution (Arch, Manjaro, Ubuntu, Debian)
- sudo/root access for package installation

## 🛠️ Installation

### Quick Install

Clone the repository and run the installation script:

```bash
git clone https://github.com/DuldR/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh
./install.sh
```

The script will automatically:
- Detect your Linux distribution
- Install GNU Stow and other dependencies
- Link all configuration files to their proper locations
- Set up Tmux Plugin Manager (TPM)
- Configure tmux resurrect

### Manual Installation

If you prefer to install manually:

1. Install GNU Stow:
   ```bash
   # Arch/Manjaro
   sudo pacman -S stow
   
   # Ubuntu/Debian
   sudo apt install stow
   ```

2. Stow the configurations you want:
   ```bash
   stow nvim
   stow tmux
   stow zsh
   ```

3. Install Tmux Plugin Manager:
   ```bash
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
   ```

4. Setup tmux resurrect:
   ```bash
   mkdir -p ~/.local/share/tmux/resurrect
   cp tmux_layouts/tmux_resurrect_master.txt ~/.local/share/tmux/resurrect/
   ln -sfn ~/.local/share/tmux/resurrect/tmux_resurrect_master.txt ~/.local/share/tmux/resurrect/last
   ```

## 🔧 Post-Installation

### Neovim Setup

After first launch of Neovim:

1. Install LSP servers via Mason:
   ```vim
   :Mason
   ```
   Then install:
   - `marksman` (Markdown LSP)
   - `elixir_lsp`
   - `gopls`

2. Install Treesitter parsers:
   ```vim
   :TSInstall markdown elixir go
   ```

### Tmux Setup

1. Launch tmux:
   ```bash
   tmux
   ```

2. Install plugins by pressing `prefix + I` (default prefix is `Ctrl-b`)

3. Restore saved session with `prefix + Ctrl-r`

## 🔄 Updating

To update your dotfiles:

```bash
cd ~/.dotfiles
git pull
./install.sh  # Re-run to update any new configurations
```

## 📝 Notes

- The installation script uses GNU Stow for symlink management
- Configurations are linked, not copied, so changes sync with the repo
- Some configurations may require additional setup specific to your workflow
