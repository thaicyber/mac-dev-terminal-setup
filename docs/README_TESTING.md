# 🧪 คู่มือการทดสอบ - mac-dev-terminal-setup V7

**เวอร์ชัน:** V7
**อัปเดตล่าสุด:** 2026-01-04

---

## 📋 ภาพรวม

Repository นี้มีเครื่องมือทดสอบ 2 ชุด:

1. **`test-installation.sh`** - สคริปต์ทดสอบอัตโนมัติ (แนะนำ)
2. **`TESTING_CHECKLIST_TH.md`** - รายการตรวจสอบแบบ manual

---

## 🚀 การใช้งาน test-installation.sh

> **⚠️ สำคัญมาก!** หลังจากรัน `install.sh` เสร็จ **ต้องปิด Terminal เดิมและเปิดใหม่ก่อนทดสอบ!** ห้ามใช้ Terminal เดิมที่เพิ่งติดตั้งเสร็จ เพราะ environment variables และ PATH จะยังไม่ถูกโหลด การทดสอบจะให้ผลลัพธ์ที่ไม่ถูกต้อง

### วิธีรันสคริปต์ทดสอบ:

```bash
# ดาวน์โหลดสคริปต์
curl -fsSL https://raw.githubusercontent.com/thaicyber/mac-dev-terminal-setup/main/backup/test-installation.sh -o ~/test-installation.sh

# ทำให้ execute ได้
chmod +x ~/test-installation.sh

# รันการทดสอบ
bash ~/test-installation.sh
```

หรือถ้าอยู่ใน repository แล้ว:

```bash
# รันจากโฟลเดอร์ backup/
cd backup/
bash test-installation.sh

# หรือรันจาก root
bash backup/test-installation.sh
```

---

## 📊 ผลลัพธ์ที่คาดหวัง

### ตัวอย่าง Output:

```
========================================
🧪 Tea Terminal Setup - Testing Script V7
========================================

เริ่มการทดสอบ...
กำลังตรวจสอบ components ที่ติดตั้ง...

--- 🔧 Phase 1: การติดตั้งหลัก ---

1️⃣  Command Line Tools (xcode-select)
✅ PASS: xcode-select ติดตั้งแล้ว
✅ PASS: gcc/clang พร้อมใช้งาน

2️⃣  Homebrew
✅ PASS: Homebrew ติดตั้งแล้ว
   📍 Path: /opt/homebrew/bin/brew

3️⃣  Git + Core Packages
✅ PASS: Git ติดตั้งแล้ว
✅ PASS: Zsh ติดตั้งแล้ว
✅ PASS: Zsh autosuggestions plugin
✅ PASS: Zsh syntax-highlighting plugin
✅ PASS: iTerm2 ติดตั้งแล้ว
✅ PASS: JetBrainsMono Nerd Font ติดตั้งแล้ว

... (ต่อไปเรื่อยๆ)

========================================
📊 สรุปผลการทดสอบ
========================================

รายงานการทดสอบ: 2026-01-04 20:30:45

สถิติการทดสอบ:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ทั้งหมด:     85 tests
ผ่าน:       75 tests
ไม่ผ่าน:    5 tests
ข้าม:       5 tests
อัตราผ่าน:  88%
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️  ผลการทดสอบ: PASS with Issues
การติดตั้งส่วนใหญ่สำเร็จ แต่มีบางส่วนที่ต้องตรวจสอบ
```

---

## 🎯 การแปลผลลัพธ์

### สถานะการทดสอบ:

| สถานะ | ความหมาย | การแสดงผล |
|-------|----------|-----------|
| **PASS** | ผ่านการทดสอบ | ✅ สีเขียว |
| **FAIL** | ไม่ผ่านการทดสอบ | ❌ สีแดง |
| **SKIP** | ข้ามการทดสอบ (ไม่ได้ติดตั้ง component) | ⏭ สีเหลือง |

### ผลการทดสอบโดยรวม:

| อัตราผ่าน | ผลการทดสอบ | ความหมาย |
|-----------|-------------|----------|
| **100%** | ✅ PASS | ทุกอย่างสมบูรณ์ |
| **80-99%** | ⚠️ PASS with Issues | ส่วนใหญ่สำเร็จ, มีบางส่วนต้องตรวจสอบ |
| **< 80%** | ❌ FAIL | พบปัญหาร้ายแรง |

---

## 📝 สิ่งที่สคริปต์ตรวจสอบ

สคริปต์จะทดสอบ **14 Phases** รวม **~85-90 tests**:

### Phase 1: การติดตั้งหลัก (4 sections)
- Command Line Tools (xcode-select)
- Homebrew
- Git + Core Packages (Git, Zsh, plugins, iTerm2, Fonts)
- Oh My Zsh

### Phase 2: Node.js & Package Managers (2 sections)
- NVM + Node.js (หลายเวอร์ชัน)
- pnpm & yarn

### Phase 3: Developer Tools (6 sections)
- OrbStack (Docker)
- kubectl
- GitHub CLI (gh)
- Utilities (jq, wget, tree, htop, rsync)
- NeoHtop
- Python 3

### Phase 4: Database CLI Tools (4 sections)
- PostgreSQL Client (psql, pg_dump, pg_restore)
- Redis CLI
- MySQL Client
- MongoDB Tools (mongosh, mongodump, mongorestore)

### Phase 5: DevOps Tools (2 sections)
- Terraform
- Helm

### Phase 6: Modern CLI Tools (7 sections)
- fzf (Fuzzy Finder)
- bat (Better cat)
- eza (Better ls)
- ripgrep (Better grep)
- fd (Better find)
- tldr (Simplified man pages)
- zoxide (Smart cd)

### Phase 7: Kubernetes Enhancement (3 sections)
- k9s
- kubectx
- kubens

### Phase 8: Docker Enhancement (1 section)
- lazydocker

### Phase 9: API Development (1 section)
- httpie

### Phase 10: Cloud Tools (2 sections)
- AWS CLI
- Google Cloud CLI

### Phase 11: Themes & Configurations (3 sections)
- Tokyo Night Color Scheme
- Powerlevel10k Theme
- Developer Aliases

### Phase 12: Shell Completions (1 section)
- Completions สำหรับเครื่องมือต่างๆ

### Phase 13: Backup System (1 section)
- Backup directory

### Phase 14: Configuration (1 section)
- .zshrc configuration

---

## 🔍 การแก้ปัญหา

### ถ้าทดสอบไม่ผ่าน (FAIL):

1. **ตรวจสอบว่าติดตั้ง optional components ไหนบ้าง**
   - บาง tools เป็น optional (เช่น AWS CLI, Docker, DevOps tools)
   - FAIL ไม่เสมอหมายความว่ามีปัญหา อาจเป็นเพราะไม่ได้เลือกติดตั้ง

2. **ติดตั้งส่วนที่ขาด**
   ```bash
   bash install.sh
   # เลือก Reinstall หรือ Install
   # ตอบ y สำหรับ optional groups ที่ต้องการ
   ```

3. **ตรวจสอบ PATH**
   ```bash
   echo $PATH
   source ~/.zshrc
   ```

4. **ตรวจสอบ logs เฉพาะ**
   - รันคำสั่งที่ fail ด้วยตนเอง
   - ดู error messages

### ถ้าทดสอบข้าม (SKIP):

- เป็นเรื่องปกติถ้าไม่ได้เลือกติดตั้ง optional components
- ตัวอย่าง: NVM, Docker, AWS CLI, DevOps tools
- ไม่มีผลต่อผลการทดสอบโดยรวม

---

## 🎯 กรณีการใช้งาน

### 1. ทดสอบหลังติดตั้งใหม่

```bash
# ติดตั้ง
bash install.sh

# ⚠️ สำคัญ: ปิด Terminal เดิมและเปิดใหม่!

# ทดสอบ (ใน Terminal ใหม่)
bash backup/test-installation.sh
```

**คาดหวัง:** PASS หรือ PASS with Issues (ถ้ามี optional components บางตัว)

> **⚠️ หมายเหตุ:** ห้ามทดสอบใน Terminal เดิมที่เพิ่งรัน install.sh เสร็จ ต้องเปิดใหม่เสมอ!

---

### 2. ตรวจสอบสถานะก่อน Reinstall

```bash
# ตรวจสอบสถานะปัจจุบัน
bash backup/test-installation.sh

# บันทึกผลลัพธ์
bash backup/test-installation.sh > ~/test-before-reinstall.txt

# Reinstall
bash install.sh
# เลือก: 2) Reinstall

# ⚠️ สำคัญ: ปิด Terminal เดิมและเปิดใหม่!

# ทดสอบใหม่ (ใน Terminal ใหม่)
bash backup/test-installation.sh > ~/test-after-reinstall.txt

# เปรียบเทียบ
diff ~/test-before-reinstall.txt ~/test-after-reinstall.txt
```

---

### 3. ตรวจสอบระบบเป็นประจำ

```bash
# สร้าง alias สำหรับทดสอบ
echo 'alias test-terminal="bash ~/path/to/backup/test-installation.sh"' >> ~/.zshrc
source ~/.zshrc

# รันทดสอบทุกเมื่อ
test-terminal
```

---

### 4. CI/CD Pipeline Testing

```bash
# ใช้ใน GitHub Actions หรือ CI pipeline
#!/bin/bash
set -e

# ติดตั้ง
bash install.sh <<EOF
1
y
y
y
y
y
y
y
y
y
EOF

# ทดสอบ
bash backup/test-installation.sh

# Exit code:
# 0 = PASS
# 1 = PASS with Issues
# 2 = FAIL
```

---

## 📊 Exit Codes

สคริปต์จะ return exit code ตามผลการทดสอบ:

| Exit Code | ความหมาย | เงื่อนไข |
|-----------|----------|---------|
| **0** | PASS | ไม่มี FAIL เลย (100% passed) |
| **1** | PASS with Issues | อัตราผ่าน ≥ 80% |
| **2** | FAIL | อัตราผ่าน < 80% |

การใช้งาน:

```bash
bash backup/test-installation.sh
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
  echo "✅ ทุกอย่างสมบูรณ์!"
elif [ $EXIT_CODE -eq 1 ]; then
  echo "⚠️  มีบางส่วนต้องตรวจสอบ"
else
  echo "❌ พบปัญหาร้ายแรง"
fi
```

---

## 🔧 การปรับแต่งสคริปต์

### แก้ไขจำนวน tests:

เปิดไฟล์ `test-installation.sh` และแก้ไขใน section ที่ต้องการ:

```bash
# ตัวอย่าง: เพิ่ม test สำหรับ component ใหม่
echo "X️⃣  Component ใหม่"
test_command "Component description" "command -v component-name"
test_file_exists "Component file" "/path/to/component"
```

### แก้ไข threshold:

```bash
# แก้ไขที่บรรทัด ~580
if [[ $FAILED_TESTS -eq 0 ]]; then
  # 100% pass
elif [[ $PASS_PERCENTAGE -ge 80 ]]; then  # แก้ไขตัวเลขนี้
  # PASS with Issues
else
  # FAIL
fi
```

---

## 🆚 เปรียบเทียบกับ Manual Testing

| ลักษณะ | test-installation.sh | TESTING_CHECKLIST_TH.md |
|--------|---------------------|------------------------|
| **ความเร็ว** | ~30 วินาที | ~30-60 นาที |
| **ความครอบคลุม** | 85-90 tests | 40 test cases |
| **รายละเอียด** | Basic checks | ทดสอบลึกถึงฟังก์ชัน |
| **การใช้งาน** | อัตโนมัติ | Manual |
| **รายงาน** | สรุปอัตโนมัติ | ต้องบันทึกเอง |
| **เหมาะสำหรับ** | Quick verification | Deep testing |

### แนะนำ:

1. **ใช้ test-installation.sh ก่อน** - เพื่อ quick check
2. **ใช้ TESTING_CHECKLIST_TH.md** - สำหรับการทดสอบอย่างละเอียด
3. **ใช้ทั้งสอง** - สำหรับการทดสอบที่สมบูรณ์ที่สุด

---

## 💡 เคล็ดลับ

### 1. บันทึกผลการทดสอบ

```bash
# บันทึก output ลงไฟล์
bash backup/test-installation.sh | tee ~/test-results-$(date +%Y%m%d-%H%M%S).txt

# บันทึกเฉพาะที่ FAIL
bash backup/test-installation.sh | grep FAIL
```

### 2. ทดสอบเฉพาะ phase

```bash
# แก้ไขสคริปต์ชั่วคราว:
# Comment out phases ที่ไม่ต้องการทดสอบ

# หรือ grep เฉพาะ phase ที่สนใจ
bash backup/test-installation.sh | grep -A 20 "Phase 2"
```

### 3. สร้าง alias

```bash
# เพิ่มใน ~/.zshrc
alias test-setup="bash ~/path/to/backup/test-installation.sh"
alias test-setup-save="bash ~/path/to/backup/test-installation.sh | tee ~/test-$(date +%Y%m%d).txt"

source ~/.zshrc

# ใช้งาน
test-setup
test-setup-save
```

---

## 📞 การสนับสนุน

### พบปัญหา?

1. ตรวจสอบ [README.md](../README.md) หลัก
2. อ่าน [TESTING_CHECKLIST_TH.md](TESTING_CHECKLIST_TH.md) สำหรับรายละเอียด
3. ตรวจสอบ [VM_SETUP_GUIDE_TH.md](VM_SETUP_GUIDE_TH.md) สำหรับการทดสอบบน VM
4. เปิด issue บน GitHub repository

---

**เวอร์ชัน:** V7
**สร้างโดย:** Tea Terminal Setup Team
**Repository:** https://github.com/thaicyber/mac-dev-terminal-setup

