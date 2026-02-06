#!/usr/bin/env bash

set -e

BACKUP_DIR="$HOME/backup-terminal"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
AUTO_INSTALL_ALL=false

TIMEZONE="Asia/Bangkok"
PACKAGES="expect unzip zip htop xclip git software-properties-common nfs-common apache2-utils apt-transport-https ca-certificates curl gnupg-agent jq wget tree rsync lsb-release build-essential"

# ----------------------------------------------------------
# Helper Functions
# ----------------------------------------------------------

show_banner() {
  echo "==============================================="
  echo " 🍵 Tea Ubuntu Server CLI Setup - V1"
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

check_ubuntu() {
  if [[ ! -f /etc/os-release ]]; then
    echo "❌ ไม่พบไฟล์ /etc/os-release - ระบบนี้อาจไม่รองรับ"
    exit 1
  fi

  # shellcheck source=/dev/null
  source /etc/os-release
  if [[ "$ID" != "ubuntu" && "$ID_LIKE" != *"ubuntu"* && "$ID_LIKE" != *"debian"* ]]; then
    echo "❌ ระบบนี้รองรับเฉพาะ Ubuntu และ Debian-based เท่านั้น"
    echo "   พบ: $ID"
    exit 1
  fi

  echo "✔ Ubuntu/Debian detected ($VERSION_ID)"
}

backup_files() {
  echo "📦 Creating backup at $BACKUP_DIR/$TIMESTAMP"
  mkdir -p "$BACKUP_DIR/$TIMESTAMP"

  [[ -f ~/.zshrc ]] && cp ~/.zshrc "$BACKUP_DIR/$TIMESTAMP/zshrc.backup"
  [[ -f ~/.p10k.zsh ]] && cp ~/.p10k.zsh "$BACKUP_DIR/$TIMESTAMP/p10k.zsh.backup"
  [[ -d ~/.zshrc.d ]] && cp -r ~/.zshrc.d "$BACKUP_DIR/$TIMESTAMP/zshrc.d.backup"

  echo "✔ Backup completed"
  echo ""
}

# ----------------------------------------------------------
# Installation Functions
# ----------------------------------------------------------

install_base_packages() {
  echo "📦 Update and upgrade system..."
  sudo DEBIAN_FRONTEND=noninteractive apt-get update -qq
  sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade -qq
  sudo DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade -qq

  echo "🕐 Setting timezone to ${TIMEZONE}..."
  sudo timedatectl set-timezone "${TIMEZONE}"
  timedatectl | head -3

  echo "📦 Installing necessary packages..."
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ${PACKAGES} >/dev/null 2>&1 || true

  echo "✔ Base packages installed"
}

install_docker() {
  if ! command -v docker &>/dev/null; then
    echo "🐳 Docker not found, installing..."
    # shellcheck source=/dev/null
    source /etc/os-release 2>/dev/null || true
    DOCKER_DISTRO="${ID:-ubuntu}"
    curl -fsSL "https://download.docker.com/linux/${DOCKER_DISTRO}/gpg" | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/${DOCKER_DISTRO} $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -qq
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y docker-ce docker-ce-cli containerd.io >/dev/null 2>&1 || true
    sudo systemctl enable docker
    sudo systemctl start docker
    echo "✔ Docker installed"
  else
    echo "✔ Docker already installed"
  fi
}

# เรียกใช้หลังติดตั้งทุกอย่างเสร็จ (เพราะ usermod อาจทำให้ session ต้อง restart)
setup_docker_group() {
  if command -v docker &>/dev/null && ! groups "${USER}" | grep -q "\bdocker\b"; then
    echo "👤 Adding user ${USER} to group docker..."
    sudo usermod -aG docker "${USER}"
    echo "💡 Logout and login again to use docker without sudo"
  fi
}

setup_default_shell() {
  local zsh_path
  zsh_path=$(command -v zsh 2>/dev/null)
  if [[ -z "$zsh_path" ]]; then
    return 0
  fi
  if [[ "$(getent passwd "${USER}" | cut -d: -f7)" == "$zsh_path" ]]; then
    echo "✔ Zsh already set as default shell"
    return 0
  fi
  echo "🔧 Setting Zsh as default shell..."
  if sudo chsh -s "$zsh_path" "${USER}" 2>/dev/null; then
    echo "✔ Zsh set as default shell"
  else
    echo "💡 Run manually: chsh -s $zsh_path"
  fi
}

install_zsh_and_plugins() {
  echo "📦 Installing Zsh and plugins..."

  sudo apt-get install -y zsh zsh-autosuggestions zsh-syntax-highlighting >/dev/null 2>&1 || true

  # Enable zsh-autosuggestions (Debian/Ubuntu package path)
  if [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    echo "✔ zsh-autosuggestions available"
  fi
  if [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    echo "✔ zsh-syntax-highlighting available"
  fi

  echo "✔ Zsh installed"
}

install_oh_my_zsh() {
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "💡 Installing Oh My Zsh..."
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  else
    echo "✔ Oh My Zsh already installed"
  fi

  # Powerlevel10k theme
  if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
    echo "🎨 Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    echo "✔ Powerlevel10k installed"
  else
    echo "✔ Powerlevel10k already installed"
  fi
}

install_nvm_and_node() {
  echo ""
  echo "📦 Node.js Setup (via NVM)"
  echo "-------------------------------------------"

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

    export NVM_DIR="$HOME/.nvm"
    # shellcheck source=/dev/null
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    echo "✔ NVM installed"
  fi

  export NVM_DIR="$HOME/.nvm"
  # shellcheck source=/dev/null
  if ! [ -s "$NVM_DIR/nvm.sh" ] || ! \. "$NVM_DIR/nvm.sh"; then
    echo "⚠️  NVM not loaded properly, skipping Node.js installation"
    return 0
  fi

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

  echo ""
  echo "📦 Installing Node.js versions..."

  NODE_VERSIONS=(16 18 20 22 24)
  DEFAULT_VERSION=22

  for version in "${NODE_VERSIONS[@]}"; do
    if nvm version "$version" &>/dev/null && [[ "$(nvm version "$version")" != "N/A" ]]; then
      echo "✔ Node.js ${version} already installed"
    else
      echo "📥 Installing Node.js ${version}..."
      nvm install "$version" || {
        echo "⚠️  Failed to install Node.js ${version}"
        continue
      }
    fi

    if [[ "$INSTALL_PACKAGE_MANAGERS" == "true" ]]; then
      nvm use "$version" &>/dev/null || continue

      local has_pnpm has_yarn
      has_pnpm=$(command -v pnpm &>/dev/null && echo "yes" || echo "no")
      has_yarn=$(command -v yarn &>/dev/null && echo "yes" || echo "no")

      if [[ "$has_pnpm" == "yes" && "$has_yarn" == "yes" ]]; then
        echo "   ✔ pnpm and yarn already installed for Node.js ${version}"
      else
        echo "   📦 Installing pnpm and yarn for Node.js ${version}..."
        npm install -g pnpm yarn 2>/dev/null || echo "   ⚠️  Failed to install package managers"
      fi
    fi
  done

  echo ""
  echo "⚙️  Setting Node.js ${DEFAULT_VERSION} as default..."
  nvm alias default "$DEFAULT_VERSION"
  nvm use default

  echo ""
  echo "✔ Node.js installation complete"
  nvm list
  echo ""
  echo "💡 Current: node $(node --version) | npm $(npm --version)"
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
    read -r -p "ติดตั้ง Developer Tools? (Docker, kubectl, jq, etc.) [y/N]: " install_dev
  fi

  if [[ "$install_dev" != "y" && "$install_dev" != "Y" ]]; then
    echo "⏭  Skipping Developer Tools"
    echo ""
    return 0
  fi

  echo ""
  echo "📦 Installing Developer Tools..."

  # Docker (official Docker repo)
  install_docker

  # kubectl
  if command -v kubectl &>/dev/null; then
    echo "✔ kubectl already installed"
  else
    echo "⎈ Installing kubectl..."
    ARCH=$(dpkg --print-architecture)
    KUBECTL_VERSION=$(curl -sL https://dl.k8s.io/release/stable.txt)
    curl -fsSL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl" -o /tmp/kubectl
    sudo install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl
    rm -f /tmp/kubectl
    echo "✔ kubectl installed"
  fi

  # GitHub CLI
  if command -v gh &>/dev/null; then
    echo "✔ GitHub CLI already installed"
  else
    echo "🐙 Installing GitHub CLI..."
    type -p curl >/dev/null || sudo apt-get install -y curl
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt-get update -qq
    sudo apt-get install -y gh || echo "⚠️  Failed to install GitHub CLI"
  fi

  # Python 3
  if command -v python3 &>/dev/null; then
    echo "✔ Python 3 already installed ($(python3 --version))"
  else
    echo "🐍 Installing Python 3..."
    sudo apt-get install -y python3 python3-pip python3-venv || echo "⚠️  Failed to install Python 3"
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

  if command -v psql &>/dev/null; then
    echo "✔ PostgreSQL client already installed"
  else
    echo "🐘 Installing PostgreSQL client..."
    sudo apt-get install -y postgresql-client || echo "⚠️  Failed to install PostgreSQL client"
  fi

  if command -v redis-cli &>/dev/null; then
    echo "✔ Redis CLI already installed"
  else
    echo "🔴 Installing Redis CLI..."
    sudo apt-get install -y redis-tools || echo "⚠️  Failed to install Redis CLI"
  fi

  echo ""
  echo "✔ Database CLI Tools installation complete"
  echo "💡 Note: CLI tools only. Use Docker for running servers."
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

  if command -v terraform &>/dev/null; then
    echo "✔ Terraform already installed"
  else
    echo "🏗 Installing Terraform..."
    ARCH=$(uname -m)
    [[ "$ARCH" == "x86_64" ]] && TF_ARCH="amd64" || TF_ARCH="arm64"
    wget -q -O /tmp/terraform.zip "https://releases.hashicorp.com/terraform/1.9.0/terraform_1.9.0_linux_${TF_ARCH}.zip" 2>/dev/null && {
      unzip -o /tmp/terraform.zip -d /tmp
      sudo mv /tmp/terraform /usr/local/bin/
      rm -f /tmp/terraform.zip
      echo "✔ Terraform installed"
    } || echo "⚠️  Failed to install Terraform"
  fi

  if command -v helm &>/dev/null; then
    echo "✔ Helm already installed"
  else
    echo "⛵ Installing Helm..."
    curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash || echo "⚠️  Failed to install Helm"
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

  # fzf
  if command -v fzf &>/dev/null; then
    echo "✔ fzf already installed"
  else
    sudo apt-get install -y fzf || echo "⚠️  Failed to install fzf"
  fi

  # bat (batcat on Debian/Ubuntu)
  if command -v bat &>/dev/null || command -v batcat &>/dev/null; then
    echo "✔ bat already installed"
  else
    sudo apt-get install -y bat || echo "⚠️  Failed to install bat"
  fi

  # eza
  if command -v eza &>/dev/null; then
    echo "✔ eza already installed"
  else
    sudo apt-get install -y eza 2>/dev/null || echo "⚠️  eza not in repo, skipping"
  fi

  # ripgrep
  if command -v rg &>/dev/null; then
    echo "✔ ripgrep already installed"
  else
    sudo apt-get install -y ripgrep || echo "⚠️  Failed to install ripgrep"
  fi

  # fd
  if command -v fd &>/dev/null; then
    echo "✔ fd already installed"
  else
    sudo apt-get install -y fd-find || echo "⚠️  Failed to install fd"
  fi

  # tldr
  if command -v tldr &>/dev/null; then
    echo "✔ tldr already installed"
  else
    sudo apt-get install -y tldr 2>/dev/null || echo "⚠️  tldr not in repo, skipping"
  fi

  # zoxide
  if command -v zoxide &>/dev/null; then
    echo "✔ zoxide already installed"
  else
    sudo apt-get install -y zoxide 2>/dev/null || echo "⚠️  zoxide not in repo, skipping"
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

  if command -v k9s &>/dev/null; then
    echo "✔ k9s already installed"
  else
    echo "🐶 Installing k9s..."
    K9S_VERSION="v0.32.4"
    wget -q "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_$(uname -m).tar.gz" -O /tmp/k9s.tar.gz 2>/dev/null && {
      tar -xzf /tmp/k9s.tar.gz -C /tmp
      sudo mv /tmp/k9s /usr/local/bin/
      rm -f /tmp/k9s.tar.gz
      echo "✔ k9s installed"
    } || echo "⚠️  Failed to install k9s"
  fi

  if command -v kubectx &>/dev/null; then
    echo "✔ kubectx/kubens already installed"
  else
    echo "🔄 Installing kubectx + kubens..."
    sudo apt-get install -y kubectx 2>/dev/null || echo "⚠️  kubectx not in repo, skipping"
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
  echo "📦 Installing lazydocker..."

  if command -v lazydocker &>/dev/null; then
    echo "✔ lazydocker already installed"
  else
    echo "🐋 Installing lazydocker..."
    LAZYDOCKER_VERSION="0.24.2"
    ARCH=$(uname -m)
    [[ "$ARCH" == "x86_64" ]] && LAZY_ARCH="x86_64" || LAZY_ARCH="arm64"
    curl -fsSL "https://github.com/jesseduffield/lazydocker/releases/download/v${LAZYDOCKER_VERSION}/lazydocker_${LAZYDOCKER_VERSION}_Linux_${LAZY_ARCH}.tar.gz" -o /tmp/lazydocker.tar.gz 2>/dev/null && {
      tar -xzf /tmp/lazydocker.tar.gz -C /tmp lazydocker
      sudo mv /tmp/lazydocker /usr/local/bin/
      rm -f /tmp/lazydocker.tar.gz
      echo "✔ lazydocker installed"
    } || echo "⚠️  Failed to install lazydocker"
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

  if command -v mysql &>/dev/null; then
    echo "✔ MySQL client already installed"
  else
    echo "🐬 Installing MySQL client..."
    sudo apt-get install -y mysql-client || echo "⚠️  Failed to install MySQL client"
  fi

  if command -v mongosh &>/dev/null || command -v mongo &>/dev/null; then
    echo "✔ MongoDB Shell already installed"
  else
    echo "🍃 Installing MongoDB Shell..."
    # Try apt first (Ubuntu 22.04+ has mongodb-mongosh)
    sudo apt-get install -y mongodb-mongosh 2>/dev/null || {
      # Fallback: add MongoDB repo for jammy
      source /etc/os-release 2>/dev/null || true
      UBUNTU_CODENAME="${UBUNTU_CODENAME:-jammy}"
      curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
      echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu ${UBUNTU_CODENAME}/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
      sudo apt-get update -qq
      sudo apt-get install -y mongodb-mongosh || echo "⚠️  Failed to install mongosh"
    }
  fi

  echo ""
  echo "✔ Extra Database Clients installation complete"
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
  if command -v http &>/dev/null; then
    echo "✔ httpie already installed"
  else
    echo "🌐 Installing httpie..."
    sudo apt-get install -y httpie || echo "⚠️  Failed to install httpie"
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

  COMP_FILE=~/.zshrc.d/completions.zsh
  mkdir -p ~/.zshrc.d

  cat << 'EOF' > "$COMP_FILE"
# Shell Completions for CLI Tools
# Auto-generated by Tea Ubuntu Server Setup

EOF

  if command -v kubectl &>/dev/null; then
    echo "⎈ Adding kubectl completion..."
    echo "source <(kubectl completion zsh)" >> "$COMP_FILE"
  fi

  if command -v helm &>/dev/null; then
    echo "⛵ Adding helm completion..."
    echo "source <(helm completion zsh)" >> "$COMP_FILE"
  fi

  TERRAFORM_PATH=$(command -v terraform 2>/dev/null || echo "")
  if [[ -n "$TERRAFORM_PATH" ]]; then
    echo "🏗 Adding terraform completion..."
    echo "complete -o nospace -C $TERRAFORM_PATH terraform 2>/dev/null || true" >> "$COMP_FILE"
  fi

  if command -v docker &>/dev/null; then
    echo "🐳 Adding docker completion..."
    echo "source <(docker completion zsh 2>/dev/null) || true" >> "$COMP_FILE"
  fi

  if command -v aws &>/dev/null; then
    echo "☁️  Adding AWS CLI completion..."
    cat << 'AWSEOF' >> "$COMP_FILE"
if command -v aws_completer &>/dev/null; then
  autoload bashcompinit && bashcompinit
  complete -C aws_completer aws
fi
AWSEOF
  fi

  if command -v gh &>/dev/null; then
    echo "🐙 Adding GitHub CLI completion..."
    echo "eval \"\$(gh completion -s zsh)\"" >> "$COMP_FILE"
  fi

  if command -v fzf &>/dev/null; then
    echo "🔍 Adding fzf key bindings..."
    echo "[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh" >> "$COMP_FILE"
    echo "[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh" >> "$COMP_FILE"
  fi

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
      sudo apt-get install -y awscli || true
      echo "✔ AWS CLI installed"
      echo "💡 Run 'aws configure' to setup credentials"
    else
      echo "⏭  Skipping AWS CLI"
    fi
  fi

  echo ""

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
      ARCH=$(uname -m)
      if [[ "$ARCH" == "x86_64" ]]; then
        GCLOUD_PACKAGE="google-cloud-cli-linux-x86_64.tar.gz"
      elif [[ "$ARCH" == "aarch64" || "$ARCH" == "arm64" ]]; then
        GCLOUD_PACKAGE="google-cloud-cli-linux-arm.tar.gz"
      else
        GCLOUD_PACKAGE="google-cloud-cli-linux-x86_64.tar.gz"
      fi
      GCLOUD_URL="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${GCLOUD_PACKAGE}"

      cd ~
      curl -O "$GCLOUD_URL" 2>/dev/null || { echo "❌ Download failed"; return 1; }
      tar -xf "$GCLOUD_PACKAGE" 2>/dev/null || { echo "❌ Extract failed"; rm -f "$GCLOUD_PACKAGE"; return 1; }
      ./google-cloud-sdk/install.sh --quiet --usage-reporting=false --path-update=true --command-completion=true
      rm -f "$GCLOUD_PACKAGE"
      echo "✔ Google Cloud CLI installed at ~/google-cloud-sdk"
      echo "💡 Run 'gcloud init' to setup"
    else
      echo "⏭  Skipping Google Cloud CLI"
    fi
  fi

  echo ""
}

download_p10k_theme() {
  local force=$1

  if [[ -f ~/.p10k.zsh && "$force" != "true" ]]; then
    echo "⏭  .p10k.zsh already exists (skipping)"
  else
    echo "🎨 Downloading Tea TokyoNight One-line Theme..."
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
    if [[ -f "$REPO_ROOT/p10k-tea-tokyonight-one-line.zsh" ]]; then
      cp "$REPO_ROOT/p10k-tea-tokyonight-one-line.zsh" ~/.p10k.zsh
      echo "✔ Theme saved to ~/.p10k.zsh"
    else
      curl -fsSL \
        https://raw.githubusercontent.com/thaicyber/mac-dev-terminal-setup/main/p10k-tea-tokyonight-one-line.zsh \
        -o ~/.p10k.zsh
      echo "✔ Theme saved to ~/.p10k.zsh"
    fi
  fi
}

setup_aliases() {
  local force=$1

  echo "📁 Setting up alias directory..."
  mkdir -p ~/.zshrc.d

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

  if [[ ! -f ~/.zshrc.d/dev-alias.zsh || "$force" == "true" ]]; then
    cat << 'EOF' > ~/.zshrc.d/dev-alias.zsh
alias ll="ls -alh"
alias gs="git status"
alias gp="git pull"
alias gc="git commit"
alias gl="git log --oneline --graph --decorate"

# Use eza if available, else ls
if command -v eza &>/dev/null; then
  alias ll="eza -alh"
fi

portfind() {
  if [ -z "$1" ]; then
    echo "Usage: portfind <port>"
    return 1
  fi
  lsof -iTCP:$1 -sTCP:LISTEN -n -P 2>/dev/null || ss -tlnp | grep ":$1 "
}
EOF
    echo "✔ dev-alias.zsh created"
  else
    echo "⏭  dev-alias.zsh already exists (skipping)"
  fi

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

  if [[ ! -f ~/.zshrc.d/system-monitor.zsh || "$force" == "true" ]]; then
    cat << 'EOF' > ~/.zshrc.d/system-monitor.zsh
alias topcpu="ps aux | sort -nrk 3,3 | head -n 10"
alias topram="ps aux | sort -nrk 4,4 | head -n 10"
EOF
    echo "✔ system-monitor.zsh created"
  else
    echo "⏭  system-monitor.zsh already exists (skipping)"
  fi

  # bat alias (batcat on Debian/Ubuntu)
  if command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
    if [[ ! -f ~/.zshrc.d/bat-alias.zsh || "$force" == "true" ]]; then
      echo "alias bat='batcat'" > ~/.zshrc.d/bat-alias.zsh
      echo "✔ bat-alias.zsh created (batcat -> bat)"
    fi
  fi

  # fd alias (fdfind on Debian/Ubuntu)
  if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
    if [[ ! -f ~/.zshrc.d/fd-alias.zsh || "$force" == "true" ]]; then
      echo "alias fd='fdfind'" > ~/.zshrc.d/fd-alias.zsh
      echo "✔ fd-alias.zsh created (fdfind -> fd)"
    fi
  fi
}

update_zshrc() {
  local force=$1

  if grep -q "Tea Terminal Setup" ~/.zshrc 2>/dev/null && [[ "$force" != "true" ]]; then
    echo "⏭  .zshrc already configured (skipping)"
  else
    echo "⚙ Updating ~/.zshrc..."

    if [[ "$force" == "true" ]] && grep -q "Tea Terminal Setup" ~/.zshrc 2>/dev/null; then
      sed -i '/# Tea Terminal Setup/,/^$/d' ~/.zshrc 2>/dev/null || true
    fi

    # Set Powerlevel10k theme (must be before oh-my-zsh loads)
    if grep -q '^ZSH_THEME=' ~/.zshrc 2>/dev/null; then
      sed -i 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' ~/.zshrc
    fi

    cat << 'EOF' >> ~/.zshrc

# ---------------------------------------
# Tea Terminal Setup (Ubuntu Server - Auto generated)
# ---------------------------------------

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Zsh plugins (Debian/Ubuntu package paths)
[[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

for file in ~/.zshrc.d/*.zsh; do
  [[ -f "$file" ]] && source "$file"
done

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

  [[ -d ~/.zshrc.d ]] && rm -rf ~/.zshrc.d && echo "✔ Removed ~/.zshrc.d"
  [[ -f ~/.p10k.zsh ]] && rm -f ~/.p10k.zsh && echo "✔ Removed ~/.p10k.zsh"

  if grep -q "Tea Terminal Setup" ~/.zshrc 2>/dev/null; then
    sed -i '/# ---------------------------------------/,/^$/d' ~/.zshrc 2>/dev/null || true
    sed -i '/# Tea Terminal Setup/d' ~/.zshrc 2>/dev/null || true
    echo "✔ Removed config from ~/.zshrc"
  fi

  echo ""
  echo "==============================================="
  echo "✅ Uninstall Complete!"
  echo ""
  echo "📌 Note:"
  echo "- apt packages ยังคงอยู่ (ไม่ถูกลบ)"
  echo "- Oh My Zsh ยังคงอยู่ (ไม่ถูกลบ)"
  echo "- NVM/Node.js ยังคงอยู่ (ไม่ถูกลบ)"
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

  backup_files

  install_base_packages
  install_zsh_and_plugins
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
  download_p10k_theme "$force"

  echo ""
  setup_aliases "$force"

  echo ""
  setup_shell_completions

  echo ""
  update_zshrc "$force"

  # ทำทีหลังสุด (ทั้งคู่มีผลเมื่อ login ครั้งถัดไป)
  setup_default_shell   # ตั้ง shell ก่อน
  setup_docker_group    # เพิ่ม group ทีหลัง

  echo ""
  echo "==============================================="
  echo "🎉 Installation Complete!"
  echo ""
  echo "📌 Next Steps:"
  echo "1) Logout and login again (or: exec zsh)"
  echo "2) Test with: aliashelp"
  echo ""
  echo "📦 Backup: $BACKUP_DIR/$TIMESTAMP"
  echo "==============================================="
}

# ----------------------------------------------------------
# Main Script
# ----------------------------------------------------------

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
      echo "  bash install.sh install --all     # Auto-install everything"
      echo "  bash install.sh reinstall --all   # Auto-reinstall everything"
      exit 0
      ;;
    *)
      ;;
  esac
done

show_banner
check_ubuntu

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
