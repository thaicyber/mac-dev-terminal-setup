# 🍵 mac-dev-terminal-setup  
**Tea’s macOS Terminal Setup — Fast, Beautiful, Productive**

สคริปต์ช่วยติดตั้ง Terminal สำหรับ macOS แบบครบชุดใน 1 คำสั่ง  
เหมาะสำหรับนักพัฒนา Node.js, Backend, DevOps, Git, Docker, Kubernetes

---

## 🚀 Install (One-line Setup)

ติดตั้งทุกอย่างในครั้งเดียว (แนะนำ):

```bash
curl -fsSL https://raw.githubusercontent.com/thaicyber/mac-dev-terminal-setup/main/install.sh | bash
```

เสร็จแล้วให้:

1. ปิด/เปิด iTerm2 ใหม่  
2. ตั้งค่า Font → **JetBrainsMono Nerd Font**  
3. ตั้งค่า Color Preset → **Tokyo Night**  
4. พร้อมใช้งานทันที 🎉  

---

## 📁 โครงสร้างโปรเจกต์

```
mac-dev-terminal-setup/
│── install.sh
│── p10k-tea-tokyonight-one-line.zsh
└── README.md
```

---

## 🧩 สิ่งที่ install.sh ทำให้อัตโนมัติ

### ✔ ติดตั้ง:
- Homebrew (ถ้ายังไม่มี)
- iTerm2
- Zsh
- Oh My Zsh
- Zsh Plugins  
  - autosuggestions  
  - syntax highlighting  

### ✔ ดาวน์โหลดและติดตั้ง Theme:
- `p10k-tea-tokyonight-one-line.zsh`  
- ตั้งเป็น Theme หลักของ Powerlevel10k

### ✔ Import สีสำหรับ iTerm2:
- Tokyo Night  
- One Dark (สำรอง)

### ✔ ตั้งค่า Thai-safe UTF-8:
```
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
| `ll` | list ไฟล์ |
| `gs` | git status |
| `gp` | git pull |
| `dps` | docker ps |
| `topcpu` | แสดง CPU สูงสุด |
| `portfind 3000` | หา process ที่ใช้ port 3000 |

ดู shortcuts ทั้งหมดได้ด้วย:

```bash
aliashelp
```

---

## 🎨 Powerlevel10k Theme (Tea Edition)

ไฟล์ theme:

- `p10k-tea-tokyonight-one-line.zsh`

จุดเด่น:
- Layout แบบ **One-line Minimal**
- โทนสี **Tokyo Night**
- อ่าน console.log ชัดเจน (สำคัญมากสำหรับ Node.js)
- Thai-safe  
- ใช้ Nerd Font เต็มระบบ  
- Git segment สวยงาม  
- Directory ชัดเจน  
- ไม่บดบัง log

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

### ❗ icon เป็นสี่เหลี่ยม  
ต้องตั้ง **Nerd Font** ใน iTerm2

### ❗ สีไม่เหมือน  
ต้องเลือก Preset → **Tokyo Night**

### ❗ autosuggestion ไม่ขึ้น  
ตรวจสอบว่า `.zshrc` มีบรรทัด:

```
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
```

### ❗ theme ไม่โหลด  
ตรวจสอบไฟล์:
```
~/.p10k.zsh
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

## 🙌 Feedback / Feature Request

ยินดีช่วยเพิ่ม:
- uninstall.sh  
- auto-detect Node/PNPM/NVM  
- DevOps version (k8s + aws profile)  
- Cyberpunk Neon style  
- Theme Pack

เปิด Issue ใน repo ได้เลย หรือแจ้งผ่านผู้สร้างระบบ (Tea / ChatGPT)
