# 🧪 รายการตรวจสอบการทดสอบ - mac-dev-terminal-setup V7

**เวอร์ชัน:** V7
**อัปเดตล่าสุด:** 2026-01-04
**สภาพแวดล้อมทดสอบ:** macOS (Intel/Apple Silicon)

---

## 📋 การตรวจสอบก่อนติดตั้ง

### ความต้องการของระบบ
- [ ] macOS 12.0 (Monterey) หรือใหม่กว่า
- [ ] พื้นที่ว่างอย่างน้อย 10GB
- [ ] เชื่อมต่ออินเทอร์เน็ต (สำหรับดาวน์โหลด)
- [ ] สิทธิ์ Admin/sudo

### สถานะการ Backup
- [ ] สำรองข้อมูลด้วย Time Machine เรียบร้อยแล้ว (แนะนำ)
- [ ] ไฟล์สำคัญถูกสำรองแล้ว
- [ ] ทดสอบบน user account แยก (ถ้าเป็นไปได้)

---

## 🔧 Phase 1: การติดตั้งหลัก

### 1. Command Line Tools (xcode-select)
```bash
# ตรวจสอบว่าติดตั้งแล้ว
xcode-select -p
# ควรแสดง: /Library/Developer/CommandLineTools

# ตรวจสอบเวอร์ชัน
xcode-select --version
gcc --version
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] xcode-select ติดตั้งสำเร็จ
- [ ] แสดง path: `/Library/Developer/CommandLineTools`
- [ ] gcc/clang พร้อมใช้งาน
- [ ] ไม่มี error ระหว่างการติดตั้ง

**ระยะเวลา:** โดยปกติ 2-5 นาที (script รอ timeout สูงสุด 30 นาทีสำหรับอินเทอร์เน็ตช้า)
**สิ่งที่ต้องระวัง:**
- GUI dialog จะปรากฏขึ้น (คลิก "Install")
- ขอรหัสผ่าน (2 ครั้งถ้าใช้ sudo)
- ต้องเชื่อมต่ออินเทอร์เน็ต
- ความเร็วอินเทอร์เน็ตมีผลต่อเวลาดาวน์โหลด

---

### 2. Homebrew
```bash
# ตรวจสอบการติดตั้ง
brew --version

# ตรวจสอบ path
which brew
# Intel: /usr/local/bin/brew
# Apple Silicon: /opt/homebrew/bin/brew

# แสดงรายการที่ติดตั้ง
brew list
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] แสดงเวอร์ชัน Homebrew
- [ ] Path ถูกต้องตาม architecture
- [ ] `brew doctor` ไม่แสดง error ร้ายแรง

---

### 3. Git + Core Packages
```bash
# ตรวจสอบ Git
git --version

# ตรวจสอบ Zsh
zsh --version

# ตรวจสอบ Zsh plugins
ls $(brew --prefix)/share/zsh-autosuggestions/
ls $(brew --prefix)/share/zsh-syntax-highlighting/

# ตรวจสอบ iTerm2
ls /Applications/iTerm2.app

# ตรวจสอบ Font
ls ~/Library/Fonts/ | grep JetBrains
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] Git เวอร์ชัน 2.x+
- [ ] Zsh เวอร์ชัน 5.8+
- [ ] Autosuggestions plugin พบแล้ว
- [ ] Syntax highlighting plugin พบแล้ว
- [ ] iTerm2.app ติดตั้งแล้ว
- [ ] JetBrainsMono Nerd Font ติดตั้งแล้ว

---

### 4. Oh My Zsh
```bash
# ตรวจสอบการติดตั้ง
ls -la ~/.oh-my-zsh

# ตรวจสอบ config
cat ~/.zshrc | grep "oh-my-zsh"

# ยืนยัน
echo $ZSH
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] โฟลเดอร์ Oh My Zsh มีอยู่
- [ ] `.zshrc` ถูก configure แล้ว
- [ ] ตัวแปร `$ZSH` ถูกตั้งค่าแล้ว

---

## 🟢 Phase 2: Node.js & Package Managers

### 5. NVM + Node.js
```bash
# ตรวจสอบ NVM
nvm --version

# แสดงรายการเวอร์ชันที่ติดตั้ง
nvm list

# ตรวจสอบเวอร์ชันปัจจุบัน
node --version
npm --version

# ทดสอบแต่ละเวอร์ชัน
for v in 16 18 20 22 24; do
  echo "กำลังทดสอบ Node.js $v:"
  nvm use $v
  node --version
done

# สลับกลับไปใช้ default
nvm use default
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] NVM เวอร์ชัน 0.40.1+
- [ ] Node.js 16, 18, 20, 22, 24 ติดตั้งแล้ว
- [ ] Default คือ Node.js 22
- [ ] npm พร้อมใช้งานในทุกเวอร์ชัน

---

### 6. pnpm & yarn
```bash
# ตรวจสอบการติดตั้ง globally
pnpm --version
yarn --version

# ทดสอบในแต่ละเวอร์ชัน Node
for v in 16 18 20 22 24; do
  echo "กำลังทดสอบ pnpm/yarn ใน Node.js $v:"
  nvm use $v
  pnpm --version
  yarn --version
done
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] pnpm ติดตั้งในทุกเวอร์ชัน Node
- [ ] yarn ติดตั้งในทุกเวอร์ชัน Node
- [ ] ทั้งสองทำงานได้ในแต่ละเวอร์ชัน

---

## 🛠 Phase 3: Developer Tools

### 7. OrbStack (Docker)
```bash
# ตรวจสอบ Docker
docker --version
docker-compose --version

# ทดสอบ Docker
docker run hello-world

# ตรวจสอบแอป OrbStack
ls /Applications/OrbStack.app
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] แสดงเวอร์ชัน Docker
- [ ] docker-compose พร้อมใช้งาน
- [ ] hello-world รันสำเร็จ
- [ ] OrbStack.app ติดตั้งแล้ว

**หมายเหตุ:** OrbStack จะเริ่มทำงานเองหลังติดตั้ง ถ้ายังไม่มีคำสั่ง docker ให้รัน `open -a OrbStack` หนึ่งครั้ง

---

### 8. kubectl
```bash
# ตรวจสอบเวอร์ชัน
kubectl version --client

# ทดสอบ completion (กด Tab หลังพิมพ์)
kubectl get po[TAB]
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] แสดงเวอร์ชัน kubectl
- [ ] Tab completion ทำงาน

---

### 9. GitHub CLI (gh)
```bash
# ตรวจสอบเวอร์ชัน
gh --version

# ทดสอบ completion
gh pr [TAB]
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] แสดงเวอร์ชัน gh
- [ ] Tab completion ทำงาน

---

### 10. Utilities
```bash
# ตรวจสอบ utilities ทั้งหมด
for cmd in jq wget tree htop rsync; do
  echo "กำลังทดสอบ $cmd:"
  which $cmd
  $cmd --version 2>/dev/null || echo "OK"
done
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] jq ติดตั้งและทำงาน
- [ ] wget ติดตั้งและทำงาน
- [ ] tree ติดตั้งและทำงาน
- [ ] htop ติดตั้งและทำงาน
- [ ] rsync ติดตั้งและทำงาน

---

### 11. NeoHtop
```bash
# ตรวจสอบการติดตั้ง
ls /Applications/NeoHtop.app

# ทดสอบ (เปิด GUI)
open -a NeoHtop
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] NeoHtop.app ติดตั้งแล้ว
- [ ] แอปเปิดสำเร็จ
- [ ] แสดง system processes

---

### 12. Python 3
```bash
# ตรวจสอบเวอร์ชัน
python3 --version

# ตรวจสอบ pip
pip3 --version
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] Python 3.12.x ติดตั้งแล้ว
- [ ] pip3 พร้อมใช้งาน

---

## 🗄 Phase 4: Database CLI Tools

### 13. PostgreSQL @16
```bash
# ตรวจสอบการติดตั้ง
psql --version

# ตรวจสอบเครื่องมือทั้งหมด
for cmd in psql pg_dump pg_restore pg_dumpall createdb dropdb; do
  echo "กำลังทดสอบ $cmd:"
  which $cmd
  $cmd --version
done

# ตรวจสอบ PATH
echo $PATH | grep postgresql@16
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] PostgreSQL 16.x ติดตั้งแล้ว
- [ ] เครื่องมือ client ทั้งหมดพร้อมใช้งาน
- [ ] PATH รวม postgresql@16/bin

**ทดสอบกับ Docker:**
```bash
# รัน PostgreSQL container
docker run -d --name test-postgres -p 5432:5432 \
  -e POSTGRES_PASSWORD=test123 postgres:16

# รอสักครู่
sleep 5

# ทดสอบการเชื่อมต่อ
psql -h localhost -U postgres -d postgres -c "SELECT version();"

# ทดสอบ pg_dump
pg_dump -h localhost -U postgres postgres > /tmp/test.sql

# ทำความสะอาด
docker stop test-postgres
docker rm test-postgres
```

---

### 14. Redis CLI
```bash
# ตรวจสอบเวอร์ชัน
redis-cli --version

# ทดสอบกับ Docker
docker run -d --name test-redis -p 6379:6379 redis:7
sleep 3

# ทดสอบคำสั่ง
redis-cli ping
redis-cli set testkey "Hello"
redis-cli get testkey

# ทำความสะอาด
docker stop test-redis
docker rm test-redis
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] redis-cli ติดตั้งแล้ว
- [ ] เชื่อมต่อ Redis server ได้
- [ ] คำสั่งทำงานถูกต้อง

---

### 15. MySQL Client
```bash
# ตรวจสอบเวอร์ชัน
mysql --version
mysqldump --version

# ตรวจสอบ PATH
echo $PATH | grep mysql-client
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] MySQL client 8.x+ ติดตั้งแล้ว
- [ ] mysqldump พร้อมใช้งาน
- [ ] PATH รวม mysql-client/bin

---

### 16. MongoDB Tools
```bash
# ตรวจสอบ mongosh
mongosh --version

# ตรวจสอบ database tools
for cmd in mongodump mongorestore mongoexport mongoimport; do
  echo "กำลังทดสอบ $cmd:"
  which $cmd
  $cmd --version
done
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] mongosh 2.x+ ติดตั้งแล้ว
- [ ] เครื่องมือ database ทั้งหมดพร้อมใช้งาน

---

## ⚙️ Phase 5: DevOps Tools

### 17. Terraform
```bash
# ตรวจสอบเวอร์ชัน
terraform --version

# ทดสอบ completion
terraform [TAB]

# ทดสอบพื้นฐาน
cd /tmp
terraform init
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] Terraform 1.x+ ติดตั้งแล้ว
- [ ] Tab completion ทำงาน
- [ ] สามารถ initialize ได้

---

### 18. Helm
```bash
# ตรวจสอบเวอร์ชัน
helm version

# ทดสอบ completion
helm [TAB]

# ทดสอบเพิ่ม repo
helm repo add stable https://charts.helm.sh/stable
helm repo update
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] Helm 3.x+ ติดตั้งแล้ว
- [ ] Tab completion ทำงาน
- [ ] จัดการ repos ได้

---

## ✨ Phase 6: Modern CLI Tools

### 19. fzf
```bash
# ตรวจสอบเวอร์ชัน
fzf --version

# ทดสอบ key bindings
# กด Ctrl+R (ควรเปิด fzf history search)
# กด Ctrl+T (ควรเปิด fzf file search)

# ตรวจสอบไฟล์ key bindings
ls ~/.fzf.zsh
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] fzf 0.x+ ติดตั้งแล้ว
- [ ] Ctrl+R ทำงาน (fuzzy history)
- [ ] Ctrl+T ทำงาน (fuzzy file search)
- [ ] ~/.fzf.zsh มีอยู่

---

### 20. bat
```bash
# ตรวจสอบเวอร์ชัน
bat --version

# ทดสอบ
bat ~/.zshrc
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] bat ติดตั้งแล้ว
- [ ] Syntax highlighting ทำงาน
- [ ] แสดงเลขบรรทัด

---

### 21. eza
```bash
# ตรวจสอบเวอร์ชัน
eza --version

# ทดสอบ
eza -la
eza --tree
eza -la --git
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] eza ติดตั้งแล้ว
- [ ] แสดง icons
- [ ] แสดง git status (ถ้าอยู่ใน git repo)
- [ ] Tree view ทำงาน

---

### 22. ripgrep (rg)
```bash
# ตรวจสอบเวอร์ชัน
rg --version

# ทดสอบ
rg "function" ~/.zshrc
rg -i "export" ~/
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] ripgrep ติดตั้งแล้ว
- [ ] การค้นหาทำงาน
- [ ] ผลลัพธ์เร็ว

---

### 23. fd
```bash
# ตรวจสอบเวอร์ชัน
fd --version

# ทดสอบ
fd .zsh ~
fd -t f .sh
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] fd ติดตั้งแล้ว
- [ ] การค้นหาไฟล์ทำงาน

---

### 24. tldr
```bash
# ตรวจสอบเวอร์ชัน
tldr --version

# ทดสอบ
tldr tar
tldr curl
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] tldr ติดตั้งแล้ว
- [ ] แสดง man pages แบบย่อ

---

### 25. zoxide
```bash
# ตรวจสอบเวอร์ชัน
zoxide --version

# ทดสอบ
z ~
z -l

# ทดสอบการใช้งาน
cd ~/Documents
cd ~/Downloads
z doc  # ควร jump ไป Documents
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] zoxide ติดตั้งแล้ว
- [ ] คำสั่ง `z` ทำงาน
- [ ] ฟังก์ชัน jump ทำงาน

---

## ⎈ Phase 7: Kubernetes Enhancement

### 26. k9s
```bash
# ตรวจสอบเวอร์ชัน
k9s version

# หมายเหตุ: ต้องมี kubectl context เพื่อทดสอบแบบเต็ม
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] k9s ติดตั้งแล้ว
- [ ] แสดงเวอร์ชัน

---

### 27. kubectx
```bash
# ตรวจสอบการติดตั้ง
kubectx --version
which kubectx

# ทดสอบ (ถ้ามี contexts)
kubectx
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] kubectx ติดตั้งแล้ว
- [ ] แสดงรายการ contexts (ถ้ามี)

---

### 28. kubens
```bash
# ตรวจสอบการติดตั้ง
kubens --version
which kubens

# ทดสอบ (ถ้ามี contexts)
kubens
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] kubens ติดตั้งแล้ว
- [ ] แสดงรายการ namespaces (ถ้า kubectl configured)

---

## 🐳 Phase 8: Docker Enhancement

### 29. lazydocker
```bash
# ตรวจสอบเวอร์ชัน
lazydocker --version

# ทดสอบ (เปิด TUI)
lazydocker
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] lazydocker ติดตั้งแล้ว
- [ ] TUI เปิดขึ้น (กด 'q' เพื่อออก)

---

## 🔧 Phase 9: API Development

### 30. httpie
```bash
# ตรวจสอบเวอร์ชัน
http --version

# ทดสอบ
http GET https://httpbin.org/get
http --json POST https://httpbin.org/post name="Test"
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] httpie ติดตั้งแล้ว
- [ ] GET request ทำงาน
- [ ] POST request ทำงาน
- [ ] แสดงผล JSON formatted

---

## ☁️ Phase 10: Cloud Tools (Optional)

### 31. AWS CLI
```bash
# ตรวจสอบเวอร์ชัน (ถ้าติดตั้ง)
aws --version

# ทดสอบ completion
aws [TAB]
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] AWS CLI ติดตั้งแล้ว (ถ้าเลือก)
- [ ] Tab completion ทำงาน
- [ ] สามารถรัน `aws configure` ได้

---

### 32. Google Cloud CLI
```bash
# ตรวจสอบเวอร์ชัน (ถ้าติดตั้ง)
gcloud --version

# ตรวจสอบ installation path
ls ~/google-cloud-sdk

# ตรวจสอบ PATH
echo $PATH | grep google-cloud-sdk
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] gcloud ติดตั้งแล้ว (ถ้าเลือก)
- [ ] ติดตั้งที่ ~/google-cloud-sdk
- [ ] PATH รวม gcloud
- [ ] สามารถรัน `gcloud init` ได้

---

## 🎨 Phase 11: Themes & Configurations

### 33. Tokyo Night Color Scheme
```bash
# ตรวจสอบไฟล์
ls ~/tokyo-night.itermcolors
cat ~/tokyo-night.itermcolors | head
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] ไฟล์มีอยู่
- [ ] รูปแบบ XML ถูกต้อง

**ขั้นตอนด้วยตนเอง:**
- [ ] Import ใน iTerm2: Preferences → Profiles → Colors → Import
- [ ] สีถูกต้อง (พื้นหลังสีน้ำเงินเข้ม, syntax มีสี)

---

### 34. Powerlevel10k Theme V2
```bash
# ตรวจสอบไฟล์
ls ~/.p10k.zsh

# ตรวจสอบว่าโหลดแล้ว
cat ~/.zshrc | grep "p10k.zsh"

# ทดสอบ prompt (restart terminal)
# ควรเห็น:
# - Directory ด้านซ้าย
# - Git info (ถ้าอยู่ใน git repo)
# - Node.js version (ถ้ามี package.json)
# - เวลาด้านขวา
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] ~/.p10k.zsh มีอยู่
- [ ] โหลดใน ~/.zshrc แล้ว
- [ ] Prompt แสดงถูกต้อง
- [ ] สีตรงกับ Tokyo Night theme

---

### 35. Developer Aliases
```bash
# ตรวจสอบ alias directory
ls ~/.zshrc.d/

# ทดสอบ aliashelp
aliashelp

# ทดสอบ aliases
ll
gs
portfind 3000
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] ~/.zshrc.d/ มี 4-5 ไฟล์
- [ ] คำสั่ง aliashelp ทำงาน
- [ ] Aliases ทั้งหมดทำงานถูกต้อง

---

## 🎯 Phase 12: Shell Completions

### 36. Completions ทั้งหมด
```bash
# ตรวจสอบไฟล์ completions
cat ~/.zshrc.d/completions.zsh

# ทดสอบแต่ละ completion (กด Tab หลังพิมพ์):
kubectl get [TAB]
helm install [TAB]
terraform [TAB]
docker run [TAB]
aws [TAB]
gh pr [TAB]

# ทดสอบ fzf
# กด Ctrl+R (ควรแสดง history ด้วย fzf)

# ทดสอบ zoxide
z [TAB]
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] ไฟล์ completions มีอยู่
- [ ] kubectl completion ทำงาน
- [ ] helm completion ทำงาน
- [ ] terraform completion ทำงาน
- [ ] docker completion ทำงาน
- [ ] aws completion ทำงาน (ถ้าติดตั้ง)
- [ ] gh completion ทำงาน
- [ ] fzf key bindings ทำงาน (Ctrl+R, Ctrl+T, Alt+C)
- [ ] zoxide initialization ทำงาน

---

## 📦 Phase 13: ระบบ Backup

### 37. ตรวจสอบ Backup
```bash
# ตรวจสอบ backup directory
ls -la ~/backup-terminal/

# แสดงรายการ backups
ls ~/backup-terminal/

# ตรวจสอบ backup ล่าสุด
LATEST=$(ls -t ~/backup-terminal/ | head -1)
ls -la ~/backup-terminal/$LATEST/
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] Backup directory มีอยู่
- [ ] Backup ถูกสร้างพร้อม timestamp
- [ ] มี: zshrc.backup, p10k.zsh.backup, zshrc.d.backup/

---

## 🔄 Phase 14: โหมดการติดตั้ง

### 38. ทดสอบโหมด Reinstall
```bash
# รัน script อีกครั้ง
bash install.sh

# เลือก: 2) Reinstall
# ตอบ: y เพื่อยืนยัน

# ตรวจสอบ:
# - Backup ใหม่ถูกสร้าง
# - ไฟล์ถูกเขียนทับ
# - ทุกอย่างยังทำงาน
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] Reinstall เสร็จสมบูรณ์โดยไม่มี error
- [ ] Backup ใหม่ถูกสร้าง
- [ ] ไฟล์ config ถูกอัปเดต
- [ ] เครื่องมือทั้งหมดยังทำงาน

---

### 39. ทดสอบโหมด Uninstall
```bash
# รัน script
bash install.sh

# เลือก: 3) Uninstall
# ตอบ: y เพื่อยืนยัน

# ตรวจสอบการลบ:
ls ~/.p10k.zsh  # ไม่ควรมี
ls ~/.zshrc.d/  # ไม่ควรมี
cat ~/.zshrc | grep "Tea Terminal Setup"  # ไม่ควรมี

# ตรวจสอบสิ่งที่เก็บไว้:
ls /Applications/iTerm2.app  # ควรยังมี
brew --version  # ควรยังทำงาน
ls ~/.oh-my-zsh/  # ควรยังมี
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] ไฟล์ config ถูกลบ
- [ ] Backup ถูกสร้างก่อน uninstall
- [ ] Homebrew ยังติดตั้งอยู่
- [ ] iTerm2 ยังติดตั้งอยู่
- [ ] Oh My Zsh ยังติดตั้งอยู่
- [ ] Fonts ยังติดตั้งอยู่

---

## ✅ การตรวจสอบขั้นสุดท้าย

### 40. การตรวจสอบระบบโดยรวม
```bash
# Source shell ใหม่
source ~/.zshrc

# ตรวจสอบคำสั่งสำคัญทั้งหมด
for cmd in git zsh nvm node npm docker kubectl helm terraform; do
  echo -n "กำลังตรวจสอบ $cmd: "
  if command -v $cmd &>/dev/null; then
    echo "✅ OK"
  else
    echo "❌ ไม่พบ"
  fi
done

# ทดสอบ P10K prompt
cd /tmp
mkdir test-project
cd test-project
git init
touch package.json
# Prompt ควรแสดง git branch และ node version
```

**ผลลัพธ์ที่คาดหวัง:**
- [ ] คำสั่งหลักทั้งหมดพร้อมใช้งาน
- [ ] ไม่มี error ใน terminal
- [ ] Prompt แสดงถูกต้อง
- [ ] สี theme ถูกต้อง

---

## 🐛 ปัญหาที่พบบ่อย & วิธีแก้ไข

### ปัญหา 1: ไม่พบคำสั่ง (Command not found)
**อาการ:** เครื่องมือติดตั้งแล้วแต่ไม่พบ
**วิธีแก้:**
```bash
# ตรวจสอบ PATH
echo $PATH

# Source zshrc
source ~/.zshrc

# Restart terminal
```

### ปัญหา 2: NVM ไม่ทำงาน
**อาการ:** `nvm: command not found`
**วิธีแก้:**
```bash
# ตรวจสอบ NVM directory
ls ~/.nvm

# โหลด NVM ใหม่
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# เพิ่มใน .zshrc ถ้ายังไม่มี
```

### ปัญหา 3: Completions ไม่ทำงาน
**อาการ:** Tab completion ไม่ทำงาน
**วิธีแก้:**
```bash
# ตรวจสอบไฟล์ completions
cat ~/.zshrc.d/completions.zsh

# โหลด shell ใหม่
exec zsh

# รัน compinit
autoload -Uz compinit && compinit
```

### ปัญหา 4: Docker ไม่ start
**อาการ:** `docker: command not found` หรือ connection error
**วิธีแก้:**
```bash
# Start OrbStack
open -a OrbStack

# รอให้ Docker start (30-60 วินาที)
# ตรวจสอบสถานะ
docker ps
```

### ปัญหา 5: Brew warnings
**อาการ:** `brew doctor` แสดง warnings
**วิธีแก้:**
```bash
# Warning ส่วนใหญ่ไม่ร้ายแรง
# แก้เฉพาะที่สำคัญ:
brew doctor

# อัปเดต Homebrew
brew update
brew upgrade
```

---

## 📊 Template รายงานการทดสอบ

```
===========================================
รายงานการทดสอบ: mac-dev-terminal-setup V7
===========================================

วันที่ทดสอบ: _______________
ผู้ทดสอบ: _______________
เวอร์ชัน macOS: _______________
สถาปัตยกรรม: Intel / Apple Silicon (วงกลม)

โหมดการติดตั้งที่ทดสอบ:
[ ] Install
[ ] Reinstall
[ ] Uninstall

ผลลัพธ์โดยรวม:
[ ] Pass - การทดสอบทั้งหมดสำเร็จ
[ ] Pass with issues - มีปัญหาเล็กน้อยที่ไม่ร้ายแรง
[ ] Fail - พบปัญหาร้ายแรง

อัตราความสำเร็จ: _____ / 40 tests

ปัญหาร้ายแรงที่พบ:
1. _______________________________________________
2. _______________________________________________
3. _______________________________________________

ปัญหาเล็กน้อย:
1. _______________________________________________
2. _______________________________________________

ข้อเสนอแนะ:
_______________________________________________
_______________________________________________
_______________________________________________

หมายเหตุเพิ่มเติม:
_______________________________________________
_______________________________________________
_______________________________________________

===========================================
```

---

## 📝 หมายเหตุ

### ประมาณการเวลาติดตั้ง:
- **แบบขั้นต่ำ (core เท่านั้น):** 10-15 นาที
- **แบบมาตรฐาน (พร้อม optional groups):** 30-45 นาที
- **แบบเต็ม (ทุกอย่าง):** 45-60 นาที

### พื้นที่ดิสก์ที่ใช้:
- **Core packages:** ~2-3 GB
- **พร้อม Node.js (5 versions):** ~4-5 GB
- **พร้อม OrbStack:** ~5-6 GB
- **การติดตั้งแบบเต็ม:** ~12-15 GB

### ข้อมูลเครือข่ายที่ดาวน์โหลด:
- **Core packages:** ~500 MB - 1 GB
- **การติดตั้งแบบเต็ม:** ~3-5 GB

---

**เวอร์ชัน:** V7
**เอกสาร:** TESTING_CHECKLIST_TH.md
**Repository:** https://github.com/thaicyber/mac-dev-terminal-setup

