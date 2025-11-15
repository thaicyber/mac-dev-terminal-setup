#!/usr/bin/env bash

set -e

echo "==============================================="
echo " 🚀 Tea macOS Terminal Setup - Install Script V2"
echo "==============================================="
sleep 1

# ----------------------------------------------------------
# 1) ตรวจสอบระบบปฏิบัติการ
# ----------------------------------------------------------
if [[ "$OSTYPE" != "darwin"* ]]; then
  echo "❌ ระบบนี้รองรับเฉพาะ macOS เท่านั้น"
  exit 1
fi

echo "✔ macOS detected"

# ----------------------------------------------------------
# 2) ติดตั้ง Homebrew หากยังไม่มี
# ----------------------------------------------------------
if ! command -v brew &>/dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "✔ Homebrew already installed"
fi

echo "➡ Updating Homebrew..."
brew update

# ----------------------------------------------------------
# 3) ติดตั้งแพ็กเกจหลัก
# ----------------------------------------------------------
echo "📦 Installing iTerm2, Zsh, Git, and utilities..."
brew install git zsh zsh-autosuggestions zsh-syntax-highlighting || true
brew install --cask iterm2 || true

# ----------------------------------------------------------
# 4) ติดตั้ง Oh My Zsh หากยังไม่มี
# ----------------------------------------------------------
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "💡 Installing Oh My Zsh..."
  RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "✔ Oh My Zsh already installed"
fi

# ----------------------------------------------------------
# 5) ดาวน์โหลด P10K Theme ของ Tea
# ----------------------------------------------------------
echo "🎨 Downloading Tea TokyoNight One-line Theme..."
curl -fsSL \
  https://raw.githubusercontent.com/thaicyber/mac-dev-terminal-setup/main/p10k-tea-tokyonight-one-line.zsh \
  -o ~/.p10k.zsh

echo "✔ Theme saved to ~/.p10k.zsh"

# ----------------------------------------------------------
# 6) สร้างโฟลเดอร์ alias
# ----------------------------------------------------------
echo "📁 Setting up alias directory..."
mkdir -p ~/.zshrc.d

# aliashelp
cat << 'EOF' > ~/.zshrc.d/aliashelp.zsh
aliashelp() {
  echo "====================================="
  echo "📘 Developer Alias Help"
  echo "====================================="
  alias
}
EOF

# developer shortcuts
cat << 'EOF' > ~/.zshrc.d/dev-alias.zsh
alias ll="ls -alh"
alias gs="git status"
alias gp="git pull"
alias gc="git commit"
alias gl="git log --oneline --graph --decorate"
EOF

# docker shortcuts
cat << 'EOF' > ~/.zshrc.d/docker-alias.zsh
alias dps="docker ps"
alias dimg="docker images"
alias drm="docker rm"
alias drmi="docker rmi"
EOF

# system monitor
cat << 'EOF' > ~/.zshrc.d/system-monitor.zsh
alias topcpu="ps aux | sort -nrk 3,3 | head -n 10"
alias topram="ps aux | sort -nrk 4,4 | head -n 10"
alias portfind="lsof -iTCP -sTCP:LISTEN -n -P"
EOF

echo "✔ Shortcut files installed"

# ----------------------------------------------------------
# 7) อัปเดต ~/.zshrc ให้โหลดทุก config
# ----------------------------------------------------------
echo "⚙ Updating ~/.zshrc ... (safe append)"

if ! grep -q "Tea Terminal Setup" ~/.zshrc; then
cat << 'EOF' >> ~/.zshrc

# ---------------------------------------
# Tea Terminal Setup (Auto generated)
# ---------------------------------------

# Thai-safe
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Load alias files
for file in ~/.zshrc.d/*.zsh; do
  source "$file"
done

# Load p10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

EOF
fi

# ----------------------------------------------------------
# 8) เสร็จสิ้น
# ----------------------------------------------------------
echo ""
echo "==============================================="
echo "🎉 Installation Complete!"
echo "👉 กรุณาปิดแล้วเปิด iTerm2 ใหม่"
echo "👉 ตั้งค่า Font: JetBrainsMono Nerd Font"
echo "👉 เลือกสี: Tokyo Night"
echo ""
echo "พิมพ์คำสั่งทดสอบ:"
echo "   aliashelp"
echo "==============================================="
