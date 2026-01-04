#!/usr/bin/env bash

# ==========================================
# 🧪 Tea Terminal Setup - Testing Script
# ==========================================
# Version: V7
# Last Updated: 2026-01-04
# Description: Automated testing script based on TESTING_CHECKLIST_TH.md
# ==========================================

set +e  # Continue on errors

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
SKIPPED_TESTS=0

# Test results array
declare -a TEST_RESULTS

# Helper Functions
print_header() {
  echo ""
  echo -e "${CYAN}========================================${NC}"
  echo -e "${CYAN}$1${NC}"
  echo -e "${CYAN}========================================${NC}"
  echo ""
}

print_section() {
  echo ""
  echo -e "${BLUE}--- $1 ---${NC}"
  echo ""
}

test_command() {
  local name="$1"
  local command="$2"
  local expected="$3"

  TOTAL_TESTS=$((TOTAL_TESTS + 1))

  if eval "$command" &>/dev/null; then
    echo -e "${GREEN}✅ PASS${NC}: $name"
    PASSED_TESTS=$((PASSED_TESTS + 1))
    TEST_RESULTS+=("PASS: $name")
    return 0
  else
    echo -e "${RED}❌ FAIL${NC}: $name"
    FAILED_TESTS=$((FAILED_TESTS + 1))
    TEST_RESULTS+=("FAIL: $name")
    return 1
  fi
}

test_file_exists() {
  local name="$1"
  local file="$2"

  TOTAL_TESTS=$((TOTAL_TESTS + 1))

  if [[ -e "$file" ]]; then
    echo -e "${GREEN}✅ PASS${NC}: $name"
    PASSED_TESTS=$((PASSED_TESTS + 1))
    TEST_RESULTS+=("PASS: $name")
    return 0
  else
    echo -e "${RED}❌ FAIL${NC}: $name"
    FAILED_TESTS=$((FAILED_TESTS + 1))
    TEST_RESULTS+=("FAIL: $name")
    return 1
  fi
}

skip_test() {
  local name="$1"
  TOTAL_TESTS=$((TOTAL_TESTS + 1))
  SKIPPED_TESTS=$((SKIPPED_TESTS + 1))
  echo -e "${YELLOW}⏭  SKIP${NC}: $name"
  TEST_RESULTS+=("SKIP: $name")
}

# ==========================================
# Start Testing
# ==========================================

clear
print_header "🧪 Tea Terminal Setup - Testing Script V7"

echo "เริ่มการทดสอบ..."
echo "กำลังตรวจสอบ components ที่ติดตั้ง..."
sleep 1

# ==========================================
# Phase 1: Core Installation
# ==========================================

print_section "🔧 Phase 1: การติดตั้งหลัก"

# 1. Command Line Tools
echo "1️⃣  Command Line Tools (xcode-select)"
test_command "xcode-select ติดตั้งแล้ว" "xcode-select -p"
test_command "gcc/clang พร้อมใช้งาน" "command -v gcc"

# 2. Homebrew
echo ""
echo "2️⃣  Homebrew"
test_command "Homebrew ติดตั้งแล้ว" "command -v brew"
if command -v brew &>/dev/null; then
  BREW_PATH=$(command -v brew)
  echo "   📍 Path: $BREW_PATH"
fi

# 3. Git + Core Packages
echo ""
echo "3️⃣  Git + Core Packages"
test_command "Git ติดตั้งแล้ว" "command -v git"
test_command "Zsh ติดตั้งแล้ว" "command -v zsh"

if command -v brew &>/dev/null; then
  test_file_exists "Zsh autosuggestions plugin" "$(brew --prefix)/share/zsh-autosuggestions"
  test_file_exists "Zsh syntax-highlighting plugin" "$(brew --prefix)/share/zsh-syntax-highlighting"
else
  skip_test "Zsh plugins (Homebrew not found)"
fi

test_file_exists "iTerm2 ติดตั้งแล้ว" "/Applications/iTerm2.app"
test_command "JetBrainsMono Nerd Font ติดตั้งแล้ว" "ls ~/Library/Fonts/ | grep -i jetbrains"

# 4. Oh My Zsh
echo ""
echo "4️⃣  Oh My Zsh"
test_file_exists "Oh My Zsh ติดตั้งแล้ว" "$HOME/.oh-my-zsh"

# ==========================================
# Phase 2: Node.js & Package Managers
# ==========================================

print_section "🟢 Phase 2: Node.js & Package Managers"

# 5. NVM + Node.js
echo "5️⃣  NVM + Node.js"
test_file_exists "NVM ติดตั้งแล้ว" "$HOME/.nvm"

# Load NVM if exists
if [[ -d "$HOME/.nvm" ]]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  test_command "NVM command พร้อมใช้งาน" "command -v nvm"
  test_command "Node.js ติดตั้งแล้ว" "command -v node"
  test_command "npm ติดตั้งแล้ว" "command -v npm"

  if command -v node &>/dev/null; then
    NODE_VERSION=$(node --version)
    echo "   📍 Node.js version: $NODE_VERSION"

    # Check for multiple versions
    if command -v nvm &>/dev/null; then
      echo "   📋 Installed Node.js versions:"
      nvm list | head -10
    fi
  fi
else
  skip_test "NVM (ไม่ได้ติดตั้ง)"
  skip_test "Node.js (ไม่ได้ติดตั้ง)"
  skip_test "npm (ไม่ได้ติดตั้ง)"
fi

# 6. pnpm & yarn
echo ""
echo "6️⃣  Package Managers (pnpm & yarn)"
if [[ -d "$HOME/.nvm" ]]; then
  test_command "pnpm ติดตั้งแล้ว" "command -v pnpm"
  test_command "yarn ติดตั้งแล้ว" "command -v yarn"
else
  skip_test "pnpm (NVM ไม่ได้ติดตั้ง)"
  skip_test "yarn (NVM ไม่ได้ติดตั้ง)"
fi

# ==========================================
# Phase 3: Developer Tools
# ==========================================

print_section "🛠  Phase 3: Developer Tools"

# 7. Docker Desktop
echo "7️⃣  Docker Desktop"
test_command "Docker command พร้อมใช้งาน" "command -v docker"
test_command "Docker Compose พร้อมใช้งาน" "command -v docker-compose || docker compose version"
test_file_exists "Docker.app ติดตั้งแล้ว" "/Applications/Docker.app"

# 8. kubectl
echo ""
echo "8️⃣  kubectl"
test_command "kubectl ติดตั้งแล้ว" "command -v kubectl"

# 9. GitHub CLI
echo ""
echo "9️⃣  GitHub CLI (gh)"
test_command "GitHub CLI ติดตั้งแล้ว" "command -v gh"

# 10. Utilities
echo ""
echo "🔟 Utilities"
test_command "jq ติดตั้งแล้ว" "command -v jq"
test_command "wget ติดตั้งแล้ว" "command -v wget"
test_command "tree ติดตั้งแล้ว" "command -v tree"
test_command "htop ติดตั้งแล้ว" "command -v htop"
test_command "rsync ติดตั้งแล้ว" "command -v rsync"

# 11. NeoHtop
echo ""
echo "1️⃣1️⃣  NeoHtop"
test_file_exists "NeoHtop ติดตั้งแล้ว" "/Applications/NeoHtop.app"

# 12. Python 3
echo ""
echo "1️⃣2️⃣  Python 3"
test_command "Python 3 ติดตั้งแล้ว" "command -v python3"
test_command "pip3 ติดตั้งแล้ว" "command -v pip3"

# ==========================================
# Phase 4: Database CLI Tools
# ==========================================

print_section "🗄  Phase 4: Database CLI Tools"

# 13. PostgreSQL Client
echo "1️⃣3️⃣  PostgreSQL Client"
test_command "psql ติดตั้งแล้ว" "command -v psql"
test_command "pg_dump ติดตั้งแล้ว" "command -v pg_dump"
test_command "pg_restore ติดตั้งแล้ว" "command -v pg_restore"

# 14. Redis CLI
echo ""
echo "1️⃣4️⃣  Redis CLI"
test_command "redis-cli ติดตั้งแล้ว" "command -v redis-cli"

# 15. MySQL Client
echo ""
echo "1️⃣5️⃣  MySQL Client"
test_command "mysql ติดตั้งแล้ว" "command -v mysql"
test_command "mysqldump ติดตั้งแล้ว" "command -v mysqldump"

# 16. MongoDB Tools
echo ""
echo "1️⃣6️⃣  MongoDB Tools"
test_command "mongosh ติดตั้งแล้ว" "command -v mongosh"
test_command "mongodump ติดตั้งแล้ว" "command -v mongodump"
test_command "mongorestore ติดตั้งแล้ว" "command -v mongorestore"

# ==========================================
# Phase 5: DevOps Tools
# ==========================================

print_section "⚙️  Phase 5: DevOps Tools"

# 17. Terraform
echo "1️⃣7️⃣  Terraform"
test_command "Terraform ติดตั้งแล้ว" "command -v terraform"

# 18. Helm
echo ""
echo "1️⃣8️⃣  Helm"
test_command "Helm ติดตั้งแล้ว" "command -v helm"

# ==========================================
# Phase 6: Modern CLI Tools
# ==========================================

print_section "✨ Phase 6: Modern CLI Tools"

# 19. fzf
echo "1️⃣9️⃣  fzf (Fuzzy Finder)"
test_command "fzf ติดตั้งแล้ว" "command -v fzf"
test_file_exists "fzf key bindings" "$HOME/.fzf.zsh"

# 20. bat
echo ""
echo "2️⃣0️⃣  bat"
test_command "bat ติดตั้งแล้ว" "command -v bat"

# 21. eza
echo ""
echo "2️⃣1️⃣  eza"
test_command "eza ติดตั้งแล้ว" "command -v eza"

# 22. ripgrep
echo ""
echo "2️⃣2️⃣  ripgrep (rg)"
test_command "ripgrep ติดตั้งแล้ว" "command -v rg"

# 23. fd
echo ""
echo "2️⃣3️⃣  fd"
test_command "fd ติดตั้งแล้ว" "command -v fd"

# 24. tldr
echo ""
echo "2️⃣4️⃣  tldr"
test_command "tldr ติดตั้งแล้ว" "command -v tldr"

# 25. zoxide
echo ""
echo "2️⃣5️⃣  zoxide"
test_command "zoxide ติดตั้งแล้ว" "command -v zoxide"

# ==========================================
# Phase 7: Kubernetes Enhancement
# ==========================================

print_section "⎈ Phase 7: Kubernetes Enhancement"

# 26. k9s
echo "2️⃣6️⃣  k9s"
test_command "k9s ติดตั้งแล้ว" "command -v k9s"

# 27. kubectx
echo ""
echo "2️⃣7️⃣  kubectx"
test_command "kubectx ติดตั้งแล้ว" "command -v kubectx"

# 28. kubens
echo ""
echo "2️⃣8️⃣  kubens"
test_command "kubens ติดตั้งแล้ว" "command -v kubens"

# ==========================================
# Phase 8: Docker Enhancement
# ==========================================

print_section "🐳 Phase 8: Docker Enhancement"

# 29. lazydocker
echo "2️⃣9️⃣  lazydocker"
test_command "lazydocker ติดตั้งแล้ว" "command -v lazydocker"

# ==========================================
# Phase 9: API Development
# ==========================================

print_section "🔧 Phase 9: API Development"

# 30. httpie
echo "3️⃣0️⃣  httpie"
test_command "httpie ติดตั้งแล้ว" "command -v http"

# ==========================================
# Phase 10: Cloud Tools
# ==========================================

print_section "☁️  Phase 10: Cloud Tools"

# 31. AWS CLI
echo "3️⃣1️⃣  AWS CLI"
test_command "AWS CLI ติดตั้งแล้ว" "command -v aws"

# 32. Google Cloud CLI
echo ""
echo "3️⃣2️⃣  Google Cloud CLI"
test_command "gcloud ติดตั้งแล้ว" "command -v gcloud"
test_file_exists "Google Cloud SDK" "$HOME/google-cloud-sdk"

# ==========================================
# Phase 11: Themes & Configurations
# ==========================================

print_section "🎨 Phase 11: Themes & Configurations"

# 33. Tokyo Night Color Scheme
echo "3️⃣3️⃣  Tokyo Night Color Scheme"
test_file_exists "tokyo-night.itermcolors" "$HOME/tokyo-night.itermcolors"

# 34. Powerlevel10k Theme
echo ""
echo "3️⃣4️⃣  Powerlevel10k Theme"
test_file_exists ".p10k.zsh" "$HOME/.p10k.zsh"
if grep -q "p10k.zsh" "$HOME/.zshrc" 2>/dev/null; then
  echo -e "${GREEN}✅ PASS${NC}: .p10k.zsh loaded in .zshrc"
  PASSED_TESTS=$((PASSED_TESTS + 1))
  TOTAL_TESTS=$((TOTAL_TESTS + 1))
else
  echo -e "${RED}❌ FAIL${NC}: .p10k.zsh not loaded in .zshrc"
  FAILED_TESTS=$((FAILED_TESTS + 1))
  TOTAL_TESTS=$((TOTAL_TESTS + 1))
fi

# 35. Developer Aliases
echo ""
echo "3️⃣5️⃣  Developer Aliases"
test_file_exists "Alias directory" "$HOME/.zshrc.d"
test_file_exists "aliashelp.zsh" "$HOME/.zshrc.d/aliashelp.zsh"
test_file_exists "dev-alias.zsh" "$HOME/.zshrc.d/dev-alias.zsh"
test_file_exists "docker-alias.zsh" "$HOME/.zshrc.d/docker-alias.zsh"
test_file_exists "system-monitor.zsh" "$HOME/.zshrc.d/system-monitor.zsh"

# ==========================================
# Phase 12: Shell Completions
# ==========================================

print_section "🎯 Phase 12: Shell Completions"

# 36. Completions
echo "3️⃣6️⃣  Shell Completions"
test_file_exists "completions.zsh" "$HOME/.zshrc.d/completions.zsh"

# ==========================================
# Phase 13: Backup System
# ==========================================

print_section "📦 Phase 13: Backup System"

# 37. Backup
echo "3️⃣7️⃣  Backup System"
test_file_exists "Backup directory" "$HOME/backup-terminal"

if [[ -d "$HOME/backup-terminal" ]]; then
  BACKUP_COUNT=$(ls -1 "$HOME/backup-terminal" 2>/dev/null | wc -l | xargs)
  echo "   📍 จำนวน backups: $BACKUP_COUNT"
fi

# ==========================================
# Phase 14: .zshrc Configuration
# ==========================================

print_section "⚙️  Phase 14: Configuration"

# Check .zshrc
echo "3️⃣8️⃣  .zshrc Configuration"
test_file_exists ".zshrc" "$HOME/.zshrc"

if grep -q "Tea Terminal Setup" "$HOME/.zshrc" 2>/dev/null; then
  echo -e "${GREEN}✅ PASS${NC}: Tea Terminal Setup config in .zshrc"
  PASSED_TESTS=$((PASSED_TESTS + 1))
  TOTAL_TESTS=$((TOTAL_TESTS + 1))
else
  echo -e "${RED}❌ FAIL${NC}: Tea Terminal Setup config not found in .zshrc"
  FAILED_TESTS=$((FAILED_TESTS + 1))
  TOTAL_TESTS=$((TOTAL_TESTS + 1))
fi

# ==========================================
# Summary Report
# ==========================================

print_header "📊 สรุปผลการทดสอบ"

echo "รายงานการทดสอบ: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# Calculate percentage
if [[ $TOTAL_TESTS -gt 0 ]]; then
  PASS_PERCENTAGE=$((PASSED_TESTS * 100 / TOTAL_TESTS))
else
  PASS_PERCENTAGE=0
fi

echo -e "${CYAN}สถิติการทดสอบ:${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "ทั้งหมด:     ${BLUE}$TOTAL_TESTS${NC} tests"
echo -e "ผ่าน:       ${GREEN}$PASSED_TESTS${NC} tests"
echo -e "ไม่ผ่าน:    ${RED}$FAILED_TESTS${NC} tests"
echo -e "ข้าม:       ${YELLOW}$SKIPPED_TESTS${NC} tests"
echo -e "อัตราผ่าน:  ${GREEN}${PASS_PERCENTAGE}%${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Overall result
if [[ $FAILED_TESTS -eq 0 ]]; then
  echo -e "${GREEN}✅ ผลการทดสอบ: PASS${NC}"
  echo "การติดตั้งสมบูรณ์และทำงานถูกต้อง! 🎉"
  EXIT_CODE=0
elif [[ $PASS_PERCENTAGE -ge 80 ]]; then
  echo -e "${YELLOW}⚠️  ผลการทดสอบ: PASS with Issues${NC}"
  echo "การติดตั้งส่วนใหญ่สำเร็จ แต่มีบางส่วนที่ต้องตรวจสอบ"
  EXIT_CODE=1
else
  echo -e "${RED}❌ ผลการทดสอบ: FAIL${NC}"
  echo "พบปัญหาร้ายแรงหลายจุด กรุณาตรวจสอบการติดตั้ง"
  EXIT_CODE=2
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Show failed tests
if [[ $FAILED_TESTS -gt 0 ]]; then
  echo -e "${RED}รายการที่ไม่ผ่าน:${NC}"
  for result in "${TEST_RESULTS[@]}"; do
    if [[ "$result" == FAIL:* ]]; then
      echo "  - ${result#FAIL: }"
    fi
  done
  echo ""
fi

# Recommendations
if [[ $FAILED_TESTS -gt 0 ]]; then
  echo -e "${YELLOW}💡 คำแนะนำ:${NC}"
  echo "1. ตรวจสอบว่าเลือก optional components ไหนบ้างตอนติดตั้ง"
  echo "2. รัน 'bash install.sh' อีกครั้งเพื่อติดตั้งส่วนที่ขาด"
  echo "3. ตรวจสอบ logs สำหรับข้อผิดพลาดเฉพาะ"
  echo "4. ดู README.md สำหรับรายละเอียดการติดตั้ง"
  echo ""
fi

echo "สร้างรายงานเสร็จสมบูรณ์"
echo ""

exit $EXIT_CODE

