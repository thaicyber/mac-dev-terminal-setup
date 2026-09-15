#!/usr/bin/env bash

set -e

BACKUP_DIR="$HOME/backup-terminal"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
AUTO_INSTALL_ALL=false

# Disable Homebrew auto-update to avoid network issues during installation
# Users can manually run 'brew update' later if needed
export HOMEBREW_NO_AUTO_UPDATE=1

# corepack (bundled with Node) would otherwise pause on a hidden "download yarn? [Y/n]" prompt
export COREPACK_ENABLE_DOWNLOAD_PROMPT=0

# Package manager per architecture:
#   arm64  -> Homebrew  (/opt/homebrew)
#   x86_64 -> MacPorts  (/opt/local)  - Homebrew no longer supports Intel macOS
ARCH="$(uname -m)"
if [[ "$ARCH" == "x86_64" ]]; then
  PKG_MGR="port"
  export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
else
  PKG_MGR="brew"
fi

# ----------------------------------------------------------
# Helper Functions
# ----------------------------------------------------------

show_banner() {
  echo "==============================================="
  echo " 🍵 Tea macOS Terminal Setup - V7"
  echo "==============================================="
  echo ""
}

show_menu() {
  echo "กรุณาเลือก mode การติดตั้ง:"
  echo ""
  echo "1) Install     - ติดตั้งใหม่ (ไม่ทับไฟล์เดิม)"
  echo "2) Reinstall   - ติดตั้งใหม่ทั้งหมด (ทับไฟล์เดิม)"
  echo "3) Uninstall   - ลบการติดตั้งทั้งหมด"
  echo "4) Exit        - ออกจากโปรแกรม"
  echo ""
  read -r -p "เลือก [1-4]: " choice
  echo ""

  case $choice in
    1) MODE="install" ;;
    2) MODE="reinstall" ;;
    3) MODE="uninstall" ;;
    4) echo "👋 ออกจากโปรแกรม"; exit 0 ;;
    *) echo "❌ ตัวเลือกไม่ถูกต้อง"; exit 1 ;;
  esac
}

check_macos() {
  if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ ระบบนี้รองรับเฉพาะ macOS เท่านั้น"
    exit 1
  fi
  echo "✔ macOS detected ($ARCH, package manager: $PKG_MGR)"
}

backup_files() {
  echo "📦 Creating backup at $BACKUP_DIR/$TIMESTAMP"
  mkdir -p "$BACKUP_DIR/$TIMESTAMP"

  # Backup existing files
  [[ -f ~/.zshrc ]] && cp ~/.zshrc "$BACKUP_DIR/$TIMESTAMP/zshrc.backup"
  [[ -f ~/.p10k.zsh ]] && cp ~/.p10k.zsh "$BACKUP_DIR/$TIMESTAMP/p10k.zsh.backup"
  [[ -d ~/.zshrc.d ]] && cp -r ~/.zshrc.d "$BACKUP_DIR/$TIMESTAMP/zshrc.d.backup"
  [[ -f ~/tokyo-night.itermcolors ]] && cp ~/tokyo-night.itermcolors "$BACKUP_DIR/$TIMESTAMP/tokyo-night.itermcolors.backup"

  echo "✔ Backup completed"
  echo ""
}

# ----------------------------------------------------------
# Installation Functions
# ----------------------------------------------------------

install_xcode_cli_tools() {
  echo "🔧 Checking Command Line Tools..."

  # Check if Command Line Tools are installed
  if xcode-select -p &>/dev/null; then
    echo "✔ Command Line Tools already installed"
    return 0
  fi

  echo "📦 Installing Command Line Tools (xcode-select)..."
  echo ""
  echo "⚠️  Important:"
  echo "   - You may need to enter your macOS password (sudo)"
  echo "   - A system dialog will appear"
  echo "   - Click 'Install' button"
  echo "   - Enter your macOS password again when prompted by dialog"
  echo "   - Wait for installation to complete (2-5 minutes)"
  echo ""

  # Try with sudo first (recommended for reliability)
  echo "🔑 Requesting sudo access..."
  if sudo xcode-select --install 2>/dev/null; then
    echo "✔ Installation triggered successfully"
  else
    # Fallback to non-sudo if sudo fails
    echo "⚠️  Trying without sudo..."
    xcode-select --install 2>/dev/null || {
      echo "❌ Failed to trigger installation"
      echo "💡 Please run manually: sudo xcode-select --install"
      return 1
    }
  fi

  # Wait for user to start installation
  echo "⏳ Waiting for installation to start..."
  sleep 3

  # Wait for installation to complete
  echo "⏳ Waiting for installation to complete..."
  echo "   (Checking every 5 seconds, timeout: 30 minutes)"

  local wait_count=0
  until xcode-select -p &>/dev/null; do
    sleep 5
    wait_count=$((wait_count + 1))

    # Show progress every minute
    if (( wait_count % 12 == 0 )); then
      echo "   Still waiting... ($((wait_count / 12)) minute(s) elapsed)"
    fi

    # Timeout after 30 minutes
    if (( wait_count > 360 )); then
      echo "❌ Installation timeout (30 minutes)"
      echo "💡 Please complete the installation manually and run this script again"
      echo "💡 Run: sudo xcode-select --install"
      return 1
    fi
  done

  echo "✔ Command Line Tools installed successfully"
  echo ""
}

# ----------------------------------------------------------
# Package manager abstraction (brew on Apple Silicon, MacPorts on Intel)
# ----------------------------------------------------------

# Map a Homebrew formula name to the MacPorts port name.
port_name() {
  case "$1" in
    python@3.12)   echo "python312" ;;
    postgresql@16) echo "postgresql16" ;;
    mysql-client)  echo "mysql8" ;;
    helm)          echo "helm-3.18" ;;
    tldr)          echo "tlrc" ;;
    awscli)        echo "py313-awscli2" ;;
    *)             echo "$1" ;;
  esac
}

# Install CLI packages with the active package manager.
pkg_install() {
  if [[ "$PKG_MGR" == "brew" ]]; then
    brew install "$@"
  else
    local ports=()
    for f in "$@"; do ports+=("$(port_name "$f")"); done
    sudo port -N install "${ports[@]}"
  fi
}

# MacPorts installs versioned binaries (kubectl1.37, helm3.18, ...) and exposes the
# unversioned name only via `port select`. Pick the newest option for a group.
port_select_latest() {
  [[ "$PKG_MGR" == "port" ]] || return 0
  local group=$1 opt
  opt=$(port select --list "$group" 2>/dev/null | awk 'NR>1 && $1!="none"{print $1}' | sort -V | tail -1)
  [[ -n "$opt" ]] && sudo port -N select --set "$group" "$opt" >/dev/null 2>&1 || true
}

# Copy the .app from a downloaded .dmg into /Applications (Intel path for casks).
install_app_from_dmg() {
  local url=$1 app=$2 tmp
  tmp=$(mktemp -d)
  curl -fsSL "$url" -o "$tmp/app.dmg" || { echo "⚠️  Download failed: $url"; rm -rf "$tmp"; return 1; }
  local mnt
  mnt=$(hdiutil attach -nobrowse -readonly "$tmp/app.dmg" | awk -F'\t' '/\/Volumes\//{print $NF; exit}')
  [[ -n "$mnt" ]] || { echo "⚠️  Could not mount $url"; rm -rf "$tmp"; return 1; }
  if [[ -d "$mnt/$app" ]]; then
    sudo rm -rf "/Applications/$app"
    sudo cp -R "$mnt/$app" /Applications/
    sudo xattr -dr com.apple.quarantine "/Applications/$app" 2>/dev/null || true
  else
    echo "⚠️  $app not found inside dmg"
  fi
  hdiutil detach "$mnt" -quiet || true
  rm -rf "$tmp"
}

# Unzip a downloaded .zip and copy the .app into /Applications (Intel path for casks).
install_app_from_zip() {
  local url=$1 app=$2 tmp
  tmp=$(mktemp -d)
  curl -fsSL "$url" -o "$tmp/app.zip" || { echo "⚠️  Download failed: $url"; rm -rf "$tmp"; return 1; }
  unzip -qo "$tmp/app.zip" -d "$tmp" || { echo "⚠️  Unzip failed"; rm -rf "$tmp"; return 1; }
  if [[ -d "$tmp/$app" ]]; then
    sudo rm -rf "/Applications/$app"
    sudo cp -R "$tmp/$app" /Applications/
    sudo xattr -dr com.apple.quarantine "/Applications/$app" 2>/dev/null || true
  else
    echo "⚠️  $app not found inside zip"
  fi
  rm -rf "$tmp"
}

# Install GUI apps / fonts (brew cask on Apple Silicon, port or direct download on Intel).
cask_install() {
  local name=$1
  if [[ "$PKG_MGR" == "brew" ]]; then
    brew install --cask "$name"
    return
  fi
  case "$name" in
    iterm2)
      if [[ -d /Applications/iTerm.app ]]; then echo "✔ iTerm2 already installed"; else
        install_app_from_zip "https://iterm2.com/downloads/stable/latest" "iTerm.app"; fi ;;
    neohtop)
      local nh_ver
      nh_ver=$(curl -fsSL https://api.github.com/repos/Abdenasser/neohtop/releases/latest | sed -n 's/.*"tag_name": *"v\([^"]*\)".*/\1/p' | head -1)
      [[ -n "$nh_ver" ]] && install_app_from_dmg "https://github.com/Abdenasser/neohtop/releases/download/v${nh_ver}/intel-NeoHtop_${nh_ver}_x64.dmg" "NeoHtop.app" ;;
    font-jetbrains-mono-nerd-font)
      local fonts_dir="$HOME/Library/Fonts"
      if ls "$fonts_dir"/JetBrainsMonoNerdFont-Regular.ttf &>/dev/null; then
        echo "✔ JetBrainsMono Nerd Font already installed"
      else
        local tmp; tmp=$(mktemp -d)
        curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip -o "$tmp/f.zip" \
          && unzip -qo "$tmp/f.zip" -d "$fonts_dir" "*.ttf" && echo "✔ JetBrainsMono Nerd Font installed"
        rm -rf "$tmp"
      fi ;;
    orbstack) install_app_from_dmg "https://orbstack.dev/download/stable/latest/amd64" "OrbStack.app" ;;
    *) echo "⚠️  No Intel install path for cask '$name'"; return 1 ;;
  esac
}

# MacPorts installer (Intel). Picks the pkg matching the running macOS version.
install_macports() {
  if command -v port &>/dev/null; then
    echo "✔ MacPorts already installed"
  else
    echo "📦 Installing MacPorts (Homebrew does not support Intel macOS anymore)..."
    local major codename tag pkg tmp
    major=$(sw_vers -productVersion | cut -d. -f1)
    case "$major" in
      14) codename="Sonoma" ;;
      15) codename="Sequoia" ;;
      26) codename="Tahoe" ;;
      27) codename="GoldenGate" ;;
      *)  echo "❌ Unsupported macOS version for this script: $(sw_vers -productVersion)"; return 1 ;;
    esac
    tag=$(curl -fsSL https://api.github.com/repos/macports/macports-base/releases/latest | sed -n 's/.*"tag_name": *"\(v[^"]*\)".*/\1/p' | head -1)
    [[ -n "$tag" ]] || { echo "❌ Could not determine MacPorts version"; return 1; }
    pkg="MacPorts-${tag#v}-${major}-${codename}.pkg"
    tmp=$(mktemp -d)
    echo "📥 Downloading $pkg..."
    curl -fsSL "https://github.com/macports/macports-base/releases/download/${tag}/${pkg}" -o "$tmp/$pkg" || { echo "❌ Download failed"; rm -rf "$tmp"; return 1; }
    echo "🔑 sudo is required to install the MacPorts package"
    sudo installer -pkg "$tmp/$pkg" -target / || { echo "❌ MacPorts installation failed"; rm -rf "$tmp"; return 1; }
    rm -rf "$tmp"
    export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
    echo "✔ MacPorts installed"
  fi
  echo "➡ Updating MacPorts index (port selfupdate)..."
  sudo port -N selfupdate || echo "⚠️  port selfupdate failed, continuing with existing index"
}

# Dispatch: brew on Apple Silicon, MacPorts on Intel.
install_package_manager() {
  if [[ "$PKG_MGR" == "brew" ]]; then
    install_homebrew
  else
    install_macports
  fi
}

install_homebrew() {
  if ! command -v brew &>/dev/null; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Load Homebrew into current session
    echo ""
    echo "⚙️  Loading Homebrew into PATH..."

    # Detect architecture and set correct Homebrew path
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
      # Apple Silicon
      eval "$(/opt/homebrew/bin/brew shellenv)"
      echo "✔ Homebrew loaded (Apple Silicon)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
      # Intel
      eval "$(/usr/local/bin/brew shellenv)"
      echo "✔ Homebrew loaded (Intel)"
    else
      echo "⚠️  Warning: Homebrew binary not found at expected location"
      echo "💡 You may need to manually add Homebrew to PATH"
      return 1
    fi
  else
    echo "✔ Homebrew already installed"
  fi

  echo "➡ Updating Homebrew..."
  echo "💡 This may take a while on slow connections..."

  # Try to update with longer timeout, but don't fail if it doesn't work
  if ! brew update 2>/dev/null; then
    echo "⚠️  Warning: Homebrew update failed (possibly due to slow network)"
    echo "💡 Continuing with installation... You can update later with: brew update"
    echo ""
  else
    echo "✔ Homebrew updated successfully"
  fi
}

install_packages() {
  echo "📦 Installing core packages..."
  pkg_install git zsh zsh-autosuggestions zsh-syntax-highlighting || true
  cask_install iterm2 || true

  echo "🎨 Installing JetBrains Mono Nerd Font..."
  cask_install font-jetbrains-mono-nerd-font || true
}

install_oh_my_zsh() {
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "💡 Installing Oh My Zsh..."
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  else
    echo "✔ Oh My Zsh already installed"
  fi
}

install_nvm_and_node() {
  echo ""
  echo "📦 Node.js Setup (via NVM)"
  echo "-------------------------------------------"

  # Check if NVM is already installed
  if [[ -d "$HOME/.nvm" ]] || command -v nvm &>/dev/null; then
    echo "✔ NVM already installed"
  else
    if [[ "$AUTO_INSTALL_ALL" == "true" ]]; then
      install_node="y"
      echo "🤖 Auto-install mode: Installing NVM และ Node.js"
    else
      read -r -p "ติดตั้ง NVM และ Node.js? [y/N]: " install_node
    fi

    if [[ "$install_node" != "y" && "$install_node" != "Y" ]]; then
      echo "⏭  Skipping NVM and Node.js"
      echo ""
      return 0
    fi

    echo "📥 Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

    # Load NVM for current session
    export NVM_DIR="$HOME/.nvm"
    # shellcheck source=/dev/null
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    echo "✔ NVM installed"
  fi

  # Load NVM if not loaded
  export NVM_DIR="$HOME/.nvm"
  # shellcheck source=/dev/null
  if ! [ -s "$NVM_DIR/nvm.sh" ] || ! \. "$NVM_DIR/nvm.sh"; then
    echo "⚠️  NVM not loaded properly, skipping Node.js installation"
    return 0
  fi

  # Ask about package managers
  echo ""
  if [[ "$AUTO_INSTALL_ALL" == "true" ]]; then
    install_pm="y"
    INSTALL_PACKAGE_MANAGERS="true"
    echo "🤖 Auto-install mode: Installing pnpm และ yarn"
  else
    read -r -p "ติดตั้ง pnpm และ yarn? (แนะนำสำหรับ modern development) [y/N]: " install_pm
    INSTALL_PACKAGE_MANAGERS="false"
    if [[ "$install_pm" == "y" || "$install_pm" == "Y" ]]; then
      INSTALL_PACKAGE_MANAGERS="true"
    fi
  fi

  # Install Node.js versions
  echo ""
  echo "📦 Installing Node.js versions..."

  NODE_VERSIONS=(16 18 20 22 24)
  DEFAULT_VERSION=24

  for version in "${NODE_VERSIONS[@]}"; do
    # Check if version is already installed (exact match)
    if nvm version "$version" &>/dev/null && [[ "$(nvm version "$version")" != "N/A" ]]; then
      echo "✔ Node.js ${version} already installed"
    else
      echo "📥 Installing Node.js ${version}..."
      nvm install "$version" || {
        echo "⚠️  Failed to install Node.js ${version}"
        continue
      }
    fi

    # Install package managers for each Node version
    if [[ "$INSTALL_PACKAGE_MANAGERS" == "true" ]]; then
      # Use nvm exec (works in non-interactive scripts; nvm use may fail)
      if nvm exec "$version" npm list -g pnpm --depth=0 &>/dev/null && \
         nvm exec "$version" npm list -g yarn --depth=0 &>/dev/null; then
        echo "   ✔ pnpm and yarn already installed for Node.js ${version}"
      else
        echo "   📦 Installing pnpm and yarn for Node.js ${version}..."
        nvm exec "$version" npm install -g pnpm yarn 2>/dev/null || echo "   ⚠️  Failed to install package managers"
      fi
    fi
  done

  # Set default version
  echo ""
  echo "⚙️  Setting Node.js ${DEFAULT_VERSION} as default..."
  nvm alias default "$DEFAULT_VERSION"
  nvm use default

  # Show installed versions
  echo ""
  echo "✔ Node.js installation complete"
  echo "📋 Installed versions:"
  nvm list

  echo ""
  echo "💡 Current active version:"
  node --version
  npm --version

  if [[ "$INSTALL_PACKAGE_MANAGERS" == "true" ]]; then
    echo ""
    echo "📦 Package managers:"
    pnpm --version 2>/dev/null && echo "pnpm: $(pnpm --version)" || echo "pnpm: not available"
    yarn --version 2>/dev/null && echo "yarn: $(yarn --version)" || echo "yarn: not available"
  fi

  echo ""
}

install_dev_tools() {
  echo ""
  echo "🛠  Developer Tools"
  echo "-------------------------------------------"

  if [[ "$AUTO_INSTALL_ALL" == "true" ]]; then
    install_dev="y"
    echo "🤖 Auto-install mode: Installing Developer Tools"
  else
    read -r -p "ติดตั้ง Developer Tools? (OrbStack, kubectl, jq, etc.) [y/N]: " install_dev
  fi

  if [[ "$install_dev" != "y" && "$install_dev" != "Y" ]]; then
    echo "⏭  Skipping Developer Tools"
    echo ""
    return 0
  fi

  echo ""
  echo "📦 Installing Developer Tools..."

  # OrbStack (Docker alternative)
  if command -v docker &>/dev/null; then
    echo "✔ Docker already installed (via OrbStack or other)"
  else
    echo "🐳 Installing OrbStack..."
    if cask_install orbstack; then
      # OrbStack สร้าง docker CLI ให้ตอนเปิดครั้งแรก
      open -a OrbStack 2>/dev/null || true
      echo "💡 OrbStack ถูกเปิดครั้งแรกเพื่อติดตั้ง docker CLI (ใช้เวลาไม่กี่วินาที)"
    else
      echo "⚠️  Failed to install OrbStack"
    fi
  fi

  # kubectl
  if command -v kubectl &>/dev/null; then
    echo "✔ kubectl already installed"
  else
    echo "⎈ Installing kubectl..."
    pkg_install kubectl || echo "⚠️  Failed to install kubectl"
    port_select_latest kubectl
  fi

  # GitHub CLI
  if command -v gh &>/dev/null; then
    echo "✔ GitHub CLI already installed"
  else
    echo "🐙 Installing GitHub CLI..."
    pkg_install gh || echo "⚠️  Failed to install GitHub CLI"
  fi

  # Utilities
  echo "🔧 Installing utilities (jq, wget, tree, htop, rsync)..."
  pkg_install jq wget tree htop rsync 2>/dev/null || echo "⚠️  Some utilities failed to install"

  # neohtop - Modern system monitor GUI
  if [ -d "/Applications/NeoHtop.app" ]; then
    echo "✔ NeoHtop already installed"
  else
    echo "💪 Installing NeoHtop (modern system monitor)..."
    cask_install neohtop || echo "⚠️  Failed to install NeoHtop"
  fi

  # Python 3
  if command -v python3 &>/dev/null && python3 --version | grep -q "3.1"; then
    echo "✔ Python 3 already installed"
  else
    echo "🐍 Installing Python 3..."
    pkg_install python@3.12 || echo "⚠️  Failed to install Python 3"
    if [[ "$PKG_MGR" == "port" ]]; then
      sudo port -N select --set python3 python312 2>/dev/null || true
      sudo port -N select --set python python312 2>/dev/null || true
    fi
  fi

  echo ""
  echo "✔ Developer Tools installation complete"
  echo ""
}

install_database_tools() {
  echo ""
  echo "🗄  Database CLI Tools"
  echo "-------------------------------------------"

  if [[ "$AUTO_INSTALL_ALL" == "true" ]]; then
    install_db="y"
    echo "🤖 Auto-install mode: Installing Database CLI Tools"
  else
    read -r -p "ติดตั้ง Database CLI? (PostgreSQL, Redis clients) [y/N]: " install_db
  fi

  if [[ "$install_db" != "y" && "$install_db" != "Y" ]]; then
    echo "⏭  Skipping Database CLI Tools"
    echo ""
    return 0
  fi

  echo ""
  echo "📦 Installing Database CLI Tools..."

  # PostgreSQL Client
  if command -v psql &>/dev/null; then
    echo "✔ PostgreSQL client already installed"
  else
    echo "🐘 Installing PostgreSQL 16 client tools..."
    pkg_install postgresql@16 || echo "⚠️  Failed to install PostgreSQL client"
    port_select_latest postgresql
    # Add to PATH
    echo "export PATH=\"/opt/homebrew/opt/postgresql@16/bin:\$PATH\"" >> ~/.zshrc
  fi

  # Redis CLI
  if command -v redis-cli &>/dev/null; then
    echo "✔ Redis CLI already installed"
  else
    echo "🔴 Installing Redis CLI..."
    pkg_install redis || echo "⚠️  Failed to install Redis CLI"
  fi

  echo ""
  echo "✔ Database CLI Tools installation complete"
  echo "💡 Note: These are CLI tools only. Use Docker for running servers."
  echo ""
}

install_devops_tools() {
  echo ""
  echo "⚙️  DevOps Tools (Advanced)"
  echo "-------------------------------------------"

  if [[ "$AUTO_INSTALL_ALL" == "true" ]]; then
    install_devops="y"
    echo "🤖 Auto-install mode: Installing DevOps Tools"
  else
    read -r -p "ติดตั้ง DevOps Tools? (Terraform, Helm) [y/N]: " install_devops
  fi

  if [[ "$install_devops" != "y" && "$install_devops" != "Y" ]]; then
    echo "⏭  Skipping DevOps Tools"
    echo ""
    return 0
  fi

  echo ""
  echo "📦 Installing DevOps Tools..."

  # Terraform
  if command -v terraform &>/dev/null; then
    echo "✔ Terraform already installed"
  else
    echo "🏗 Installing Terraform..."
    pkg_install terraform || echo "⚠️  Failed to install Terraform"
    port_select_latest terraform
  fi

  # Helm
  if command -v helm &>/dev/null; then
    echo "✔ Helm already installed"
  else
    echo "⛵ Installing Helm..."
    pkg_install helm || echo "⚠️  Failed to install Helm"
    port_select_latest helm
  fi

  echo ""
  echo "✔ DevOps Tools installation complete"
  echo ""
}

install_modern_cli_tools() {
  echo ""
  echo "✨ Modern CLI Tools (Productivity Boost)"
  echo "-------------------------------------------"

  if [[ "$AUTO_INSTALL_ALL" == "true" ]]; then
    install_modern="y"
    echo "🤖 Auto-install mode: Installing Modern CLI Tools"
  else
    read -r -p "ติดตั้ง Modern CLI Tools? (fzf, bat, eza, ripgrep, etc.) [y/N]: " install_modern
  fi

  if [[ "$install_modern" != "y" && "$install_modern" != "Y" ]]; then
    echo "⏭  Skipping Modern CLI Tools"
    echo ""
    return 0
  fi

  echo ""
  echo "📦 Installing Modern CLI Tools..."

  # fzf - Fuzzy finder
  if command -v fzf &>/dev/null; then
    echo "✔ fzf already installed"
  else
    echo "🔍 Installing fzf (fuzzy finder)..."
    pkg_install fzf || echo "⚠️  Failed to install fzf"
    # Install key bindings and fuzzy completion
    if [[ "$PKG_MGR" == "brew" ]]; then
      "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc 2>/dev/null || true
    else
      # MacPorts ships the shell files but no installer script
      cat << 'FZFRC' > ~/.fzf.zsh
[ -f /opt/local/share/fzf/shell/key-bindings.zsh ] && source /opt/local/share/fzf/shell/key-bindings.zsh
[ -f /opt/local/share/fzf/shell/completion.zsh ] && source /opt/local/share/fzf/shell/completion.zsh
FZFRC
    fi
  fi

  # bat - Better cat
  if command -v bat &>/dev/null; then
    echo "✔ bat already installed"
  else
    echo "🦇 Installing bat (better cat)..."
    pkg_install bat || echo "⚠️  Failed to install bat"
  fi

  # eza - Better ls
  if command -v eza &>/dev/null; then
    echo "✔ eza already installed"
  else
    echo "📁 Installing eza (better ls)..."
    pkg_install eza || echo "⚠️  Failed to install eza"
  fi

  # ripgrep - Better grep
  if command -v rg &>/dev/null; then
    echo "✔ ripgrep already installed"
  else
    echo "🔎 Installing ripgrep (better grep)..."
    pkg_install ripgrep || echo "⚠️  Failed to install ripgrep"
  fi

  # fd - Better find
  if command -v fd &>/dev/null; then
    echo "✔ fd already installed"
  else
    echo "🔍 Installing fd (better find)..."
    pkg_install fd || echo "⚠️  Failed to install fd"
  fi

  # tldr - Simplified man pages
  if command -v tldr &>/dev/null; then
    echo "✔ tldr already installed"
  else
    echo "📖 Installing tldr (simplified man pages)..."
    pkg_install tldr || echo "⚠️  Failed to install tldr"
  fi

  # zoxide - Better cd
  if command -v zoxide &>/dev/null; then
    echo "✔ zoxide already installed"
  else
    echo "🚀 Installing zoxide (smart cd)..."
    pkg_install zoxide || echo "⚠️  Failed to install zoxide"
  fi

  echo ""
  echo "✔ Modern CLI Tools installation complete"
  echo ""
}

install_k8s_enhancement() {
  echo ""
  echo "⎈ Kubernetes Enhancement Tools"
  echo "-------------------------------------------"

  if [[ "$AUTO_INSTALL_ALL" == "true" ]]; then
    install_k8s_enh="y"
    echo "🤖 Auto-install mode: Installing Kubernetes Enhancement"
  else
    read -r -p "ติดตั้ง Kubernetes Enhancement? (k9s, kubectx, kubens) [y/N]: " install_k8s_enh
  fi

  if [[ "$install_k8s_enh" != "y" && "$install_k8s_enh" != "Y" ]]; then
    echo "⏭  Skipping Kubernetes Enhancement"
    echo ""
    return 0
  fi

  echo ""
  echo "📦 Installing Kubernetes Enhancement Tools..."

  # k9s
  if command -v k9s &>/dev/null; then
    echo "✔ k9s already installed"
  else
    echo "🐶 Installing k9s (K8s TUI)..."
    pkg_install k9s || echo "⚠️  Failed to install k9s"
  fi

  # kubectx + kubens
  if command -v kubectx &>/dev/null; then
    echo "✔ kubectx/kubens already installed"
  else
    echo "🔄 Installing kubectx + kubens..."
    pkg_install kubectx || echo "⚠️  Failed to install kubectx"
  fi

  echo ""
  echo "✔ Kubernetes Enhancement installation complete"
  echo ""
}

install_docker_enhancement() {
  echo ""
  echo "🐳 Docker Enhancement Tools"
  echo "-------------------------------------------"

  if [[ "$AUTO_INSTALL_ALL" == "true" ]]; then
    install_docker_enh="y"
    echo "🤖 Auto-install mode: Installing Docker Enhancement"
  else
    read -r -p "ติดตั้ง Docker Enhancement? (lazydocker) [y/N]: " install_docker_enh
  fi

  if [[ "$install_docker_enh" != "y" && "$install_docker_enh" != "Y" ]]; then
    echo "⏭  Skipping Docker Enhancement"
    echo ""
    return 0
  fi

  echo ""
  echo "📦 Installing Docker Enhancement Tools..."

  # lazydocker
  if command -v lazydocker &>/dev/null; then
    echo "✔ lazydocker already installed"
  else
    echo "🐋 Installing lazydocker (Docker TUI)..."
    pkg_install lazydocker || echo "⚠️  Failed to install lazydocker"
  fi

  echo ""
  echo "✔ Docker Enhancement installation complete"
  echo ""
}

install_extra_databases() {
  echo ""
  echo "🗄  Extra Database Clients"
  echo "-------------------------------------------"

  if [[ "$AUTO_INSTALL_ALL" == "true" ]]; then
    install_extra_db="y"
    echo "🤖 Auto-install mode: Installing Extra Database Clients"
  else
    read -r -p "ติดตั้ง Extra Database Clients? (MySQL, MongoDB) [y/N]: " install_extra_db
  fi

  if [[ "$install_extra_db" != "y" && "$install_extra_db" != "Y" ]]; then
    echo "⏭  Skipping Extra Database Clients"
    echo ""
    return 0
  fi

  echo ""
  echo "📦 Installing Extra Database Clients..."

  # MySQL Client
  if command -v mysql &>/dev/null; then
    echo "✔ MySQL client already installed"
  else
    echo "🐬 Installing MySQL client..."
    pkg_install mysql-client || echo "⚠️  Failed to install MySQL client"
    port_select_latest mysql
    # Add to PATH
    echo "export PATH=\"/opt/homebrew/opt/mysql-client/bin:\$PATH\"" >> ~/.zshrc
  fi

  # MongoDB Shell
  if command -v mongosh &>/dev/null || command -v mongo &>/dev/null; then
    echo "✔ MongoDB Shell already installed"
  else
    echo "🍃 Installing MongoDB Shell (mongosh)..."
    if [[ "$PKG_MGR" == "brew" ]]; then
      # MongoDB shell requires the MongoDB tap
      brew tap mongodb/brew 2>/dev/null || true
      if brew install mongodb/brew/mongodb-community-shell; then
        echo "✔ MongoDB Shell installed"
        # Try to link if needed
        brew link --overwrite mongodb-community-shell 2>/dev/null || true
        echo "💡 Note: Restart terminal to use 'mongosh' command"
      else
        echo "⚠️  Failed to install mongosh"
      fi
    else
      # Not in MacPorts: use the official darwin-x64 build
      local ver tmp
      ver=$(curl -fsSL https://api.github.com/repos/mongodb-js/mongosh/releases/latest | sed -n 's/.*"tag_name": *"v\([^"]*\)".*/\1/p' | head -1)
      tmp=$(mktemp -d)
      if [[ -n "$ver" ]] && curl -fsSL "https://github.com/mongodb-js/mongosh/releases/download/v${ver}/mongosh-${ver}-darwin-x64.zip" -o "$tmp/m.zip" \
         && unzip -qo "$tmp/m.zip" -d "$tmp"; then
        sudo install -m 755 "$tmp"/mongosh-*/bin/mongosh /opt/local/bin/mongosh
        sudo install -m 644 "$tmp"/mongosh-*/bin/mongosh_crypt_v1.dylib /opt/local/lib/ 2>/dev/null || true
        echo "✔ MongoDB Shell installed (mongosh ${ver})"
      else
        echo "⚠️  Failed to install mongosh"
      fi
      rm -rf "$tmp"
    fi
  fi

  # MongoDB Database Tools
  if command -v mongodump &>/dev/null; then
    echo "✔ MongoDB Database Tools already installed"
  else
    echo "🛠  Installing MongoDB Database Tools..."
    if [[ "$PKG_MGR" == "brew" ]]; then
      # MongoDB tools require the MongoDB tap
      brew tap mongodb/brew 2>/dev/null || true
      brew install mongodb/brew/mongodb-database-tools || echo "⚠️  Failed to install mongodb-database-tools"
    else
      sudo port -N install mongo-tools || echo "⚠️  Failed to install mongo-tools"
    fi
  fi

  echo ""
  echo "✔ Extra Database Clients installation complete"
  echo "💡 Note: These are CLI tools only. Use Docker for running servers."
  echo ""
}

install_api_tools() {
  echo ""
  echo "🔧 API Development Tools"
  echo "-------------------------------------------"

  if [[ "$AUTO_INSTALL_ALL" == "true" ]]; then
    install_api="y"
    echo "🤖 Auto-install mode: Installing API Development Tools"
  else
    read -r -p "ติดตั้ง API Development Tools? (httpie) [y/N]: " install_api
  fi

  if [[ "$install_api" != "y" && "$install_api" != "Y" ]]; then
    echo "⏭  Skipping API Development Tools"
    echo ""
    return 0
  fi

  echo ""
  echo "📦 Installing API Development Tools..."

  # httpie
  if command -v http &>/dev/null; then
    echo "✔ httpie already installed"
  else
    echo "🌐 Installing httpie (better curl)..."
    pkg_install httpie || echo "⚠️  Failed to install httpie"
  fi

  echo ""
  echo "✔ API Development Tools installation complete"
  echo ""
}

setup_shell_completions() {
  echo ""
  echo "🎯 Shell Completions Setup"
  echo "-------------------------------------------"

  if [[ "$AUTO_INSTALL_ALL" == "true" ]]; then
    install_comp="y"
    echo "🤖 Auto-install mode: Setting up Shell Completions"
  else
    read -r -p "ติดตั้ง Shell Completions? (kubectl, helm, terraform, etc.) [y/N]: " install_comp
  fi

  if [[ "$install_comp" != "y" && "$install_comp" != "Y" ]]; then
    echo "⏭  Skipping Shell Completions"
    echo ""
    return 0
  fi

  echo ""
  echo "📦 Setting up Shell Completions..."

  # Create completions file
  COMP_FILE=~/.zshrc.d/completions.zsh
  mkdir -p ~/.zshrc.d

  # Start fresh
  cat << 'EOF' > "$COMP_FILE"
# Shell Completions for CLI Tools
# Auto-generated by Tea Terminal Setup

EOF

  # kubectl completion
  if command -v kubectl &>/dev/null; then
    echo "⎈ Adding kubectl completion..."
    echo "source <(kubectl completion zsh)" >> "$COMP_FILE"
  fi

  # helm completion
  if command -v helm &>/dev/null; then
    echo "⛵ Adding helm completion..."
    echo "source <(helm completion zsh)" >> "$COMP_FILE"
  fi

  # terraform completion
  if command -v terraform &>/dev/null; then
    echo "🏗 Adding terraform completion..."
    echo "complete -o nospace -C $(command -v terraform) terraform 2>/dev/null || true" >> "$COMP_FILE"
  fi

  # docker completion
  if command -v docker &>/dev/null; then
    echo "🐳 Adding docker completion..."
    echo "source <(docker completion zsh 2>/dev/null) || true" >> "$COMP_FILE"
  fi

  # AWS CLI completion
  if command -v aws &>/dev/null; then
    echo "☁️  Adding AWS CLI completion..."
    cat << 'AWSEOF' >> "$COMP_FILE"
if command -v aws_completer &>/dev/null; then
  autoload bashcompinit && bashcompinit
  complete -C aws_completer aws
fi
AWSEOF
  fi

  # GitHub CLI completion
  if command -v gh &>/dev/null; then
    echo "🐙 Adding GitHub CLI completion..."
    echo "eval \"\$(gh completion -s zsh)\"" >> "$COMP_FILE"
  fi

  # fzf key bindings
  if command -v fzf &>/dev/null; then
    echo "🔍 Adding fzf key bindings..."
    cat << 'FZFEOF' >> "$COMP_FILE"
# fzf key bindings and completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
FZFEOF
  fi

  # zoxide initialization
  if command -v zoxide &>/dev/null; then
    echo "🚀 Adding zoxide initialization..."
    echo "eval \"\$(zoxide init zsh)\"" >> "$COMP_FILE"
  fi

  echo ""
  echo "✔ Shell Completions setup complete"
  echo "💡 Restart terminal or run: source ~/.zshrc"
  echo ""
}

install_cloud_tools() {
  echo ""
  echo "☁️  Cloud Tools Installation"
  echo "-------------------------------------------"

  # AWS CLI
  if command -v aws &>/dev/null; then
    echo "✔ AWS CLI already installed"
  else
    if [[ "$AUTO_INSTALL_ALL" == "true" ]]; then
      install_aws="y"
      echo "🤖 Auto-install mode: Installing AWS CLI"
    else
      read -r -p "ติดตั้ง AWS CLI? [y/N]: " install_aws
    fi

    if [[ "$install_aws" == "y" || "$install_aws" == "Y" ]]; then
      echo "📦 Installing AWS CLI..."
      pkg_install awscli || true
      if [[ "$PKG_MGR" == "port" ]]; then sudo port -N select --set awscli py313-awscli2 2>/dev/null || true; fi
      echo "✔ AWS CLI installed"
      echo "💡 Run 'aws configure' to setup your credentials"
    else
      echo "⏭  Skipping AWS CLI"
    fi
  fi

  echo ""

  # Google Cloud CLI
  if command -v gcloud &>/dev/null; then
    echo "✔ Google Cloud CLI already installed"
  else
    if [[ "$AUTO_INSTALL_ALL" == "true" ]]; then
      install_gcloud="y"
      echo "🤖 Auto-install mode: Installing Google Cloud CLI"
    else
      read -r -p "ติดตั้ง Google Cloud CLI? [y/N]: " install_gcloud
    fi

    if [[ "$install_gcloud" == "y" || "$install_gcloud" == "Y" ]]; then
      echo "📦 Installing Google Cloud CLI..."
      echo "➡ Detecting Mac architecture..."

      # Detect architecture
      ARCH=$(uname -m)
      if [[ "$ARCH" == "arm64" ]]; then
        GCLOUD_PACKAGE="google-cloud-cli-darwin-arm.tar.gz"
        GCLOUD_URL="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${GCLOUD_PACKAGE}"
        echo "✔ Detected Apple Silicon (ARM64)"
      else
        GCLOUD_PACKAGE="google-cloud-cli-darwin-x86_64.tar.gz"
        GCLOUD_URL="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${GCLOUD_PACKAGE}"
        echo "✔ Detected Intel (x86_64)"
      fi

      # Download
      echo "📥 Downloading from Google Cloud..."
      cd ~
      curl -O "$GCLOUD_URL" 2>/dev/null || {
        echo "❌ Download failed"
        return 1
      }

      # Extract
      echo "📦 Extracting..."
      tar -xf "$GCLOUD_PACKAGE" 2>/dev/null || {
        echo "❌ Extract failed"
        rm -f "$GCLOUD_PACKAGE"
        return 1
      }

      # Install
      echo "⚙️  Running installer..."
      ./google-cloud-sdk/install.sh --quiet --usage-reporting=false --path-update=true --command-completion=true

      # Cleanup
      rm -f "$GCLOUD_PACKAGE"

      echo "✔ Google Cloud CLI installed at ~/google-cloud-sdk"
      echo "💡 Restart your terminal or run: source ~/.zshrc"
      echo "💡 Then run 'gcloud init' to setup your configuration"
    else
      echo "⏭  Skipping Google Cloud CLI"
    fi
  fi

  echo ""
}

download_tokyo_night() {
  local force=$1

  if [[ -f ~/tokyo-night.itermcolors && "$force" != "true" ]]; then
    echo "⏭  tokyo-night.itermcolors already exists (skipping)"
  else
    echo "🎨 Downloading Tokyo Night color scheme..."
    curl -fsSL \
      https://raw.githubusercontent.com/thaicyber/mac-dev-terminal-setup/main/tokyo-night.itermcolors \
      -o ~/tokyo-night.itermcolors
    echo "✔ tokyo-night.itermcolors saved"
  fi
}

download_p10k_theme() {
  local force=$1

  if [[ -f ~/.p10k.zsh && "$force" != "true" ]]; then
    echo "⏭  .p10k.zsh already exists (skipping)"
  else
    echo "🎨 Downloading Tea TokyoNight One-line Theme..."
    curl -fsSL \
      https://raw.githubusercontent.com/thaicyber/mac-dev-terminal-setup/main/p10k-tea-tokyonight-one-line.zsh \
      -o ~/.p10k.zsh
    echo "✔ Theme saved to ~/.p10k.zsh"
  fi
}

setup_aliases() {
  local force=$1

  echo "📁 Setting up alias directory..."
  mkdir -p ~/.zshrc.d

  # aliashelp
  if [[ ! -f ~/.zshrc.d/aliashelp.zsh || "$force" == "true" ]]; then
    cat << 'EOF' > ~/.zshrc.d/aliashelp.zsh
aliashelp() {
  echo "====================================="
  echo "📘 Developer Alias Help"
  echo "====================================="
  alias
}
EOF
    echo "✔ aliashelp.zsh created"
  else
    echo "⏭  aliashelp.zsh already exists (skipping)"
  fi

  # developer shortcuts
  if [[ ! -f ~/.zshrc.d/dev-alias.zsh || "$force" == "true" ]]; then
    cat << 'EOF' > ~/.zshrc.d/dev-alias.zsh
alias ll="ls -alh"
alias gs="git status"
alias gp="git pull"
alias gc="git commit"
alias gl="git log --oneline --graph --decorate"

# Port finder function with parameter
portfind() {
  if [ -z "$1" ]; then
    echo "Usage: portfind <port>"
    return 1
  fi
  lsof -iTCP:$1 -sTCP:LISTEN -n -P
}
EOF
    echo "✔ dev-alias.zsh created"
  else
    echo "⏭  dev-alias.zsh already exists (skipping)"
  fi

  # docker shortcuts
  if [[ ! -f ~/.zshrc.d/docker-alias.zsh || "$force" == "true" ]]; then
    cat << 'EOF' > ~/.zshrc.d/docker-alias.zsh
alias dps="docker ps"
alias dimg="docker images"
alias drm="docker rm"
alias drmi="docker rmi"
EOF
    echo "✔ docker-alias.zsh created"
  else
    echo "⏭  docker-alias.zsh already exists (skipping)"
  fi

  # system monitor
  if [[ ! -f ~/.zshrc.d/system-monitor.zsh || "$force" == "true" ]]; then
    cat << 'EOF' > ~/.zshrc.d/system-monitor.zsh
alias topcpu="ps aux | sort -nrk 3,3 | head -n 10"
alias topram="ps aux | sort -nrk 4,4 | head -n 10"
EOF
    echo "✔ system-monitor.zsh created"
  else
    echo "⏭  system-monitor.zsh already exists (skipping)"
  fi
}

update_zshrc() {
  local force=$1

  if grep -q "Tea Terminal Setup" ~/.zshrc 2>/dev/null && [[ "$force" != "true" ]]; then
    echo "⏭  .zshrc already configured (skipping)"
  else
    echo "⚙ Updating ~/.zshrc..."

    # Remove old config if reinstalling
    if [[ "$force" == "true" ]] && grep -q "Tea Terminal Setup" ~/.zshrc 2>/dev/null; then
      sed -i '' '/# Tea Terminal Setup/,/^$/d' ~/.zshrc 2>/dev/null || true
    fi

    cat << 'EOF' >> ~/.zshrc

# ---------------------------------------
# Tea Terminal Setup (Auto generated)
# ---------------------------------------

# Thai-safe
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# NVM (Node Version Manager) - ต้องมีใน .zshrc เพราะ script รันด้วย bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# แก้ conflict กับ .npmrc (prefix/globalconfig) - ทำให้ pnpm/yarn อยู่ใน PATH
[ -s "$NVM_DIR/nvm.sh" ] && nvm use default --delete-prefix --silent 2>/dev/null || true

# Zsh plugins (MacPorts paths on Intel, Homebrew paths on Apple Silicon)
for _plug in zsh-autosuggestions zsh-syntax-highlighting; do
  for _dir in /opt/local/share /opt/homebrew/share /usr/local/share; do
    if [[ -f "$_dir/$_plug/$_plug.zsh" ]]; then source "$_dir/$_plug/$_plug.zsh"; break; fi
  done
done
unset _plug _dir

# Load alias files
for file in ~/.zshrc.d/*.zsh; do
  source "$file"
done

# Load p10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

EOF
    echo "✔ .zshrc updated"
  fi
}

# ----------------------------------------------------------
# Uninstall Function
# ----------------------------------------------------------

uninstall() {
  echo "⚠️  กำลังลบการติดตั้ง Tea Terminal Setup..."
  echo ""

  read -r -p "คุณแน่ใจหรือไม่? [y/N]: " confirm
  if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "❌ ยกเลิกการ uninstall"
    exit 0
  fi

  echo ""
  echo "📦 Creating backup before uninstall..."
  backup_files

  echo "🗑  Removing files..."

  # Remove alias directory
  [[ -d ~/.zshrc.d ]] && rm -rf ~/.zshrc.d && echo "✔ Removed ~/.zshrc.d"

  # Remove p10k theme
  [[ -f ~/.p10k.zsh ]] && rm -f ~/.p10k.zsh && echo "✔ Removed ~/.p10k.zsh"

  # Remove tokyo night color scheme
  [[ -f ~/tokyo-night.itermcolors ]] && rm -f ~/tokyo-night.itermcolors && echo "✔ Removed ~/tokyo-night.itermcolors"

  # Remove config from .zshrc
  if grep -q "Tea Terminal Setup" ~/.zshrc 2>/dev/null; then
    sed -i '' '/# ---------------------------------------/,/^$/d' ~/.zshrc 2>/dev/null || true
    sed -i '' '/# Tea Terminal Setup/d' ~/.zshrc 2>/dev/null || true
    echo "✔ Removed config from ~/.zshrc"
  fi

  echo ""
  echo "==============================================="
  echo "✅ Uninstall Complete!"
  echo ""
  echo "📌 Note:"
  echo "- Homebrew / MacPorts ยังคงอยู่ (ไม่ถูกลบ)"
  echo "- iTerm2 ยังคงอยู่ (ไม่ถูกลบ)"
  echo "- Oh My Zsh ยังคงอยู่ (ไม่ถูกลบ)"
  echo "- Fonts ยังคงอยู่ (ไม่ถูกลบ)"
  echo "- Backup: $BACKUP_DIR/$TIMESTAMP"
  echo "==============================================="
}

# ----------------------------------------------------------
# Main Installation
# ----------------------------------------------------------

do_install() {
  local force=$1

  echo "🚀 เริ่มการติดตั้ง..."
  echo ""

  # Backup existing files
  backup_files

  # Install components
  install_xcode_cli_tools
  install_package_manager
  install_packages
  install_oh_my_zsh
  install_nvm_and_node
  install_dev_tools
  install_database_tools
  install_devops_tools
  install_modern_cli_tools
  install_k8s_enhancement
  install_docker_enhancement
  install_extra_databases
  install_api_tools
  install_cloud_tools

  echo ""
  download_tokyo_night "$force"
  download_p10k_theme "$force"

  echo ""
  setup_aliases "$force"

  echo ""
  setup_shell_completions

  echo ""
  update_zshrc "$force"

  echo ""
  echo "==============================================="
  echo "🎉 Installation Complete!"
  echo ""
  echo "📌 Next Steps:"
  echo "1) Import iTerm2 color scheme:"
  echo "   iTerm2 → Preferences → Profiles → Colors → Import..."
  echo "   Select: ~/tokyo-night.itermcolors"
  echo ""
  echo "2) Set Font:"
  echo "   iTerm2 → Preferences → Profiles → Text"
  echo "   Font: JetBrainsMono Nerd Font"
  echo ""
  echo "3) Restart iTerm2"
  echo ""
  echo "4) Test with: aliashelp"
  echo ""
  echo "📦 Backup: $BACKUP_DIR/$TIMESTAMP"
  echo "==============================================="
}

# ----------------------------------------------------------
# Main Script
# ----------------------------------------------------------

# Parse command line arguments
MODE=""
for arg in "$@"; do
  case $arg in
    --all)
      AUTO_INSTALL_ALL=true
      shift
      ;;
    install|reinstall|uninstall)
      MODE="$arg"
      shift
      ;;
    --help|-h)
      echo "Usage: bash install.sh [MODE] [OPTIONS]"
      echo ""
      echo "Modes:"
      echo "  install      - ติดตั้งใหม่ (ไม่ทับไฟล์เดิม)"
      echo "  reinstall    - ติดตั้งใหม่ทั้งหมด (ทับไฟล์เดิม)"
      echo "  uninstall    - ลบการติดตั้งทั้งหมด"
      echo ""
      echo "Options:"
      echo "  --all        - ติดตั้งทุกอย่างโดยอัตโนมัติ (ไม่ถาม Y/N)"
      echo ""
      echo "Examples:"
      echo "  bash install.sh                    # Interactive mode"
      echo "  bash install.sh install --all      # Auto-install everything"
      echo "  bash install.sh reinstall --all    # Auto-reinstall everything"
      exit 0
      ;;
    *)
      # Unknown option
      ;;
  esac
done

show_banner
check_macos

# If MODE is not set via arguments, show menu
if [[ -z "$MODE" ]]; then
  show_menu
fi

case $MODE in
  install)
    echo "📥 Mode: Install (ติดตั้งใหม่ ไม่ทับไฟล์เดิม)"
    echo ""
    do_install "false"
    ;;
  reinstall)
    echo "🔄 Mode: Reinstall (ติดตั้งใหม่ทั้งหมด)"
    echo ""
    if [[ "$AUTO_INSTALL_ALL" == "true" ]]; then
      confirm="y"
      echo "🤖 Auto-install mode: Proceeding with reinstall"
    else
      read -r -p "คุณแน่ใจหรือไม่? [y/N]: " confirm
    fi

    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
      do_install "true"
    else
      echo "❌ ยกเลิกการ reinstall"
    fi
    ;;
  uninstall)
    uninstall
    ;;
esac
