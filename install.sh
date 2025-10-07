#!/bin/bash

# Multi-Distro Dev Environment Setup Script
# Supports: Arch Linux, Manjaro, Ubuntu/Debian
# Installs: asdf, zsh, oh-my-zsh, zoxide, atuin, and tmux

set -e  # Exit on error

echo "=================================="
echo "Dev Environment Setup"
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

print_distro() {
    echo -e "${BLUE}ℹ $1${NC}"
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
        arch)
            DISTRO_TYPE="arch"
            ;;
        manjaro)
            DISTRO_TYPE="arch"
            ;;
        ubuntu|debian|pop|linuxmint)
            DISTRO_TYPE="debian"
            ;;
        *)
            # Check if it's Arch-based or Debian-based
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

    print_distro "Detected: $DISTRO (Type: $DISTRO_TYPE)"
}

# Update system based on distro
update_system() {
    print_info "Updating system packages..."
    case $DISTRO_TYPE in
        arch)
            sudo pacman -Syu --noconfirm
            ;;
        debian)
            sudo apt update && sudo apt upgrade -y
            ;;
    esac
    print_success "System updated"
}

# Install dependencies
install_dependencies() {
    print_info "Installing dependencies..."
    case $DISTRO_TYPE in
        arch)
            sudo pacman -S --needed --noconfirm base-devel curl git
            ;;
        debian)
            sudo apt install -y build-essential curl git
            ;;
    esac
    print_success "Dependencies installed"
}

# Install zsh
install_zsh() {
    print_info "Installing zsh..."
    case $DISTRO_TYPE in
        arch)
            sudo pacman -S --needed --noconfirm zsh
            ;;
        debian)
            sudo apt install -y zsh
            ;;
    esac
    print_success "zsh installed"
}

# Install oh-my-zsh
install_ohmyzsh() {
    if [ -d "$HOME/.oh-my-zsh" ]; then
        print_info "oh-my-zsh already installed, skipping..."
    else
        print_info "Installing oh-my-zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        print_success "oh-my-zsh installed"
    fi
}

# Install asdf
install_asdf() {
    if [ -d "$HOME/.asdf" ]; then
        print_info "asdf already installed, skipping..."
    else
        print_info "Installing asdf..."
        git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1
        
        # Add asdf to .zshrc
        echo "" >> ~/.zshrc
        echo "# asdf version manager" >> ~/.zshrc
        echo ". \$HOME/.asdf/asdf.sh" >> ~/.zshrc
        
        print_success "asdf installed"
    fi
}

# Install zoxide
install_zoxide() {
    print_info "Installing zoxide..."
    case $DISTRO_TYPE in
        arch)
            sudo pacman -S --needed --noconfirm zoxide
            ;;
        debian)
            # For Ubuntu/Debian, use the installation script
            curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
            ;;
    esac

    # Add zoxide to .zshrc if not already there
    if ! grep -q "zoxide init" ~/.zshrc; then
        echo "" >> ~/.zshrc
        echo "# zoxide - smarter cd command" >> ~/.zshrc
        echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc
    fi
    print_success "zoxide installed"
}

# Install atuin
install_atuin() {
    print_info "Installing atuin..."
    case $DISTRO_TYPE in
        arch)
            sudo pacman -S --needed --noconfirm atuin
            ;;
        debian)
            # For Ubuntu/Debian, use the installation script
            curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
            ;;
    esac

    # Add atuin to .zshrc if not already there
    if ! grep -q "atuin init" ~/.zshrc; then
        echo "" >> ~/.zshrc
        echo "# atuin - shell history" >> ~/.zshrc
        echo 'eval "$(atuin init zsh)"' >> ~/.zshrc
    fi
    print_success "atuin installed"
}

# Install tmux
install_tmux() {
    print_info "Installing tmux..."
    case $DISTRO_TYPE in
        arch)
            sudo pacman -S --needed --noconfirm tmux
            ;;
        debian)
            sudo apt install -y tmux
            ;;
    esac
    print_success "tmux installed"
}

# Change default shell to zsh
change_shell() {
    if [ "$SHELL" != "$(which zsh)" ]; then
        print_info "Setting zsh as default shell..."
        chsh -s $(which zsh)
        print_success "Default shell changed to zsh"
    else
        print_info "zsh is already the default shell"
    fi
}

# Main installation flow
main() {
    detect_distro
    echo ""
    update_system
    install_dependencies
    install_zsh
    install_ohmyzsh
    install_asdf
    install_zoxide
    install_atuin
    install_tmux
    change_shell

    echo ""
    echo "=================================="
    print_success "Installation complete!"
    echo "=================================="
    echo ""
    echo "Next steps:"
    echo "1. Log out and log back in for the shell change to take effect"
    echo "2. Open a new terminal to start using zsh"
    echo "3. Configure atuin with: atuin register (optional, for sync)"
    echo "4. Use 'asdf plugin add <name>' to add language plugins"
    echo "5. Use 'z <directory>' instead of 'cd' to navigate with zoxide"
    echo "6. Start tmux with: tmux"
    echo ""
}

# Run main function
main
