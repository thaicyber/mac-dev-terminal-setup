# Tea Ubuntu Server CLI Setup

ชุดติดตั้งสภาพแวดล้อม CLI สำหรับนักพัฒนา บน **Ubuntu Server** (และ Debian-based)

เน้นการใช้งานผ่าน **Command Line** เท่านั้น ไม่มี GUI

## ความต้องการของระบบ

- Ubuntu 20.04 LTS ขึ้นไป (หรือ Debian-based เช่น Debian 11+)
- การเข้าถึง sudo
- การเชื่อมต่ออินเทอร์เน็ต

## การติดตั้ง

### วิธีที่ 1: ดาวน์โหลดและรัน

```bash
# Clone repository
git clone https://github.com/thaicyber/mac-dev-terminal-setup.git
cd mac-dev-terminal-setup/ubuntu-server

# รันแบบ interactive (ถามทีละขั้นตอน)
bash install.sh

# หรือรันแบบอัตโนมัติ (ไม่ถาม Y/N)
bash install.sh install --all
```

### วิธีที่ 2: รันโดยตรงจาก URL

```bash
curl -fsSL https://raw.githubusercontent.com/thaicyber/mac-dev-terminal-setup/main/ubuntu-server/install.sh | bash
```

## โหมดการทำงาน

| โหมด | คำอธิบาย |
|------|----------|
| `install` | ติดตั้งใหม่ ไม่ทับไฟล์ที่มีอยู่ |
| `reinstall` | ติดตั้งใหม่ทั้งหมด ทับไฟล์เดิม |
| `uninstall` | ลบการติดตั้ง (เก็บ backup) |

## สิ่งที่ติดตั้ง

### Core
- Zsh + Oh My Zsh
- zsh-autosuggestions, zsh-syntax-highlighting
- Powerlevel10k theme (Tea Tokyo Night)
- NVM + Node.js (16, 18, 20, 22, 24)
- pnpm, yarn (optional)

### Developer Tools
- Docker
- kubectl
- GitHub CLI (gh)
- jq, wget, tree, htop, rsync
- Python 3

### Database CLI
- PostgreSQL client (psql)
- Redis CLI (redis-cli)
- MySQL client (optional)
- MongoDB Shell (optional)

### DevOps
- Terraform
- Helm
- k9s, kubectx, kubens
- lazydocker

### Modern CLI
- fzf, bat, eza, ripgrep, fd, tldr, zoxide

### Cloud
- AWS CLI
- Google Cloud CLI

### API
- httpie

## การใช้งานหลังติดตั้ง

```bash
# ตั้ง Zsh เป็น default shell
chsh -s $(which zsh)

# Logout และ login ใหม่ หรือ
exec zsh

# ดู alias ที่มี
aliashelp
```

## ความแตกต่างจากเวอร์ชัน macOS

| รายการ | macOS | Ubuntu Server |
|--------|-------|---------------|
| Package Manager | Homebrew | apt |
| Terminal | iTerm2 | ใช้ default (CLI only) |
| Color Scheme | Tokyo Night (iTerm) | ไม่มี (ใช้ p10k theme) |
| Font | JetBrains Mono Nerd | ไม่ติดตั้ง (ใช้ default) |
| Docker | Docker Desktop | Docker Engine |
| NeoHtop (GUI) | มี | ไม่มี |

## ตัวอย่างคำสั่ง

```bash
# Interactive mode
bash install.sh

# Auto-install ทุกอย่าง
bash install.sh install --all

# Reinstall (ทับของเดิม)
bash install.sh reinstall --all

# Uninstall
bash install.sh uninstall

# แสดงความช่วยเหลือ
bash install.sh --help
```

## Backup

ไฟล์เดิมจะถูก backup ไว้ที่ `~/backup-terminal/<timestamp>/` ก่อนติดตั้งหรือ uninstall

## License

ตาม license ของโปรเจกต์หลัก
