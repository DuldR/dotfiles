#!/bin/bash

# Dotfiles Installation Script
# Automatically sets up nvim, tmux, zsh, and other configurations

set -e  # Exit on error

echo "=================================="
echo "Dotfiles Installation"
echo "=================================="
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}→ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_section() {
    echo -e "${BLUE}━━━ $1 ━━━${NC}"
}

# Detect Linux distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        DISTRO_LIKE=$ID_LIKE
    elif [ -f /etc/arch-release ]; then
        DISTRO="arch"
    else
        print_error "Cannot detect Linux distribution"
        exit 1
    fi

    # Normalize distro detection
    case $DISTRO in
        arch|manjaro)
            DISTRO_TYPE="arch"
            ;;
        ubuntu|debian|pop|linuxmint)
            DISTRO_TYPE="debian"
            ;;
        *)
            if [[ $DISTRO_LIKE == *"arch"* ]]; then
                DISTRO_TYPE="arch"
            elif [[ $DISTRO_LIKE == *"debian"* ]] || [[ $DISTRO_LIKE == *"ubuntu"* ]]; then
                DISTRO_TYPE="debian"
            else
                print_error "Unsupported distribution: $DISTRO"
                exit 1
            fi
            ;;
    esac
}

# Install GNU Stow
install_stow() {
    print_section "Installing GNU Stow"
    
    if command -v stow &> /dev/null; then
        print_info "GNU Stow already installed"
        return
    fi

    case $DISTRO_TYPE in
        arch)
            sudo pacman -S --needed --noconfirm stow
            ;;
        debian)
            sudo apt install -y stow
            ;;
    esac
    print_success "GNU Stow installed"
}

# Install required dependencies
install_dependencies() {
    print_section "Installing Dependencies"
    
    print_info "Installing bat, delta, and other tools..."
    
    case $DISTRO_TYPE in
        arch)
            sudo pacman -S --needed --noconfirm bat git-delta neovim tmux zsh
            ;;
        debian)
            sudo apt install -y bat neovim tmux zsh
            # Delta needs to be installed separately on Debian
            if ! command -v delta &> /dev/null; then
                print_info "Installing git-delta..."
                DELTA_VERSION="0.16.5"
                wget "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_amd64.deb" -O /tmp/delta.deb
                sudo dpkg -i /tmp/delta.deb
                rm /tmp/delta.deb
            fi
            ;;
    esac
    print_success "Dependencies installed"
}

# Setup Neovim configuration
setup_nvim() {
    print_section "Setting up Neovim"
    
    # Create config directory if it doesn't exist
    mkdir -p ~/.config
    
    # Stow nvim configuration
    if [ -d "nvim" ]; then
        print_info "Stowing nvim configuration..."
        stow --dir=. --target=$HOME nvim
        print_success "Neovim configuration linked"
        
        # Install Mason LSPs
        print_info "Note: After first nvim launch, run :Mason and install:"
        echo "  - marksman (Markdown LSP)"
        echo "  - elixir_lsp"
        echo "  - gopls"
        
        print_info "Also run :TSInstall to install parsers:"
        echo "  - markdown"
        echo "  - elixir"
        echo "  - go"
    else
        print_error "nvim directory not found"
    fi
}

# Setup Tmux configuration
setup_tmux() {
    print_section "Setting up Tmux"
    
    # Stow tmux configuration
    if [ -d "tmux" ]; then
        print_info "Stowing tmux configuration..."
        stow --dir=. --target=$HOME tmux
        print_success "Tmux configuration linked"
    fi
    
    # Install TPM (Tmux Plugin Manager)
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        print_info "Installing Tmux Plugin Manager..."
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        print_success "TPM installed"
        print_info "Press prefix + I in tmux to install plugins"
    else
        print_info "TPM already installed"
    fi
    
    # Setup tmux resurrect
    if [ -d "tmux_layouts" ]; then
        print_info "Setting up tmux resurrect..."
        mkdir -p ~/.local/share/tmux/resurrect
        
        if [ -f "tmux_layouts/tmux_resurrect_master.txt" ]; then
            cp tmux_layouts/tmux_resurrect_master.txt ~/.local/share/tmux/resurrect/
            ln -sfn ~/.local/share/tmux/resurrect/tmux_resurrect_master.txt ~/.local/share/tmux/resurrect/last
            print_success "Tmux resurrect configured"
            print_info "Restore session with prefix + Ctrl-r"
        fi
    fi
}

# Setup Zsh configuration
setup_zsh() {
    print_section "Setting up Zsh"
    
    if [ -d "zsh" ]; then
        print_info "Stowing zsh configuration..."
        stow --dir=. --target=$HOME zsh
        print_success "Zsh configuration linked"
    else
        print_info "No zsh directory found, skipping..."
    fi
}

# Setup additional configurations
setup_additional() {
    print_section "Setting up Additional Configurations"
    
    # Check for other common config directories and stow them
    for dir in git alacritty kitty starship; do
        if [ -d "$dir" ]; then
            print_info "Stowing $dir configuration..."
            stow --dir=. --target=$HOME $dir
            print_success "$dir configuration linked"
        fi
    done
}

# Main installation
main() {
    # Check if we're in the dotfiles directory
    if [ ! -d "nvim" ] && [ ! -d "tmux" ]; then
        print_error "This script must be run from the dotfiles repository root"
        exit 1
    fi
    
    detect_distro
    echo ""
    
    install_stow
    install_dependencies
    setup_nvim
    setup_tmux
    setup_zsh
    setup_additional
    
    echo ""
    echo "=================================="
    print_success "Dotfiles installation complete!"
    echo "=================================="
    echo ""
    echo "Next steps:"
    echo "1. Launch nvim and run :Mason to install LSPs"
    echo "2. In nvim, run :TSInstall markdown elixir go"
    echo "3. Launch tmux and press prefix + I to install plugins"
    echo "4. Restart your shell or run: source ~/.zshrc"
    echo ""
}

# Run main function
main
