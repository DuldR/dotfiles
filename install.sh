#!/bin/bash

# Dotfiles Installation Script
# Automatically sets up nvim, tmux, zsh, and other configurations

set -e  # Exit on error

# Parse command line arguments
DRY_RUN=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run|-d)
            DRY_RUN=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --dry-run, -d    Show what would be done without making changes"
            echo "  --help, -h       Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

if [ "$DRY_RUN" = true ]; then
    echo "=================================="
    echo "Dotfiles Installation (DRY RUN)"
    echo "=================================="
    echo ""
else
    echo "=================================="
    echo "Dotfiles Installation"
    echo "=================================="
    echo ""
fi

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to run commands (or simulate in dry run)
run_cmd() {
    if [ "$DRY_RUN" = true ]; then
        echo "  [DRY RUN] Would run: $*"
        return 0
    else
        "$@"
    fi
}

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
            run_cmd sudo pacman -S --needed --noconfirm stow
            ;;
        debian)
            run_cmd sudo apt install -y stow
            ;;
    esac
    print_success "GNU Stow installed"
}

# Install required dependencies
install_dependencies() {
    print_section "Installing Dependencies"
    
    print_info "Installing bat and other tools..."
    
    case $DISTRO_TYPE in
        arch)
            run_cmd sudo pacman -S --needed --noconfirm bat git-delta neovim tmux zsh
            ;;
        debian)
            run_cmd sudo apt install -y bat neovim tmux zsh
            # Delta needs to be installed separately on Debian/Ubuntu
            if ! command -v delta &> /dev/null; then
                print_info "git-delta is not available in default repos"
                echo "  Please install git-delta manually from: https://github.com/dandavison/delta/releases"
            fi
            ;;
    esac
    print_success "Dependencies installed"
}

# Setup Neovim configuration
setup_nvim() {
    print_section "Setting up Neovim"
    
    # Create config directory if it doesn't exist
    run_cmd mkdir -p ~/.config
    
    # Stow nvim configuration
    if [ -d "nvim" ]; then
        print_info "Stowing nvim configuration..."
        # Remove existing nvim config if it exists and is not a symlink
        if [ -e "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
            print_info "Removing existing nvim configuration..."
            run_cmd rm -rf "$HOME/.config/nvim"
        fi
        run_cmd stow --dir=. --target=$HOME nvim
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
        # Remove existing tmux config if it exists and is not a symlink
        if [ -e "$HOME/.tmux.conf" ] && [ ! -L "$HOME/.tmux.conf" ]; then
            print_info "Removing existing tmux configuration..."
            run_cmd rm -f "$HOME/.tmux.conf"
        fi
        run_cmd stow --dir=. --target=$HOME tmux
        print_success "Tmux configuration linked"
    fi
    
    # Install TPM (Tmux Plugin Manager)
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        print_info "Installing Tmux Plugin Manager..."
        run_cmd git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        print_success "TPM installed"
        print_info "Press prefix + I in tmux to install plugins"
    else
        print_info "TPM already installed"
    fi
    
    # Setup tmux resurrect
    if [ -d "tmux_layouts" ]; then
        print_info "Setting up tmux resurrect..."
        run_cmd mkdir -p ~/.local/share/tmux/resurrect
        
        if [ -f "tmux_layouts/tmux_resurrect_master.txt" ]; then
            run_cmd cp tmux_layouts/tmux_resurrect_master.txt ~/.local/share/tmux/resurrect/
            run_cmd ln -sfn ~/.local/share/tmux/resurrect/tmux_resurrect_master.txt ~/.local/share/tmux/resurrect/last
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
        # Remove existing zsh config if it exists and is not a symlink
        if [ -e "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
            print_info "Removing existing zsh configuration..."
            run_cmd rm -f "$HOME/.zshrc"
        fi
        run_cmd stow --dir=. --target=$HOME zsh
        print_success "Zsh configuration linked"
    else
        print_info "No zsh directory found, skipping..."
    fi
}

# Setup Git configuration
setup_git() {
    print_section "Setting up Git"
    
    if [ -d "git" ]; then
        print_info "Stowing git configuration..."
        # Remove existing git config if it exists and is not a symlink
        if [ -e "$HOME/.gitconfig" ] && [ ! -L "$HOME/.gitconfig" ]; then
            print_info "Removing existing git configuration..."
            run_cmd rm -f "$HOME/.gitconfig"
        fi
        run_cmd stow --dir=. --target=$HOME git
        print_success "Git configuration linked"
    else
        print_info "No git directory found, skipping..."
    fi
}

# Setup additional configurations
setup_additional() {
    print_section "Setting up Additional Configurations"
    
    # Check for other common config directories and stow them
    for dir in alacritty; do
        if [ -d "$dir" ]; then
            print_info "Stowing $dir configuration..."
            # Remove existing config if it exists and is not a symlink
            if [ -e "$HOME/.config/$dir" ] && [ ! -L "$HOME/.config/$dir" ]; then
                print_info "Removing existing $dir configuration..."
                run_cmd rm -rf "$HOME/.config/$dir"
            fi
            run_cmd stow --dir=. --target=$HOME $dir
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
    setup_git
    setup_additional
    
    echo ""
    if [ "$DRY_RUN" = true ]; then
        echo "=================================="
        print_success "Dry run complete!"
        echo "=================================="
        echo ""
        echo "No changes were made to your system."
        echo "Run without --dry-run to perform the actual installation."
    else
        echo "=================================="
        print_success "Dotfiles installation complete!"
        echo "=================================="
        echo ""
        echo "Next steps:"
        echo "1. Launch nvim and run :Mason to install LSPs"
        echo "2. In nvim, run :TSInstall markdown elixir go"
        echo "3. Launch tmux and press prefix + I to install plugins"
        echo "4. Restart your shell or run: source ~/.zshrc"
    fi
    echo ""
}

# Run main function
main
