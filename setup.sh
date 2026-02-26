#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status.
set -u  # Treat unset variables as errors and exit immediately.

echo "🛠 Starting dotfiles setup..."

if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This setup script is intended for macOS only."
    exit 1
fi

# -------------------------------
# 1. Install Homebrew
# -------------------------------
install_homebrew() {
    if ! command -v brew &>/dev/null; then
        echo "📦 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Add brew to zprofile if not already there
        if ! grep -q 'brew shellenv' ~/.zprofile 2>/dev/null; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        fi
        eval "$(/opt/homebrew/bin/brew shellenv)"
        echo "✅ Homebrew installed."
    else
        echo "✅ Homebrew already installed."
    fi
    echo "🔄 Updating Homebrew..."
    brew update
    brew upgrade
}

# -------------------------------
# 2. Install Starship
# -------------------------------
install_starship() {
    if ! command -v starship &>/dev/null; then
        echo "📦 Installing Starship prompt..."
        brew install starship
        echo "✅ Starship installed."
    else
        echo "✅ Starship already installed."
    fi
}

# -------------------------------
# 3. Optional: Install Nerd Font for Starship
# -------------------------------
install_nerd_font() {
    local font="font-meslo-lg-nerd-font"
    if ! brew list --cask "$font" &>/dev/null; then
        echo "🔤 Installing Nerd Font (Meslo LG)..."
        brew install --cask "$font"
        echo "✅ $font installed. Set it as your terminal font for best icons."
    else
        echo "✅ Nerd Font already installed."
    fi
}

# -------------------------------
# 4. Install macOS App Store packages (MAS)
# -------------------------------
install_mas_apps() {
    echo "📦 Installing Mac App Store applications..."

    # Ensure MAS CLI is installed
    if ! command -v mas &>/dev/null; then
        echo "🔧 Installing mas (Mac App Store CLI)..."
        brew install mas
    fi

    mas_apps_ids=(1333542190 408981434 497799835)
    mas_apps_names=("1Password" "iMovie" "Xcode")

    for i in "${!mas_apps_ids[@]}"; do
        app_id="${mas_apps_ids[i]}"
        app_name="${mas_apps_names[i]}"
        if mas list | grep -q "$app_id"; then
            echo "✅ $app_name already installed."
        else
            echo "🔧 Installing $app_name..."
            mas install "$app_id" || echo "⚠️ Failed to install $app_name."
        fi
    done

    # Special handling for Xcode license
    if mas list | grep -q "497799835"; then
        echo "⚙️ Accepting Xcode license..."
        sudo xcodebuild -license accept
        echo "✅ Xcode license accepted."
    fi

    echo "✅ MAS app installation complete."
}

# -------------------------------
# 5. Install asdf
# -------------------------------
install_asdf() {
    if ! brew list asdf &>/dev/null; then
        echo "🔧 Installing asdf version manager..."
        brew install asdf
        echo "✅ asdf installed."
    else
        echo "✅ asdf already installed."
    fi
}

# -------------------------------
# 6. Configure asdf
# -------------------------------
install_asdf_plugins() {
    echo "⚙️  Configuring asdf plugins..."

    # Define plugins to install
    local plugins=(
        awscli
        nodejs
        python
    )

    for plugin in "${plugins[@]}"; do
        if ! asdf plugin list | grep -q "^${plugin}$"; then
            echo "🔧 Adding asdf plugin: $plugin"
            asdf plugin add "$plugin"
        else
            echo "✅ Plugin $plugin already added."
        fi

        echo "⬇️  Installing latest version of $plugin..."
        asdf install "$plugin" latest
    done

    echo "✅ asdf plugin configuration complete."
}

# -------------------------------
# 7. Install Homebrew Formulas
# -------------------------------
install_formulas() {
    local formulas=(
        ripgrep
        mgba
        anomalyco/tap/opencode
    )
    echo "📦 Installing homebrew formulas: ${formulas[*]}"
    for app in "${formulas[@]}"; do
        if ! brew list "$app" &>/dev/null; then
            echo "🔧 Installing $app..."
            brew install "$app"
        else
            echo "✅ $app already installed, skipping."
        fi
    done
}

# -------------------------------
# 8. Install Homebrew Casks
# -------------------------------
install_casks() {
    local casks=(
        alacritty
        bitwarden
        clickup
        clockify
        discord
        docker-desktop
        firefox
        google-chrome
        ngrok
        linear-linear
        obs
        postman
        protonvpn
        qflipper
        raspberry-pi-imager
        slack
        spotify
        telegram
        whatsapp
    )

    echo "📦 Installing homebrew casks: ${casks[*]}"
    for app in "${casks[@]}"; do
        if ! brew list --cask "$app" &>/dev/null; then
            echo "🔧 Installing $app..."
            brew install --cask "$app"
        else
            echo "✅ $app already installed, skipping."
        fi
    done
}

# -------------------------------
# 9. Core macOS defaults
# -------------------------------
setup_macos_core_defaults() {
    echo "⚙️  Applying core macOS defaults..."
    # Show all filename extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    # Show hidden files in Finder
    defaults write com.apple.finder AppleShowAllFiles -bool true
    # Set default Finder view to list
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
    # Trackpad Configuration - Tap To Click
    defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad -bool true
    # Trackpad Configuration - Three Finger Drag
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 0
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 0
    # Keyboard - Key Repeat
    defaults write -globalDomain KeyRepeat -int 2
    # Keyboard - Delay Until Repeat
    defaults write -globalDomain InitialKeyRepeat -int 15
    # Desktop & Stage Manager: Show Items - On Desktop disabled 
    defaults write com.apple.WindowManager AppWindowGroupingBehavior -int 1
    defaults write com.apple.WindowManager AutoHide -bool false
    defaults write com.apple.WindowManager HideDesktop -bool true
    defaults write com.apple.WindowManager StageManagerHideWidgets -bool false
    defaults write com.apple.WindowManager StandardHideDesktopIcons -bool true
    defaults write com.apple.WindowManager StandardHideWidgets -bool true
    # Dock - Hide
    defaults write com.apple.dock autohide -bool true
    # Restart Finder to apply changes
    killall Finder 2>/dev/null || true
    killall Dock 2>/dev/null || true
    echo "✅ Core macOS defaults applied."
}


# -------------------------------
# 10. Configure nvim
# -------------------------------
configure_nvim() {
    echo "📝 Configuring Neovim..."
    # lazy.nvim bootstraps itself on first launch — no manual clone needed.
    echo "✅ Neovim is configured. lazy.nvim will auto-install on first launch."
}

# -------------------------------
# 11. Symlink dotfiles (idempotent)
# -------------------------------
link_dotfiles() {
    echo "🔗 Linking configuration files from dotfiles repo..."

    DOTFILES_DIR="$HOME/dotfiles"
    CONFIG_DIR="$HOME/.config"

    mkdir -p "$CONFIG_DIR"

    # Array of src:dest pairs
    configs=(
        "$DOTFILES_DIR/.config/alacritty:$CONFIG_DIR/alacritty"
        "$DOTFILES_DIR/.config/starship:$CONFIG_DIR/starship"
        "$DOTFILES_DIR/.config/nvim:$CONFIG_DIR/nvim"
        "$DOTFILES_DIR/.zshrc:$HOME/.zshrc"
    )

    for pair in "${configs[@]}"; do
        src="${pair%%:*}"
        dest="${pair##*:}"

        if [ -L "$dest" ] || [ -e "$dest" ]; then
            echo "🟡 Removing existing $dest"
            rm -rf "$dest"
        fi

        echo "🔗 Linking $src → $dest"
        ln -s "$src" "$dest"
    done
}

# -------------------------------
# 12. Configure Alacritty
# -------------------------------
configure_alacritty() {
    echo "🖌 Setting up Alacritty themes..."

    local themes_dir="$HOME/.config/alacritty/themes"
    local repo_url="https://github.com/alacritty/alacritty-theme"

    # Ensure themes directory exists
    mkdir -p "$themes_dir"

    # Clone or update themes
    if [ ! -d "$themes_dir/.git" ]; then
        echo "🔧 Cloning Alacritty themes..."
        git clone --depth 1 "$repo_url" "$themes_dir"
    else
        echo "🔄 Updating Alacritty themes..."
        git -C "$themes_dir" pull --ff-only
    fi

    echo "✅ Alacritty themes are ready at $themes_dir"
    echo "💡 Make sure your alacritty.yml imports the themes from $themes_dir"
}

# -------------------------------
# 13. Install Rosetta 2 (for Apple Silicon)
# -------------------------------
install_rosetta() {
    # Check if running on Apple Silicon
    if [[ "$(uname -m)" == "arm64" ]]; then
        # Check if Rosetta is already installed
        if /usr/bin/pgrep oahd >/dev/null 2>&1; then
            echo "✅ Rosetta 2 already installed."
        else
            echo "📦 Installing Rosetta 2..."
            # Install Rosetta silently
            /usr/sbin/softwareupdate --install-rosetta --agree-to-license
            echo "✅ Rosetta 2 installation complete."
        fi
    else
        echo "ℹ️ Not an Apple Silicon Mac, skipping Rosetta installation."
    fi
}

# -------------------------------
# Main execution function
# -------------------------------
main() {
    install_homebrew
    install_starship
    install_nerd_font
    install_mas_apps
    install_asdf
    install_asdf_plugins
    install_formulas
    install_casks
    setup_macos_core_defaults
    configure_nvim
    link_dotfiles
    configure_alacritty
    install_rosetta
    echo "🧹 Cleaning up Homebrew cache..."
    brew cleanup
    echo ""
    echo "🚀 Dotfiles setup complete!"
    echo "➡️  Restart your terminal or run: source ~/.zshrc"
    echo ""
}

main "$@"
