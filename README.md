# 🍵 mac-dev-terminal-setup
**Tea's macOS Terminal Setup — Fast, Beautiful, Productive**

สคริปต์ช่วยติดตั้ง Terminal สำหรับ macOS แบบครบชุดใน 1 คำสั่ง
เหมาะสำหรับนักพัฒนา Node.js, Backend, DevOps, Git, Docker, Kubernetes
รองรับภาษาไทย (Thai-safe UTF-8)

---

## 🚀 Quick Start

### วิธีที่ 1: Interactive Mode (แนะนำ)

```bash
curl -fsSL https://raw.githubusercontent.com/thaicyber/mac-dev-terminal-setup/main/install.sh | bash
```

จะมี Menu ให้เลือก:
- **Install** - ติดตั้งใหม่ (ไม่ทับไฟล์เดิม)
- **Reinstall** - ติดตั้งใหม่ทั้งหมด (ทับไฟล์เดิม)
- **Uninstall** - ลบการติดตั้งทั้งหมด

### วิธีที่ 2: Manual Download

```bash
git clone https://github.com/thaicyber/mac-dev-terminal-setup.git
cd mac-dev-terminal-setup
bash install.sh
```

## 🎯 Installation Modes

### 1️⃣ Install (ติดตั้งใหม่)
- ติดตั้งแพ็กเกจทั้งหมด
- **ไม่ทับ** ไฟล์ที่มีอยู่แล้ว (เช่น `.p10k.zsh`, `.zshrc.d/*.zsh`)
- เหมาะสำหรับผู้ใช้ใหม่
- สร้าง backup อัตโนมัติที่ `~/backup-terminal`

### 2️⃣ Reinstall (ติดตั้งใหม่ทั้งหมด)
- ติดตั้งแพ็กเกจทั้งหมด
- **ทับไฟล์เดิม** ทั้งหมด
- เหมาะสำหรับการอัปเดตหรือแก้ไขปัญหา
- สร้าง backup อัตโนมัติก่อนทับ

### 3️⃣ Uninstall (ลบการติดตั้ง)
- ลบไฟล์ทั้งหมดที่สคริปต์สร้าง
- **ไม่ลบ**: Homebrew, iTerm2, Oh My Zsh, Fonts
- สร้าง backup อัตโนมัติก่อนลบ
- ปลอดภัย สามารถกู้คืนได้

---

## 🔄 Installation Flow

สคริปต์จะติดตั้งตามลำดับดังนี้:

```
1. 🔧 Command Line Tools (xcode-select)
   └─ ตรวจสอบและติดตั้งอัตโนมัติ (ถ้ายังไม่มี)

2. 🍺 Homebrew
   └─ ตรวจสอบและติดตั้งอัตโนมัติ (ถ้ายังไม่มี)

3. 📦 Git + Core Packages
   ├─ Git (version control)
   ├─ Zsh (shell)
   ├─ Zsh Plugins (autosuggestions + syntax-highlighting)
   ├─ iTerm2 (terminal emulator)
   └─ JetBrainsMono Nerd Font

4. 💡 Oh My Zsh
   └─ ติดตั้งอัตโนมัติ (ถ้ายังไม่มี)

5. 🟢 NVM + Node.js (Optional)
   ├─ ✅ ถามผู้ใช้: "ติดตั้ง NVM และ Node.js? [y/N]"
   ├─ ติดตั้ง NVM (Node Version Manager)
   ├─ ติดตั้ง Node.js versions: 16, 18, 20, 22, 24
   ├─ ตั้ง default เป็น version 22
   └─ ✅ ถามผู้ใช้: "ติดตั้ง pnpm และ yarn? [y/N]"
      └─ ติดตั้ง pnpm + yarn ในทุก Node.js version

6. 🛠 Developer Tools (Optional)
   ├─ ✅ ถามผู้ใช้: "ติดตั้ง Developer Tools? [y/N]"
   ├─ Docker Desktop (containerization)
   ├─ kubectl (Kubernetes CLI)
   ├─ GitHub CLI (gh)
   ├─ Utilities: jq, wget, tree, htop, rsync
   ├─ NeoHtop (modern system monitor GUI)
   └─ Python 3.12

7. 🗄 Database CLI Tools (Optional)
   ├─ ✅ ถามผู้ใช้: "ติดตั้ง Database CLI? [y/N]"
   ├─ PostgreSQL @16 client (psql, pg_dump, pg_restore)
   └─ Redis CLI (redis-cli)
   💡 Note: CLI only, ใช้ Docker สำหรับ servers

8. ⚙️  DevOps Tools (Optional)
   ├─ ✅ ถามผู้ใช้: "ติดตั้ง DevOps Tools? [y/N]"
   ├─ Terraform (Infrastructure as Code)
   └─ Helm (Kubernetes package manager)

9. ✨ Modern CLI Tools (Optional) ← ใหม่!
   ├─ ✅ ถามผู้ใช้: "ติดตั้ง Modern CLI Tools? [y/N]"
   ├─ fzf (fuzzy finder)
   ├─ bat (better cat)
   ├─ eza (better ls)
   ├─ ripgrep (better grep)
   ├─ fd (better find)
   ├─ tldr (simplified man pages)
   └─ zoxide (smart cd)

10. ⎈ Kubernetes Enhancement (Optional) ← ใหม่!
    ├─ ✅ ถามผู้ใช้: "ติดตั้ง Kubernetes Enhancement? [y/N]"
    ├─ k9s (K8s TUI)
    ├─ kubectx (context switcher)
    └─ kubens (namespace switcher)

11. 🐳 Docker Enhancement (Optional) ← ใหม่!
    ├─ ✅ ถามผู้ใช้: "ติดตั้ง Docker Enhancement? [y/N]"
    └─ lazydocker (Docker TUI)

12. 🗄  Extra Database Clients (Optional) ← ใหม่!
    ├─ ✅ ถามผู้ใช้: "ติดตั้ง Extra Database Clients? [y/N]"
    ├─ MySQL client (mysql, mysqldump)
    ├─ MongoDB Shell (mongosh)
    └─ MongoDB Tools (mongodump, mongorestore)

13. 🔧 API Development Tools (Optional) ← ใหม่!
    ├─ ✅ ถามผู้ใช้: "ติดตั้ง API Development Tools? [y/N]"
    └─ httpie (better curl)

14. ☁️  Cloud Tools (Optional)
    ├─ AWS CLI
    │  ├─ ✅ ถามผู้ใช้: "ติดตั้ง AWS CLI? [y/N]"
    │  └─ ติดตั้งผ่าน Homebrew
    └─ Google Cloud CLI
       ├─ ✅ ถามผู้ใช้: "ติดตั้ง Google Cloud CLI? [y/N]"
       ├─ ตรวจสอบ architecture (Intel/Apple Silicon)
       ├─ ดาวน์โหลด official installer
       └─ ติดตั้งที่ ~/google-cloud-sdk

15. 🎨 Themes & Configurations
    ├─ ดาวน์โหลด Tokyo Night color scheme
    ├─ ดาวน์โหลด P10K Theme V2
    ├─ สร้าง Developer Aliases
    └─ อัปเดต ~/.zshrc

16. 🎯 Shell Completions (Optional) ← ใหม่!
    ├─ ✅ ถามผู้ใช้: "ติดตั้ง Shell Completions? [y/N]"
    ├─ kubectl completion
    ├─ helm completion
    ├─ terraform completion
    ├─ docker completion
    ├─ aws completion
    ├─ gh completion
    ├─ fzf key bindings
    └─ zoxide initialization
```

### 📝 **หมายเหตุ:**
- ✅ **มีการถาม (Optional)** = ผู้ใช้สามารถเลือกติดตั้งหรือข้ามได้
- ⚡ **Default คือ "N"** = กด Enter โดยไม่ตอบจะข้ามการติดตั้ง
- 🔍 **Smart Detection** = ถ้าติดตั้งแล้ว จะข้ามและแจ้งว่า "already installed"
- ✨ **V7 เพิ่ม 6 กลุ่มใหม่** = Modern CLI, K8s/Docker Enhancement, Extra DBs, API Tools, Completions

### 📊 **สรุปส่วนที่มีการถาม:**

| ขั้นตอน | มีการถาม? | Default | ผลถ้ากด Enter |
|---------|----------|---------|---------------|
| Command Line Tools | ❌ | Auto | ติดตั้งอัตโนมัติ |
| Homebrew | ❌ | Auto | ติดตั้งอัตโนมัติ |
| Git + Packages | ❌ | Auto | ติดตั้งอัตโนมัติ |
| Oh My Zsh | ❌ | Auto | ติดตั้งอัตโนมัติ |
| **NVM + Node.js** | ✅ | **N** | ข้ามการติดตั้ง |
| **pnpm + yarn** | ✅ | **N** | ข้ามการติดตั้ง |
| **Developer Tools** | ✅ | **N** | ข้ามการติดตั้ง |
| **Database CLI** | ✅ | **N** | ข้ามการติดตั้ง |
| **DevOps Tools** | ✅ | **N** | ข้ามการติดตั้ง |
| **Modern CLI Tools** ✨ | ✅ | **N** | ข้ามการติดตั้ง |
| **K8s Enhancement** ✨ | ✅ | **N** | ข้ามการติดตั้ง |
| **Docker Enhancement** ✨ | ✅ | **N** | ข้ามการติดตั้ง |
| **Extra Databases** ✨ | ✅ | **N** | ข้ามการติดตั้ง |
| **API Tools** ✨ | ✅ | **N** | ข้ามการติดตั้ง |
| **AWS CLI** | ✅ | **N** | ข้ามการติดตั้ง |
| **Google Cloud CLI** | ✅ | **N** | ข้ามการติดตั้ง |
| Themes & Configs | ❌ | Auto | ติดตั้งอัตโนมัติ |
| **Shell Completions** ✨ | ✅ | **N** | ข้ามการติดตั้ง |

---

## 📦 Backup System

สคริปต์จะสร้าง backup อัตโนมัติทุกครั้งที่:
- ติดตั้ง (Install)
- ติดตั้งใหม่ (Reinstall)
- ลบ (Uninstall)

**ตำแหน่ง Backup:**
```
~/backup-terminal/YYYYMMDD_HHMMSS/
├── zshrc.backup
├── p10k.zsh.backup
├── zshrc.d.backup/
└── tokyo-night.itermcolors.backup
```

---

## 📋 หลังติดตั้ง ทำ 3 ขั้นตอนนี้

### 1️⃣ Import Tokyo Night Color Scheme
```
iTerm2 → Preferences → Profiles → Colors → Import...
```
เลือกไฟล์: `~/tokyo-night.itermcolors`

### 2️⃣ ตั้งค่า Font
```
iTerm2 → Preferences → Profiles → Text
```
เลือก Font: **JetBrainsMono Nerd Font**

### 3️⃣ Restart iTerm2
ปิดและเปิด iTerm2 ใหม่ แล้วทดสอบด้วย:
```bash
aliashelp
```

🎉 **พร้อมใช้งาน!**

---

## 📁 โครงสร้างโปรเจกต์

```
mac-dev-terminal-setup/
├── .gitignore
├── install.sh
├── p10k-tea-tokyonight-one-line.zsh
├── tokyo-night.itermcolors
└── README.md
```

---

## 🧩 สิ่งที่ install.sh ทำให้อัตโนมัติ

### ✔ ติดตั้งอัตโนมัติ:
- **Command Line Tools (xcode-select)** - Prerequisites สำหรับ macOS development
- **Homebrew** (ถ้ายังไม่มี)
- **Git** - Version control system
- **iTerm2**
- **Zsh**
- **Oh My Zsh**
- **Zsh Plugins**
  - autosuggestions
  - syntax highlighting
- **JetBrainsMono Nerd Font** (สำหรับแสดง icon)

### ✔ ติดตั้งแบบเลือกได้ (Optional):
- **NVM (Node Version Manager)** - จัดการ Node.js versions
  - ติดตั้ง Node.js versions: 16, 18, 20, **22** (default), 24
  - สามารถสลับ version ได้ง่าย
  - ติดตั้งที่ `~/.nvm`
- **AWS CLI** - Amazon Web Services Command Line Interface (via Homebrew)
- **Google Cloud CLI** - Google Cloud SDK (via official installer)
  - รองรับทั้ง Intel และ Apple Silicon
  - ติดตั้งที่ `~/google-cloud-sdk`

### ✔ ดาวน์โหลดและติดตั้ง:
- **Tokyo Night Color Scheme** → `~/tokyo-night.itermcolors` (ต้อง import เอง)
- **Tea P10K Theme V2** → `~/.p10k.zsh` (ติดตั้งอัตโนมัติ)

### ✔ ตั้งค่า Thai-safe UTF-8:
```bash
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
```

### ✔ สร้าง Developer Shortcuts (+ aliashelp)
ระบบสร้างไฟล์:

```
~/.zshrc.d/
│── aliashelp.zsh
│── dev-alias.zsh
│── docker-alias.zsh
│── git-alias.zsh
└── system-monitor.zsh
```

ตัวอย่าง alias:

| คำสั่ง | อธิบาย |
|--------|--------|
| `ll` | list ไฟล์แบบละเอียด |
| `gs` | git status |
| `gp` | git pull |
| `gc` | git commit |
| `gl` | git log (graph) |
| `dps` | docker ps |
| `dimg` | docker images |
| `topcpu` | แสดง process ที่กิน CPU สูงสุด |
| `topram` | แสดง process ที่กิน RAM สูงสุด |
| `portfind 3000` | หา process ที่ใช้ port 3000 |

ดู shortcuts ทั้งหมดได้ด้วย:

```bash
aliashelp
```

---

## 📦 Package Managers (pnpm & yarn)

หลังติดตั้ง pnpm และ yarn จะพร้อมใช้งานในทุก Node.js version:

### คำสั่งพื้นฐาน:

```bash
# pnpm (เร็วกว่า npm, ประหยัดพื้นที่)
pnpm install              # ติดตั้ง dependencies
pnpm add express          # เพิ่ม package
pnpm remove express       # ลบ package
pnpm run dev              # รัน script

# yarn (popular alternative)
yarn install              # ติดตั้ง dependencies
yarn add express          # เพิ่ม package
yarn remove express       # ลบ package
yarn dev                  # รัน script
```

### เปรียบเทียบ:

| คำสั่ง | npm | pnpm | yarn |
|--------|-----|------|------|
| Install | `npm install` | `pnpm install` | `yarn install` |
| Add | `npm install pkg` | `pnpm add pkg` | `yarn add pkg` |
| Remove | `npm uninstall pkg` | `pnpm remove pkg` | `yarn remove pkg` |
| Run script | `npm run dev` | `pnpm run dev` | `yarn dev` |
| Global install | `npm install -g` | `pnpm add -g` | `yarn global add` |

---

## 🛠 Developer Tools

### 🐳 **Docker**
```bash
# ตรวจสอบ version
docker --version

# รัน container
docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=password postgres:16
docker run -d -p 6379:6379 redis:7

# ดู containers ที่รันอยู่
docker ps

# หยุด container
docker stop <container_id>

# ลบ container
docker rm <container_id>

# ดู images
docker images

# ลบ image
docker rmi <image_id>
```

### ⎈ **kubectl (Kubernetes)**
```bash
# ตรวจสอบ version
kubectl version --client

# ดู clusters
kubectl config get-contexts

# สลับ context
kubectl config use-context <context-name>

# ดู pods
kubectl get pods

# ดู services
kubectl get services

# ดู logs
kubectl logs <pod-name>

# เข้าไปใน pod
kubectl exec -it <pod-name> -- /bin/bash
```

### 🐙 **GitHub CLI (gh)**
```bash
# Login
gh auth login

# Clone repo
gh repo clone owner/repo

# Create PR
gh pr create

# ดู PR
gh pr list

# Merge PR
gh pr merge <number>

# Create issue
gh issue create

# ดู issues
gh issue list
```

### 🔧 **Utilities**

#### **jq** - JSON processor
```bash
# Parse JSON
echo '{"name":"Tea","age":30}' | jq '.'

# Extract field
echo '{"name":"Tea","age":30}' | jq '.name'

# Filter array
echo '[{"name":"Tea"},{"name":"Coffee"}]' | jq '.[0]'

# From file
cat data.json | jq '.users[] | select(.age > 25)'

# Pretty print
curl -s https://api.github.com/users/github | jq '.'
```

#### **wget** - Download files
```bash
# Download file
wget https://example.com/file.zip

# Download with custom name
wget -O myfile.zip https://example.com/file.zip

# Continue interrupted download
wget -c https://example.com/largefile.iso

# Download entire website
wget -r -np -k https://example.com
```

#### **tree** - Directory visualization
```bash
# Show directory structure
tree

# Limit depth
tree -L 2

# Show hidden files
tree -a

# Show only directories
tree -d

# Ignore node_modules
tree -I 'node_modules|dist|build'

# Show file sizes
tree -h
```

#### **htop** - Process monitor
```bash
# Run htop
htop

# Keyboard shortcuts:
# F1 - Help
# F2 - Setup
# F3 - Search
# F4 - Filter
# F5 - Tree view
# F6 - Sort by
# F9 - Kill process
# F10 - Quit
# Space - Tag process
```

#### **neohtop** - Modern System Monitor (GUI)

[NeoHtop](https://github.com/Abdenasser/neohtop) เป็น system monitor แบบ GUI ที่สวยงามและทันสมัย สร้างด้วย Rust, Tauri และ Svelte

**Features:**
- 🚀 Real-time process monitoring
- 💻 CPU และ Memory usage tracking
- 🎨 UI สวยงาม รองรับ dark/light themes
- 🔍 ค้นหาและกรอง processes ได้
- 📌 Pin processes สำคัญ
- 🛠 จัดการ processes (kill)
- 🎯 เรียงตาม column ต่างๆ
- 🔄 Auto-refresh

**การใช้งาน:**
```bash
# เปิด NeoHtop (GUI)
open -a NeoHtop

# หรือจาก Applications
# Applications → NeoHtop

# สำหรับ monitoring processes ที่ต้องใช้ sudo
sudo /Applications/NeoHtop.app/Contents/MacOS/NeoHtop
```

**ทำไมต้องใช้ neohtop?**
- 🎯 UI สวยกว่า `htop` และ `top`
- 🚀 เร็วกว่า (เขียนด้วย Rust)
- 🔍 ค้นหาได้ดีกว่า (รองรับ regex)
- 📊 แสดง graphs แบบ real-time
- 🎨 Modern design

**Alternative:**
- CLI: `htop`, `btop`
- GUI: `Activity Monitor` (macOS built-in)

#### **rsync** - Fast file sync
```bash
# Basic sync (local)
rsync -av source/ destination/

# Sync with delete (make destination identical)
rsync -av --delete source/ destination/

# Dry run (test without actual sync)
rsync -av --dry-run source/ destination/

# Show progress
rsync -av --progress source/ destination/

# Sync to remote server
rsync -av source/ user@remote:/path/to/destination/

# Sync from remote server
rsync -av user@remote:/path/to/source/ destination/

# Exclude files/folders
rsync -av --exclude='node_modules' --exclude='.git' source/ destination/

# Sync only specific files
rsync -av --include='*.js' --exclude='*' source/ destination/

# Common options:
# -a : archive mode (preserve permissions, timestamps, etc.)
# -v : verbose
# -z : compress during transfer
# -h : human-readable numbers
# --progress : show progress
# --delete : delete files in destination that don't exist in source
```

**💡 Use cases:**
```bash
# Backup to external drive
rsync -avh --progress ~/Documents/ /Volumes/Backup/Documents/

# Deploy to server (exclude dev files)
rsync -avz --exclude='node_modules' --exclude='.env' \
  ~/myapp/ user@server:/var/www/myapp/

# Mirror directory exactly
rsync -av --delete source/ destination/
```

---

## ✨ Modern CLI Tools (Productivity Boost)

เครื่องมือ CLI สมัยใหม่ที่ช่วยเพิ่ม productivity:

### 🔍 **fzf** - Fuzzy Finder
```bash
# ค้นหา command history (กด Ctrl+R)
# พิมพ์คำค้นหาแบบ fuzzy

# ค้นหาไฟล์และเปิดด้วย vim
vim $(fzf)

# ค้นหาและ cd เข้าโฟลเดอร์
cd $(find . -type d | fzf)

# ค้นหา process และ kill
kill -9 $(ps aux | fzf | awk '{print $2}')

# Git branch switcher
git checkout $(git branch | fzf)

# Key bindings (ติดตั้งอัตโนมัติ):
# Ctrl+R : ค้นหา command history
# Ctrl+T : ค้นหาไฟล์ และใส่ลงใน command line
# Alt+C  : ค้นหาและ cd เข้าโฟลเดอร์
```

### 🦇 **bat** - Better cat
```bash
# แสดงไฟล์พร้อม syntax highlighting
bat file.js

# แสดงพร้อมเลขบรรทัด
bat -n file.py

# แสดงแบบ plain (ไม่มีสี)
bat -p file.txt

# ใช้แทน cat ใน pipe
cat file.json | bat -l json

# แสดงหลายไฟล์
bat *.md
```

### 📁 **eza** - Better ls
```bash
# List ธรรมดา (สีสวย icons)
eza

# แสดงแบบละเอียด
eza -l

# แสดง tree structure
eza --tree

# แสดง git status
eza -l --git

# แสดง hidden files
eza -a

# แสดงทุกอย่าง พร้อม git status
eza -la --git

# สร้าง alias แทน ls (เพิ่มใน ~/.zshrc.d/dev-alias.zsh)
alias ls="eza"
alias ll="eza -la --git"
```

### 🔎 **ripgrep (rg)** - Better grep
```bash
# ค้นหาคำใน files (เร็วกว่า grep มาก)
rg "function"

# ค้นหาใน specific file types
rg "TODO" -t js

# ค้นหาแบบ case-insensitive
rg -i "error"

# แสดงเฉพาะชื่อไฟล์
rg -l "import"

# ค้นหาและแสดง context
rg -C 3 "database"  # แสดง 3 บรรทัดรอบๆ

# ค้นหาใน specific directory
rg "API" src/

# Exclude directories
rg "test" --glob '!node_modules'
```

### 🔍 **fd** - Better find
```bash
# ค้นหาไฟล์
fd filename

# ค้นหาแบบ pattern
fd ".js$"

# ค้นหา directories เท่านั้น
fd -t d folder

# ค้นหา files เท่านั้น
fd -t f

# ค้นหา hidden files
fd -H config

# ค้นหาและ execute command
fd ".log$" -x rm {}

# Exclude directories
fd "test" --exclude node_modules
```

### 📖 **tldr** - Simplified Man Pages
```bash
# แสดง cheat sheet ของคำสั่ง
tldr tar
tldr curl
tldr git
tldr docker

# อัปเดต cache
tldr --update

# List all commands
tldr --list
```

### 🚀 **zoxide** - Smart cd
```bash
# cd ตามปกติ (zoxide จะจำ)
cd ~/Projects/myapp

# ภายหลัง jump ไปที่โฟลเดอร์ที่ใช้บ่อย
z myapp          # จะ jump ไปที่ ~/Projects/myapp

# แสดง ranking ของโฟลเดอร์
z -l

# Jump ไปที่โฟลเดอร์ที่ match
z proj           # จะ jump ไปที่ ~/Projects (ถ้าใช้บ่อย)

# Interactive selection (ถ้ามีหลาย match)
zi proj

# สร้าง alias (แนะนำ)
alias cd="z"     # ใช้ z แทน cd
```

---

## ⎈ Kubernetes Enhancement Tools

เครื่องมือเสริมสำหรับจัดการ Kubernetes:

### 🐶 **k9s** - Kubernetes TUI
```bash
# เปิด k9s (Terminal UI)
k9s

# Keyboard shortcuts:
# :pods     - แสดง pods
# :svc      - แสดง services
# :deploy   - แสดง deployments
# :ns       - แสดง namespaces
# /         - ค้นหา
# l         - แสดง logs
# d         - describe resource
# e         - edit resource
# shift+d   - delete resource
# ?         - help
# :quit     - ออก

# เปิดใน specific namespace
k9s -n production

# เปิดใน specific context
k9s --context staging
```

### 🔄 **kubectx** - Context Switcher
```bash
# แสดง contexts ทั้งหมด
kubectx

# สลับไปยัง context
kubectx production
kubectx staging

# กลับไปยัง context ก่อนหน้า
kubectx -

# แสดง current context
kubectx -c

# สร้าง alias ใหม่
kubectx my-cluster=arn:aws:eks:...

# สร้าง alias สั้นๆ
alias kctx="kubectx"
```

### 📦 **kubens** - Namespace Switcher
```bash
# แสดง namespaces ทั้งหมด
kubens

# สลับไปยัง namespace
kubens production
kubens default

# กลับไปยัง namespace ก่อนหน้า
kubens -

# แสดง current namespace
kubens -c

# สร้าง alias สั้นๆ
alias kns="kubens"
```

**💡 Workflow ที่แนะนำ:**
```bash
# 1. Switch context
kubectx production

# 2. Switch namespace
kubens api

# 3. เปิด k9s ดู resources
k9s

# หรือใช้ kubectl ตามปกติ
kubectl get pods
```

---

## 🐳 Docker Enhancement Tools

### 🐋 **lazydocker** - Docker TUI
```bash
# เปิด lazydocker
lazydocker

# Features:
# - ดู containers, images, volumes, networks
# - ดู logs real-time
# - Start/stop/restart containers
# - Remove containers/images
# - ดู resource usage (CPU, RAM)
# - Execute commands ใน container

# Keyboard shortcuts:
# Tab       - สลับ panel
# Enter     - เปิด detail/logs
# e         - execute command in container
# d         - delete container/image
# s         - start/stop container
# r         - restart container
# l         - แสดง logs
# q         - ออก
# ?         - help
```

---

## 🗄 Extra Database Clients

### 🐬 **MySQL Client**
```bash
# Connect to database
mysql -h localhost -u root -p mydb

# Connect with password
mysql -h localhost -u root -pPassword123 mydb

# Execute query
mysql -h localhost -u root -p -e "SELECT * FROM users"

# Import SQL file
mysql -h localhost -u root -p mydb < backup.sql

# Export database (mysqldump)
mysqldump -h localhost -u root -p mydb > backup.sql

# Export structure only
mysqldump -h localhost -u root -p --no-data mydb > structure.sql

# Export data only
mysqldump -h localhost -u root -p --no-create-info mydb > data.sql

# Export specific tables
mysqldump -h localhost -u root -p mydb users orders > tables.sql

# Backup all databases
mysqldump -h localhost -u root -p --all-databases > all_backup.sql
```

### 🍃 **MongoDB Shell (mongosh)**
```bash
# Connect to MongoDB
mongosh

# Connect to remote
mongosh "mongodb://localhost:27017"

# Connect with authentication
mongosh "mongodb://user:password@localhost:27017/mydb"

# Show databases
show dbs

# Use database
use mydb

# Show collections
show collections

# Find documents
db.users.find()

# Find with query
db.users.find({ age: { $gt: 25 } })

# Insert document
db.users.insertOne({ name: "Tea", age: 30 })

# Update document
db.users.updateOne({ name: "Tea" }, { $set: { age: 31 } })

# Delete document
db.users.deleteOne({ name: "Tea" })

# Exit
exit
```

### 🛠 **MongoDB Database Tools**
```bash
# Backup database (mongodump)
mongodump --db mydb --out /backup/

# Backup specific collection
mongodump --db mydb --collection users --out /backup/

# Backup with authentication
mongodump --uri "mongodb://user:pass@localhost:27017/mydb" --out /backup/

# Restore database (mongorestore)
mongorestore --db mydb /backup/mydb/

# Restore specific collection
mongorestore --db mydb --collection users /backup/mydb/users.bson

# Restore from compressed backup
mongorestore --gzip --archive=/backup/mydb.gz

# Export to JSON (mongoexport)
mongoexport --db mydb --collection users --out users.json

# Import from JSON (mongoimport)
mongoimport --db mydb --collection users --file users.json
```

---

## 🔧 API Development Tools

### 🌐 **httpie** - Human-Friendly HTTP Client

httpie เป็น alternative ของ curl ที่ใช้งานง่ายกว่า:

```bash
# GET request
http GET https://api.github.com/users/github

# POST request with JSON
http POST https://api.example.com/users name="Tea" email="tea@example.com"

# POST with headers
http POST https://api.example.com/data \
  Authorization:"Bearer token123" \
  Content-Type:application/json \
  name="Tea"

# PUT request
http PUT https://api.example.com/users/1 name="Tea Updated"

# DELETE request
http DELETE https://api.example.com/users/1

# Download file
http --download https://example.com/file.zip

# Upload file
http --form POST https://api.example.com/upload file@/path/to/file.jpg

# Set custom headers
http GET https://api.example.com/data \
  User-Agent:MyApp/1.0 \
  Accept:application/json

# Follow redirects
http --follow GET https://example.com

# Session support (cookies)
http --session=user1 POST https://api.example.com/login username="tea" password="pass"
http --session=user1 GET https://api.example.com/profile

# Pretty print JSON
http GET https://api.example.com/data | jq '.'

# Verbose output (show request/response)
http -v GET https://api.example.com
```

**เปรียบเทียบกับ curl:**

| Task | curl | httpie |
|------|------|--------|
| GET | `curl https://api.com/users` | `http GET https://api.com/users` |
| POST JSON | `curl -X POST -H "Content-Type: application/json" -d '{"name":"Tea"}'` | `http POST https://api.com/users name=Tea` |
| Headers | `curl -H "Authorization: Bearer token"` | `http GET https://api.com Authorization:"Bearer token"` |
| Download | `curl -O https://file.zip` | `http --download https://file.zip` |

---

## 🎯 Shell Completions

หลังติดตั้ง Shell Completions จะได้:

### ⚡ **Tab Completion**
```bash
# kubectl - กด Tab เพื่อ auto-complete
kubectl get po<Tab>        # → pods
kubectl get pods -n <Tab>  # → แสดง namespaces
kubectl logs <Tab>         # → แสดง pod names

# helm - กด Tab เพื่อ auto-complete
helm install <Tab>         # → แสดง chart names
helm upgrade <Tab>         # → แสดง release names

# terraform - กด Tab เพื่อ auto-complete
terraform <Tab>            # → แสดง subcommands
terraform init -<Tab>      # → แสดง flags

# docker - กด Tab เพื่อ auto-complete
docker <Tab>               # → แสดง commands
docker run <Tab>           # → แสดง image names

# aws - กด Tab เพื่อ auto-complete
aws <Tab>                  # → แสดง services
aws s3 <Tab>               # → แสดง subcommands

# gh - กด Tab เพื่อ auto-complete
gh pr <Tab>                # → แสดง subcommands
gh repo <Tab>              # → แสดง subcommands
```

### 🔍 **fzf Key Bindings**
```bash
# Ctrl+R : ค้นหา command history แบบ interactive
# Ctrl+T : ค้นหาไฟล์ และใส่ path ลงใน command
# Alt+C  : ค้นหาและ cd เข้าโฟลเดอร์
```

### 🚀 **zoxide Alias**
```bash
# z command พร้อมใช้งาน
z myproject    # jump to ~/Projects/myproject
zi proj        # interactive selection
```

**💡 หมายเหตุ:**
- Completions จะโหลดอัตโนมัติเมื่อเปิด terminal ใหม่
- ถ้าไม่ทำงาน ให้รัน: `source ~/.zshrc`
- ไฟล์ completions อยู่ที่: `~/.zshrc.d/completions.zsh`

---

## 🗄 Database CLI Tools

### 🐘 **PostgreSQL Client Tools**

PostgreSQL @16 มี tools ครบชุด:
- `psql` - Interactive terminal
- `pg_dump` - Backup database
- `pg_restore` - Restore database
- `pg_dumpall` - Backup all databases
- `createdb`, `dropdb` - Database management

#### **psql** - Interactive Terminal
```bash
# Connect to database
psql -h localhost -U postgres -d mydb

# Connect with URL
psql postgresql://user:password@localhost:5432/mydb

# List databases
\l

# Connect to database
\c dbname

# List tables
\dt

# Describe table
\d tablename

# Execute query
SELECT * FROM users;

# Execute SQL file
\i script.sql

# Exit
\q
```

#### **pg_dump** - Backup Database
```bash
# Backup single database
pg_dump -h localhost -U postgres mydb > mydb_backup.sql

# Backup with custom format (compressed)
pg_dump -h localhost -U postgres -F c mydb > mydb_backup.dump

# Backup specific tables
pg_dump -h localhost -U postgres -t users -t orders mydb > tables_backup.sql

# Backup schema only (no data)
pg_dump -h localhost -U postgres --schema-only mydb > schema.sql

# Backup data only (no schema)
pg_dump -h localhost -U postgres --data-only mydb > data.sql

# Backup with INSERT statements (portable)
pg_dump -h localhost -U postgres --column-inserts mydb > mydb_inserts.sql

# Backup from remote server
pg_dump -h remote.server.com -U postgres -W mydb > remote_backup.sql

# Backup with progress (PostgreSQL 13+)
pg_dump -h localhost -U postgres --verbose mydb > mydb_backup.sql
```

#### **pg_restore** - Restore Database
```bash
# Restore from custom format
pg_restore -h localhost -U postgres -d mydb mydb_backup.dump

# Restore with clean (drop existing objects)
pg_restore -h localhost -U postgres -d mydb --clean mydb_backup.dump

# Restore specific tables
pg_restore -h localhost -U postgres -d mydb -t users mydb_backup.dump

# Restore to new database
createdb newdb
pg_restore -h localhost -U postgres -d newdb mydb_backup.dump

# Restore from SQL file
psql -h localhost -U postgres mydb < mydb_backup.sql

# Restore with transaction (rollback on error)
psql -h localhost -U postgres mydb --single-transaction < mydb_backup.sql
```

#### **pg_dumpall** - Backup All Databases
```bash
# Backup entire cluster
pg_dumpall -h localhost -U postgres > all_databases.sql

# Backup only globals (roles, tablespaces)
pg_dumpall -h localhost -U postgres --globals-only > globals.sql

# Backup only roles
pg_dumpall -h localhost -U postgres --roles-only > roles.sql
```

#### **Database Management**
```bash
# Create database
createdb -h localhost -U postgres mydb

# Drop database
dropdb -h localhost -U postgres mydb

# Create database with encoding
createdb -h localhost -U postgres -E UTF8 mydb
```

**💡 Practical Examples:**
```bash
# Daily backup script
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
pg_dump -h localhost -U postgres -F c mydb > backup_${DATE}.dump

# Backup and compress
pg_dump -h localhost -U postgres mydb | gzip > mydb_backup.sql.gz

# Restore from compressed backup
gunzip -c mydb_backup.sql.gz | psql -h localhost -U postgres mydb

# Copy database to another server
pg_dump -h source.server -U postgres mydb | psql -h dest.server -U postgres newdb

# Backup with Docker
docker exec postgres_container pg_dump -U postgres mydb > backup.sql

# Restore to Docker
cat backup.sql | docker exec -i postgres_container psql -U postgres mydb
```

### 🔴 **Redis CLI**
```bash
# Connect to Redis
redis-cli

# Connect to remote
redis-cli -h hostname -p 6379

# Set key
SET mykey "Hello"

# Get key
GET mykey

# List all keys
KEYS *

# Delete key
DEL mykey

# Check if key exists
EXISTS mykey

# Set with expiration (seconds)
SETEX mykey 3600 "value"

# Get TTL
TTL mykey

# Flush all data (careful!)
FLUSHALL

# Exit
exit
```

**💡 Note:** ใช้ Docker สำหรับรัน PostgreSQL และ Redis servers:
```bash
# PostgreSQL
docker run -d --name postgres -p 5432:5432 -e POSTGRES_PASSWORD=password postgres:16

# Redis
docker run -d --name redis -p 6379:6379 redis:7
```

---

## ⚙️  DevOps Tools

### 🏗 **Terraform**
```bash
# Initialize
terraform init

# Plan changes
terraform plan

# Apply changes
terraform apply

# Destroy infrastructure
terraform destroy

# Format code
terraform fmt

# Validate configuration
terraform validate

# Show current state
terraform show

# List resources
terraform state list
```

### ⛵ **Helm**
```bash
# Add repository
helm repo add stable https://charts.helm.sh/stable

# Update repositories
helm repo update

# Search charts
helm search repo nginx

# Install chart
helm install my-release stable/nginx

# List releases
helm list

# Upgrade release
helm upgrade my-release stable/nginx

# Uninstall release
helm uninstall my-release

# Get values
helm get values my-release
```

---

## 🟢 Node.js Management (NVM)

หลังติดตั้ง NVM จะมี Node.js versions:
- Node.js **16** (LTS Maintenance)
- Node.js **18** (LTS)
- Node.js **20** (LTS Active)
- Node.js **22** (LTS) ← **Default**
- Node.js **24** (Current)

### คำสั่ง NVM ที่ใช้บ่อย:

```bash
# ดู versions ที่ติดตั้งแล้ว
nvm list

# ดู version ปัจจุบันที่ใช้อยู่
node --version

# สลับ version
nvm use 18         # ใช้ Node.js 18
nvm use 20         # ใช้ Node.js 20
nvm use default    # กลับไปใช้ default (22)

# ตั้ง default version ใหม่
nvm alias default 20

# ติดตั้ง version ใหม่
nvm install 23

# ลบ version
nvm uninstall 16

# ติดตั้ง version ล่าสุด
nvm install node
```

### ใช้ Node.js version ต่างกันแต่ละโปรเจกต์:

```bash
# สร้างไฟล์ .nvmrc ในโปรเจกต์
echo "20" > .nvmrc

# เมื่อเข้าโฟลเดอร์ ให้รัน:
nvm use
# จะใช้ version ตาม .nvmrc อัตโนมัติ
```

---

## 🎨 Powerlevel10k Theme (Tea Edition V2 - Enhanced)

ไฟล์ theme:

- `p10k-tea-tokyonight-one-line.zsh` **(V2)**

### จุดเด่น:

#### 🎯 Core Features
- Layout แบบ **One-line Minimal** (ไม่บดบัง console.log)
- โทนสี **Tokyo Night** ทุก segment
- **Thai-safe** UTF-8 รองรับภาษาไทยเต็มรูปแบบ
- ใช้ **Nerd Font** เต็มระบบ
- **Instant Prompt** โหลดเร็วทันที

#### 📊 Left Prompt
- **Directory** - แสดง current directory
- **Git** - แสดง branch, status, changes

#### 🛠 Right Prompt (Enhanced for DevOps)
- **Status** - แสดง exit code (เมื่อ error)
- **Execution Time** - แสดงเวลาการรัน (> 1.2 วินาที)
- **Background Jobs** - แสดงจำนวน jobs ที่รันอยู่
- **NVM** - แสดง Node.js version (เมื่อมี package.json)
- **Python Virtualenv** - แสดง Python environment
- **Kubernetes** - แสดง current context
- **AWS** - แสดง AWS profile (เมื่อตั้งค่า)
- **Google Cloud** - แสดง GCloud project (เมื่อใช้งาน)
- **Time** - แสดงเวลาปัจจุบัน

### 💡 Smart Display
Elements จะแสดงเฉพาะเมื่อ:
- ✅ NVM → มี `package.json` ในโฟลเดอร์
- ✅ Virtualenv → อยู่ใน Python virtual environment
- ✅ K8s → มี kubeconfig active
- ✅ AWS → มี `AWS_PROFILE` ตั้งค่า
- ✅ GCloud → มี gcloud config active

**ไม่มี = ไม่แสดง** → prompt สั้น สะอาดตา

โหลดผ่าน install.sh แล้วถูกเก็บไว้ที่:

```
~/.p10k.zsh
```

---

## 🧪 ทดสอบหลังติดตั้ง

```bash
aliashelp
```

ควรเห็นรายชื่อทั้งหมด

ลองเปิดโปรเจกต์ทดลอง:

```bash
cd ~/Projects
```

ควรเห็น prompt แบบ:

```
Projects   main ●  ❯
```

---

## 🛠 Troubleshooting

### ❗ Icon เป็นสี่เหลี่ยมหรือแสดงผิด
**สาเหตุ:** ยังไม่ได้ตั้ง Nerd Font
**แก้ไข:**
```
iTerm2 → Preferences → Profiles → Text
Font: JetBrainsMono Nerd Font
```

### ❗ สีไม่ตรงตาม Theme Tokyo Night
**สาเหตุ:** ยังไม่ได้ import color scheme
**แก้ไข:**
```
iTerm2 → Preferences → Profiles → Colors → Import...
เลือก: ~/tokyo-night.itermcolors
```

### ❗ Autosuggestion ไม่ทำงาน
**สาเหตุ:** plugin ไม่ถูกโหลด
**แก้ไข:** ตรวจสอบว่า `~/.zshrc` มีบรรทัด:
```bash
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
```

### ❗ Powerlevel10k Theme ไม่โหลด
**สาเหตุ:** ไฟล์ theme หายหรือไม่ถูกโหลด
**แก้ไข:** ตรวจสอบว่ามีไฟล์:
```bash
ls -la ~/.p10k.zsh
```
ถ้าไม่มี ให้ดาวน์โหลดใหม่:
```bash
curl -fsSL https://raw.githubusercontent.com/thaicyber/mac-dev-terminal-setup/main/p10k-tea-tokyonight-one-line.zsh -o ~/.p10k.zsh
```

### ❗ Alias ไม่ทำงาน (aliashelp ไม่เจอ)
**สาเหตุ:** alias files ไม่ถูกโหลด
**แก้ไข:** Restart terminal หรือรัน:
```bash
source ~/.zshrc
```

### ❗ Homebrew ติดตั้งไม่ได้หรือ error
**สาเหตุ:** ไม่มี Command Line Tools
**แก้ไข:** ติดตั้ง xcode-select ก่อน

#### วิธีที่ 1: ใช้ script (แนะนำ)
Script จะติดตั้งให้อัตโนมัติ เพียงแค่:
1. รัน `bash install.sh`
2. เมื่อ dialog ขึ้น → คลิก "Install"
3. กรอกรหัส macOS เมื่อถูกขอ
4. รอให้เสร็จ (โดยปกติ 2-5 นาที, script จะรอ timeout สูงสุด 30 นาทีสำหรับอินเทอร์เน็ตช้า)

#### วิธีที่ 2: ติดตั้งเอง (Manual)
```bash
# เรียก installer (แนะนำใช้ sudo)
sudo xcode-select --install

# หรือ ไม่ใช้ sudo ก็ได้
xcode-select --install

# Dialog จะโผล่ขึ้น
# 1. คลิก "Install"
# 2. Agree to license
# 3. กรอกรหัส macOS
# 4. รอให้เสร็จ
```

**ตรวจสอบว่าติดตั้งแล้วหรือยัง:**
```bash
xcode-select -p
# ถ้าแสดง: /Library/Developer/CommandLineTools
# แปลว่าติดตั้งเรียบร้อยแล้ว
```

**หมายเหตุ:**
- ✅ แนะนำให้ใช้ `sudo xcode-select --install` เพื่อความเสถียร
- ⚠️ คำสั่งจะเปิด **GUI dialog**
- ⚠️ Dialog จะขอรหัส **admin** (รหัสเข้า macOS) อีกครั้ง
- ⚠️ ถ้าใช้ `sudo` จะต้องกรอกรหัส 2 ครั้ง (1. sudo, 2. dialog)

### ❗ ต้องการอัปเดต Theme หรือ Config
**แก้ไข:** รัน Reinstall mode:
```bash
bash install.sh
```
เลือก option `2) Reinstall`

### ❗ ต้องการกู้คืนไฟล์เดิม
**แก้ไข:** ไฟล์ backup อยู่ที่:
```bash
ls -la ~/backup-terminal/
# เลือก timestamp ที่ต้องการ
cp ~/backup-terminal/YYYYMMDD_HHMMSS/zshrc.backup ~/.zshrc
cp ~/backup-terminal/YYYYMMDD_HHMMSS/p10k.zsh.backup ~/.p10k.zsh
```

### ❗ ต้องการลบการติดตั้งทั้งหมด
**แก้ไข:** รัน Uninstall mode:
```bash
bash install.sh
```
เลือก option `3) Uninstall`

### ❗ ต้องการติดตั้ง AWS CLI หรือ Google Cloud CLI ภายหลัง
**แก้ไข:**

#### AWS CLI (via Homebrew):
```bash
brew install awscli
aws configure
```

#### Google Cloud CLI (via Official Installer):
```bash
# Intel Mac
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-darwin-x86_64.tar.gz
tar -xf google-cloud-cli-darwin-x86_64.tar.gz
./google-cloud-sdk/install.sh

# Apple Silicon (M1/M2/M3/M4)
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-darwin-arm.tar.gz
tar -xf google-cloud-cli-darwin-arm.tar.gz
./google-cloud-sdk/install.sh

# จากนั้น
source ~/.zshrc
gcloud init
```

**หรือใช้ script อัตโนมัติ:**
```bash
bash install.sh
# เลือก option 1 หรือ 2
# ตอบ y เมื่อถูกถามเรื่อง Cloud Tools
```

### ❗ AWS หรือ GCloud ไม่แสดงใน prompt
**สาเหตุ:** ยังไม่ได้ config หรือไม่มีค่าตั้งอยู่
**แก้ไข:**
```bash
# ตรวจสอบ AWS
echo $AWS_PROFILE
aws configure list

# ตรวจสอบ GCloud
gcloud config list
gcloud config set project YOUR_PROJECT_ID
```

### ❗ NVM command not found
**สาเหตุ:** NVM ไม่ถูกโหลดใน shell
**แก้ไข:**

**วิธีที่ 1:** Restart terminal
```bash
# ปิดและเปิด terminal ใหม่
```

**วิธีที่ 2:** Load NVM manually
```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
source ~/.zshrc
```

**วิธีที่ 3:** ติดตั้งใหม่
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
source ~/.zshrc
```

### ❗ Node.js version ไม่แสดงใน prompt
**สาเหตุ:** อยู่นอกโฟลเดอร์โปรเจกต์หรือไม่มี package.json
**แก้ไข:**
```bash
# Prompt จะแสดง Node.js version เฉพาะเมื่อ:
# - อยู่ในโฟลเดอร์ที่มี package.json
cd your-project-folder

# ตรวจสอบ version
node --version
nvm current
```

### ❗ ต้องการเปลี่ยน default Node.js version
**แก้ไข:**
```bash
# ดู versions ที่มี
nvm list

# ตั้ง default ใหม่
nvm alias default 20    # เปลี่ยนเป็น version 20
nvm use default

# ตรวจสอบ
node --version
```

### ❗ ติดตั้ง NVM หรือ Node.js ภายหลัง
**แก้ไข:**
```bash
# วิธีที่ 1: ใช้ script
bash install.sh
# เลือก option 1 หรือ 2
# ตอบ y เมื่อถูกถามเรื่อง NVM

# วิธีที่ 2: ติดตั้งเอง
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
source ~/.zshrc
nvm install 22
nvm use 22
```

---

## 📜 License

MIT License
Created & Maintained by **Tea (Sinochar Phuvapitak)**

---

## ❤️ Credits

- Powerlevel10k
- Oh My Zsh
- JetBrains Mono Nerd Font
- Tokyo Night iTerm Theme

---

## 🙌 Features

### ✅ Implemented (V7 - Latest):

#### 🎯 Core Features:
- ✅ **3 Installation Modes** (Install, Reinstall, Uninstall)
- ✅ **Automatic Backup System**
- ✅ **Command Line Tools** (xcode-select) auto-install
- ✅ **Git** version control
- ✅ **P10K Theme V2** with DevOps tools
- ✅ **Thai-safe UTF-8**

#### 🟢 Node.js & Package Managers:
- ✅ **NVM + Node.js Multi-version** (16, 18, 20, 22, 24)
- ✅ **Package Managers** (npm, pnpm, yarn) for all Node versions

#### 🛠 Developer Tools:
- ✅ **Docker Desktop** + kubectl + GitHub CLI
- ✅ **Utilities** (jq, wget, tree, htop, rsync)
- ✅ **NeoHtop** - Modern system monitor GUI (Rust/Tauri)
- ✅ **Python 3.12**

#### 🗄 Database Clients:
- ✅ **PostgreSQL @16** (psql, pg_dump, pg_restore, createdb)
- ✅ **Redis CLI**
- ✅ **MySQL Client** (mysql, mysqldump) ✨ V7
- ✅ **MongoDB** (mongosh, mongodump, mongorestore) ✨ V7

#### ⚙️  DevOps Tools:
- ✅ **Terraform** (Infrastructure as Code)
- ✅ **Helm** (Kubernetes package manager)

#### ✨ Modern CLI Tools (V7 - New!):
- ✅ **fzf** - Fuzzy finder (Ctrl+R for history)
- ✅ **bat** - Better cat with syntax highlighting
- ✅ **eza** - Better ls with git status
- ✅ **ripgrep** - Better grep (super fast)
- ✅ **fd** - Better find
- ✅ **tldr** - Simplified man pages
- ✅ **zoxide** - Smart cd (jump to frequent dirs)

#### ⎈ Kubernetes Enhancement (V7 - New!):
- ✅ **k9s** - Kubernetes TUI
- ✅ **kubectx** - Context switcher
- ✅ **kubens** - Namespace switcher

#### 🐳 Docker Enhancement (V7 - New!):
- ✅ **lazydocker** - Docker TUI

#### 🔧 API Development (V7 - New!):
- ✅ **httpie** - Human-friendly HTTP client

#### 🎯 Shell Completions (V7 - New!):
- ✅ **kubectl** completion
- ✅ **helm** completion
- ✅ **terraform** completion
- ✅ **docker** completion
- ✅ **aws** completion
- ✅ **gh** completion
- ✅ **fzf** key bindings (Ctrl+R, Ctrl+T, Alt+C)
- ✅ **zoxide** initialization

#### ☁️  Cloud Integration:
- ✅ **AWS CLI** (optional)
- ✅ **Google Cloud CLI** (optional, official installer)

#### 🎨 Prompt Features:
- ✅ **Node.js Version Detection** in prompt
- ✅ **Kubernetes Context Display**
- ✅ **Python Virtualenv Support**
- ✅ **AWS Profile Display**
- ✅ **Google Cloud Project Display**

### 📊 V7 Summary:
- **65+ Tools** ready to use
- **16 Interactive Steps** (fully optional)
- **Smart Detection** (skip if installed)
- **Auto Completions** for all major tools
- **Modern CLI** for maximum productivity

### 🔮 Future Ideas:
- Multi-language support
- Theme Pack (Cyberpunk, Dracula, Nord)
- Docker Compose integration
- Terraform workspace indicator
- Azure CLI integration
- More database clients (MongoDB Atlas CLI, DynamoDB CLI)

เปิด Issue ใน repo ได้เลย หรือแจ้งผ่านผู้สร้างระบบ (Tea / ChatGPT)
