# 🧪 Testing Checklist - mac-dev-terminal-setup V7

**Version:** V7
**Last Updated:** 2026-01-04
**Test Environment:** macOS (Intel/Apple Silicon)

---

## 📋 Pre-Installation Checks

### System Requirements
- [ ] macOS 12.0 (Monterey) or later
- [ ] At least 10GB free disk space
- [ ] Internet connection (for downloads)
- [ ] Admin/sudo privileges

### Backup Status
- [ ] Time Machine backup completed (recommended)
- [ ] Important files backed up
- [ ] Test on separate user account (if possible)

---

## 🔧 Phase 1: Core Installation

### 1. Command Line Tools (xcode-select)
```bash
# Check if installed
xcode-select -p
# Should show: /Library/Developer/CommandLineTools

# Verify
xcode-select --version
gcc --version
```

**Expected Results:**
- [ ] xcode-select installed successfully
- [ ] Path shows: `/Library/Developer/CommandLineTools`
- [ ] gcc/clang available
- [ ] No errors during installation

**Time:** 2-5 minutes
**Issues to watch:**
- GUI dialog appears (Click "Install")
- Password prompt (2 times if using sudo)
- Network connection required

---

### 2. Homebrew
```bash
# Check installation
brew --version

# Verify paths
which brew
# Intel: /usr/local/bin/brew
# Apple Silicon: /opt/homebrew/bin/brew

# List installed
brew list
```

**Expected Results:**
- [ ] Homebrew version displayed
- [ ] Correct path for architecture
- [ ] `brew doctor` shows no critical errors

---

### 3. Git + Core Packages
```bash
# Check Git
git --version

# Check Zsh
zsh --version

# Check Zsh plugins
ls $(brew --prefix)/share/zsh-autosuggestions/
ls $(brew --prefix)/share/zsh-syntax-highlighting/

# Check iTerm2
ls /Applications/iTerm2.app

# Check Font
ls ~/Library/Fonts/ | grep JetBrains
```

**Expected Results:**
- [ ] Git version 2.x+
- [ ] Zsh version 5.8+
- [ ] Autosuggestions plugin found
- [ ] Syntax highlighting plugin found
- [ ] iTerm2.app installed
- [ ] JetBrainsMono Nerd Font installed

---

### 4. Oh My Zsh
```bash
# Check installation
ls -la ~/.oh-my-zsh

# Check config
cat ~/.zshrc | grep "oh-my-zsh"

# Verify
echo $ZSH
```

**Expected Results:**
- [ ] Oh My Zsh directory exists
- [ ] `.zshrc` configured
- [ ] `$ZSH` variable set

---

## 🟢 Phase 2: Node.js & Package Managers

### 5. NVM + Node.js
```bash
# Check NVM
nvm --version

# List installed versions
nvm list

# Check current version
node --version
npm --version

# Test each version
for v in 16 18 20 22 24; do
  echo "Testing Node.js $v:"
  nvm use $v
  node --version
done

# Switch back to default
nvm use default
```

**Expected Results:**
- [ ] NVM version 0.40.1+
- [ ] Node.js 16, 18, 20, 22, 24 installed
- [ ] Default is Node.js 22
- [ ] npm available in all versions

---

### 6. pnpm & yarn
```bash
# Check if installed globally
pnpm --version
yarn --version

# Test in each Node version
for v in 16 18 20 22 24; do
  echo "Testing pnpm/yarn in Node.js $v:"
  nvm use $v
  pnpm --version
  yarn --version
done
```

**Expected Results:**
- [ ] pnpm installed in all Node versions
- [ ] yarn installed in all Node versions
- [ ] Both work in each version

---

## 🛠 Phase 3: Developer Tools

### 7. Docker Desktop
```bash
# Check Docker
docker --version
docker-compose --version

# Test Docker
docker run hello-world

# Check Docker Desktop app
ls /Applications/Docker.app
```

**Expected Results:**
- [ ] Docker version displayed
- [ ] docker-compose available
- [ ] hello-world runs successfully
- [ ] Docker.app installed

**Note:** Docker Desktop may need to be started manually first time

---

### 8. kubectl
```bash
# Check version
kubectl version --client

# Test completion (Tab after typing)
kubectl get po[TAB]
```

**Expected Results:**
- [ ] kubectl version displayed
- [ ] Tab completion works

---

### 9. GitHub CLI (gh)
```bash
# Check version
gh --version

# Test completion
gh pr [TAB]
```

**Expected Results:**
- [ ] gh version displayed
- [ ] Tab completion works

---

### 10. Utilities
```bash
# Check all utilities
for cmd in jq wget tree htop rsync; do
  echo "Testing $cmd:"
  which $cmd
  $cmd --version 2>/dev/null || echo "OK"
done
```

**Expected Results:**
- [ ] jq installed and working
- [ ] wget installed and working
- [ ] tree installed and working
- [ ] htop installed and working
- [ ] rsync installed and working

---

### 11. NeoHtop
```bash
# Check installation
ls /Applications/NeoHtop.app

# Test (opens GUI)
open -a NeoHtop
```

**Expected Results:**
- [ ] NeoHtop.app installed
- [ ] App opens successfully
- [ ] Shows system processes

---

### 12. Python 3
```bash
# Check version
python3 --version

# Check pip
pip3 --version
```

**Expected Results:**
- [ ] Python 3.12.x installed
- [ ] pip3 available

---

## 🗄 Phase 4: Database CLI Tools

### 13. PostgreSQL @16
```bash
# Check installation
psql --version

# Check all tools
for cmd in psql pg_dump pg_restore pg_dumpall createdb dropdb; do
  echo "Testing $cmd:"
  which $cmd
  $cmd --version
done

# Check PATH
echo $PATH | grep postgresql@16
```

**Expected Results:**
- [ ] PostgreSQL 16.x installed
- [ ] All client tools available
- [ ] PATH includes postgresql@16/bin

**Test with Docker:**
```bash
# Run PostgreSQL container
docker run -d --name test-postgres -p 5432:5432 \
  -e POSTGRES_PASSWORD=test123 postgres:16

# Wait a few seconds
sleep 5

# Test connection
psql -h localhost -U postgres -d postgres -c "SELECT version();"

# Test pg_dump
pg_dump -h localhost -U postgres postgres > /tmp/test.sql

# Cleanup
docker stop test-postgres
docker rm test-postgres
```

---

### 14. Redis CLI
```bash
# Check version
redis-cli --version

# Test with Docker
docker run -d --name test-redis -p 6379:6379 redis:7
sleep 3

# Test commands
redis-cli ping
redis-cli set testkey "Hello"
redis-cli get testkey

# Cleanup
docker stop test-redis
docker rm test-redis
```

**Expected Results:**
- [ ] redis-cli installed
- [ ] Can connect to Redis server
- [ ] Commands work properly

---

### 15. MySQL Client
```bash
# Check version
mysql --version
mysqldump --version

# Check PATH
echo $PATH | grep mysql-client
```

**Expected Results:**
- [ ] MySQL client 8.x+ installed
- [ ] mysqldump available
- [ ] PATH includes mysql-client/bin

---

### 16. MongoDB Tools
```bash
# Check mongosh
mongosh --version

# Check database tools
for cmd in mongodump mongorestore mongoexport mongoimport; do
  echo "Testing $cmd:"
  which $cmd
  $cmd --version
done
```

**Expected Results:**
- [ ] mongosh 2.x+ installed
- [ ] All database tools available

---

## ⚙️ Phase 5: DevOps Tools

### 17. Terraform
```bash
# Check version
terraform --version

# Test completion
terraform [TAB]

# Basic test
cd /tmp
terraform init
```

**Expected Results:**
- [ ] Terraform 1.x+ installed
- [ ] Tab completion works
- [ ] Can initialize

---

### 18. Helm
```bash
# Check version
helm version

# Test completion
helm [TAB]

# Add repo test
helm repo add stable https://charts.helm.sh/stable
helm repo update
```

**Expected Results:**
- [ ] Helm 3.x+ installed
- [ ] Tab completion works
- [ ] Can manage repos

---

## ✨ Phase 6: Modern CLI Tools

### 19. fzf
```bash
# Check version
fzf --version

# Test key bindings
# Press Ctrl+R (should open fzf history search)
# Press Ctrl+T (should open fzf file search)

# Check key bindings file
ls ~/.fzf.zsh
```

**Expected Results:**
- [ ] fzf 0.x+ installed
- [ ] Ctrl+R works (fuzzy history)
- [ ] Ctrl+T works (fuzzy file search)
- [ ] ~/.fzf.zsh exists

---

### 20. bat
```bash
# Check version
bat --version

# Test
bat ~/.zshrc
```

**Expected Results:**
- [ ] bat installed
- [ ] Syntax highlighting works
- [ ] Line numbers displayed

---

### 21. eza
```bash
# Check version
eza --version

# Test
eza -la
eza --tree
eza -la --git
```

**Expected Results:**
- [ ] eza installed
- [ ] Icons displayed
- [ ] Git status shown (if in git repo)
- [ ] Tree view works

---

### 22. ripgrep (rg)
```bash
# Check version
rg --version

# Test
rg "function" ~/.zshrc
rg -i "export" ~/
```

**Expected Results:**
- [ ] ripgrep installed
- [ ] Search works
- [ ] Fast results

---

### 23. fd
```bash
# Check version
fd --version

# Test
fd .zsh ~
fd -t f .sh
```

**Expected Results:**
- [ ] fd installed
- [ ] File search works

---

### 24. tldr
```bash
# Check version
tldr --version

# Test
tldr tar
tldr curl
```

**Expected Results:**
- [ ] tldr installed
- [ ] Shows simplified man pages

---

### 25. zoxide
```bash
# Check version
zoxide --version

# Test
z ~
z -l

# Usage test
cd ~/Documents
cd ~/Downloads
z doc  # Should jump to Documents
```

**Expected Results:**
- [ ] zoxide installed
- [ ] `z` command works
- [ ] Jump functionality works

---

## ⎈ Phase 7: Kubernetes Enhancement

### 26. k9s
```bash
# Check version
k9s version

# Note: Requires kubectl context to test fully
```

**Expected Results:**
- [ ] k9s installed
- [ ] Version displayed

---

### 27. kubectx
```bash
# Check installation
kubectx --version
which kubectx

# Test (if contexts available)
kubectx
```

**Expected Results:**
- [ ] kubectx installed
- [ ] Can list contexts (if any)

---

### 28. kubens
```bash
# Check installation
kubens --version
which kubens

# Test (if contexts available)
kubens
```

**Expected Results:**
- [ ] kubens installed
- [ ] Can list namespaces (if kubectl configured)

---

## 🐳 Phase 8: Docker Enhancement

### 29. lazydocker
```bash
# Check version
lazydocker --version

# Test (opens TUI)
lazydocker
```

**Expected Results:**
- [ ] lazydocker installed
- [ ] TUI opens (press 'q' to quit)

---

## 🔧 Phase 9: API Development

### 30. httpie
```bash
# Check version
http --version

# Test
http GET https://httpbin.org/get
http --json POST https://httpbin.org/post name="Test"
```

**Expected Results:**
- [ ] httpie installed
- [ ] GET request works
- [ ] POST request works
- [ ] JSON formatted output

---

## ☁️ Phase 10: Cloud Tools (Optional)

### 31. AWS CLI
```bash
# Check version (if installed)
aws --version

# Test completion
aws [TAB]
```

**Expected Results:**
- [ ] AWS CLI installed (if selected)
- [ ] Tab completion works
- [ ] Can run `aws configure`

---

### 32. Google Cloud CLI
```bash
# Check version (if installed)
gcloud --version

# Check installation path
ls ~/google-cloud-sdk

# Check PATH
echo $PATH | grep google-cloud-sdk
```

**Expected Results:**
- [ ] gcloud installed (if selected)
- [ ] Installed at ~/google-cloud-sdk
- [ ] PATH includes gcloud
- [ ] Can run `gcloud init`

---

## 🎨 Phase 11: Themes & Configurations

### 33. Tokyo Night Color Scheme
```bash
# Check file
ls ~/tokyo-night.itermcolors
cat ~/tokyo-night.itermcolors | head
```

**Expected Results:**
- [ ] File exists
- [ ] Valid XML format

**Manual Step:**
- [ ] Import in iTerm2: Preferences → Profiles → Colors → Import
- [ ] Colors look correct (dark blue background, colorful syntax)

---

### 34. Powerlevel10k Theme V2
```bash
# Check file
ls ~/.p10k.zsh

# Check loaded
cat ~/.zshrc | grep "p10k.zsh"

# Test prompt (restart terminal)
# Should show:
# - Directory on left
# - Git info (if in git repo)
# - Node.js version (if package.json exists)
# - Time on right
```

**Expected Results:**
- [ ] ~/.p10k.zsh exists
- [ ] Loaded in ~/.zshrc
- [ ] Prompt shows correctly
- [ ] Colors match Tokyo Night theme

---

### 35. Developer Aliases
```bash
# Check alias directory
ls ~/.zshrc.d/

# Test aliashelp
aliashelp

# Test aliases
ll
gs
portfind 3000
```

**Expected Results:**
- [ ] ~/.zshrc.d/ contains 4-5 files
- [ ] aliashelp command works
- [ ] All aliases function properly

---

## 🎯 Phase 12: Shell Completions

### 36. All Completions
```bash
# Check completions file
cat ~/.zshrc.d/completions.zsh

# Test each completion (press Tab after typing):
kubectl get [TAB]
helm install [TAB]
terraform [TAB]
docker run [TAB]
aws [TAB]
gh pr [TAB]

# Test fzf
# Press Ctrl+R (should show history with fzf)

# Test zoxide
z [TAB]
```

**Expected Results:**
- [ ] Completions file exists
- [ ] kubectl completion works
- [ ] helm completion works
- [ ] terraform completion works
- [ ] docker completion works
- [ ] aws completion works (if installed)
- [ ] gh completion works
- [ ] fzf key bindings work (Ctrl+R, Ctrl+T, Alt+C)
- [ ] zoxide initialization works

---

## 📦 Phase 13: Backup System

### 37. Check Backup
```bash
# Check backup directory
ls -la ~/backup-terminal/

# List backups
ls ~/backup-terminal/

# Check latest backup
LATEST=$(ls -t ~/backup-terminal/ | head -1)
ls -la ~/backup-terminal/$LATEST/
```

**Expected Results:**
- [ ] Backup directory exists
- [ ] Backup created with timestamp
- [ ] Contains: zshrc.backup, p10k.zsh.backup, zshrc.d.backup/

---

## 🔄 Phase 14: Installation Modes

### 38. Test Reinstall Mode
```bash
# Run script again
bash install.sh

# Select: 2) Reinstall
# Answer: y to confirm

# Verify:
# - New backup created
# - Files overwritten
# - Everything still works
```

**Expected Results:**
- [ ] Reinstall completes without errors
- [ ] New backup created
- [ ] Config files updated
- [ ] All tools still work

---

### 39. Test Uninstall Mode
```bash
# Run script
bash install.sh

# Select: 3) Uninstall
# Answer: y to confirm

# Verify removal:
ls ~/.p10k.zsh  # Should not exist
ls ~/.zshrc.d/  # Should not exist
cat ~/.zshrc | grep "Tea Terminal Setup"  # Should not exist

# Verify kept:
ls /Applications/iTerm2.app  # Should still exist
brew --version  # Should still work
ls ~/.oh-my-zsh/  # Should still exist
```

**Expected Results:**
- [ ] Config files removed
- [ ] Backup created before uninstall
- [ ] Homebrew still installed
- [ ] iTerm2 still installed
- [ ] Oh My Zsh still installed
- [ ] Fonts still installed

---

## ✅ Final Verification

### 40. Overall System Check
```bash
# Source fresh shell
source ~/.zshrc

# Check all critical commands
for cmd in git zsh nvm node npm docker kubectl helm terraform; do
  echo -n "Checking $cmd: "
  if command -v $cmd &>/dev/null; then
    echo "✅ OK"
  else
    echo "❌ MISSING"
  fi
done

# Test P10K prompt
cd /tmp
mkdir test-project
cd test-project
git init
touch package.json
# Prompt should show git branch and node version
```

**Expected Results:**
- [ ] All core commands available
- [ ] No errors in terminal
- [ ] Prompt displays correctly
- [ ] Theme colors correct

---

## 🐛 Common Issues & Solutions

### Issue 1: Command not found
**Symptoms:** Tools installed but not found
**Solution:**
```bash
# Check PATH
echo $PATH

# Source zshrc
source ~/.zshrc

# Restart terminal
```

### Issue 2: NVM not working
**Symptoms:** `nvm: command not found`
**Solution:**
```bash
# Check NVM directory
ls ~/.nvm

# Reload NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Add to .zshrc if missing
```

### Issue 3: Completions not working
**Symptoms:** Tab completion doesn't work
**Solution:**
```bash
# Check completions file
cat ~/.zshrc.d/completions.zsh

# Reload shell
exec zsh

# Run compinit
autoload -Uz compinit && compinit
```

### Issue 4: Docker not starting
**Symptoms:** `docker: command not found` or connection errors
**Solution:**
```bash
# Start Docker Desktop
open -a Docker

# Wait for Docker to start (30-60 seconds)
# Check status
docker ps
```

### Issue 5: Brew warnings
**Symptoms:** `brew doctor` shows warnings
**Solution:**
```bash
# Most warnings are non-critical
# Fix critical ones only:
brew doctor

# Update Homebrew
brew update
brew upgrade
```

---

## 📊 Testing Summary Template

```
===========================================
Testing Report: mac-dev-terminal-setup V7
===========================================

Test Date: _______________
Tester: _______________
macOS Version: _______________
Architecture: Intel / Apple Silicon (circle one)

Installation Mode Tested:
[ ] Install
[ ] Reinstall
[ ] Uninstall

Overall Result:
[ ] Pass - All tests successful
[ ] Pass with issues - Some non-critical issues
[ ] Fail - Critical issues found

Pass Rate: _____ / 40 tests

Critical Issues Found:
1. _______________________________________________
2. _______________________________________________
3. _______________________________________________

Non-Critical Issues:
1. _______________________________________________
2. _______________________________________________

Recommendations:
_______________________________________________
_______________________________________________
_______________________________________________

Additional Notes:
_______________________________________________
_______________________________________________
_______________________________________________

===========================================
```

---

## 📝 Notes

### Installation Time Estimates:
- **Minimal (core only):** 10-15 minutes
- **Standard (with optional groups):** 30-45 minutes
- **Full (everything):** 45-60 minutes

### Disk Space Used:
- **Core packages:** ~2-3 GB
- **With Node.js (5 versions):** ~4-5 GB
- **With Docker Desktop:** ~8-10 GB
- **Full installation:** ~12-15 GB

### Network Data Downloaded:
- **Core packages:** ~500 MB - 1 GB
- **Full installation:** ~3-5 GB

---

**Version:** V7
**Document:** TESTING_CHECKLIST.md
**Repository:** https://github.com/thaicyber/mac-dev-terminal-setup

