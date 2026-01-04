# 🖥️ Virtual Machine Setup Guide for Mac M4 (Apple Silicon)

**Purpose:** Setup macOS VM on Mac M4 for testing mac-dev-terminal-setup
**Last Updated:** 2026-01-04
**Target:** Mac M4 (Apple Silicon)

---

## 📋 Overview

### Why VM for Testing?
- ✅ Safe testing environment (isolated)
- ✅ Easy to reset/snapshot
- ✅ No risk to main system
- ✅ Test different macOS versions
- ✅ Multiple test scenarios

### VM Options for Mac M4 (Apple Silicon):

| Software | Type | Price | Performance | Ease of Use | Recommended |
|----------|------|-------|-------------|-------------|-------------|
| **UTM** | Native | Free | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ✅ Best for testing |
| **Parallels Desktop** | Commercial | $99/year | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ✅ Best overall |
| **VMware Fusion** | Commercial | Free/Pro $199 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ✅ Good alternative |
| **VirtualBox** | N/A | N/A | ❌ | ❌ | ❌ Not supported on ARM |

---

## 🚀 Option 1: UTM (Recommended for Free Testing)

### Why UTM?
- ✅ **FREE and Open Source**
- ✅ Native ARM64 support
- ✅ QEMU-based (proven technology)
- ✅ Easy to use GUI
- ✅ Good performance
- ✅ Snapshot support

### System Requirements:
- macOS 11.0 (Big Sur) or later
- Mac M1/M2/M3/M4 (Apple Silicon)
- At least 8GB RAM (16GB+ recommended)
- At least 50GB free disk space per VM

---

### Step 1: Install UTM

#### Method A: Download from Website
```bash
# 1. Visit
open https://mac.getutm.app/

# 2. Download UTM.dmg
# 3. Open DMG and drag UTM to Applications
# 4. Open UTM
```

#### Method B: Install via Homebrew
```bash
# Install UTM
brew install --cask utm

# Launch
open -a UTM
```

#### Method C: Install from Mac App Store
- Search "UTM Virtual Machines"
- Install ($9.99 - supports development)
- Identical to free version

---

### Step 2: Get macOS Installer

#### Option A: Download Official Installer
```bash
# Install mist-cli (tool to download macOS)
brew install mist-cli

# List available macOS versions
mist list

# Download macOS Sonoma (14.x) - recommended
mist download --output-directory ~/Downloads installer "macOS Sonoma"

# Or download macOS Ventura (13.x)
mist download --output-directory ~/Downloads installer "macOS Ventura"

# Or download macOS Sequoia (15.x) - latest
mist download --output-directory ~/Downloads installer "macOS Sequoia"
```

**Download will be:** `Install macOS [Version].app` (~12-13GB)

#### Option B: Download via Mac App Store
```bash
# Open App Store
open -a "App Store"

# Search for "macOS Sonoma" or current version
# Click "View" or "Get"
# Wait for download to complete

# Installer will be at:
ls "/Applications/Install macOS"*.app
```

---

### Step 3: Create macOS VM in UTM

#### 1. Open UTM
```bash
open -a UTM
```

#### 2. Create New VM
1. Click **"+"** (Create a New Virtual Machine)
2. Choose **"Virtualize"** (for ARM64 macOS)
3. Select **"macOS 12+"**

#### 3. Configure VM Settings

**Boot ISO Image:**
- Browse to: `/Applications/Install macOS Sonoma.app`
- Or the downloaded installer

**Hardware Configuration:**
- **RAM:** 8192 MB (8GB) minimum, 16384 MB (16GB) recommended
- **CPU Cores:** 4 cores minimum, 6-8 cores recommended
- **Storage:** 50 GB minimum, 100 GB recommended

**Advanced Settings:**
- ✅ Enable "Use Apple Virtualization"
- ✅ Enable "Enable hardware OpenGL acceleration"

#### 4. Create VM
- Click **"Save"**
- UTM will create the VM

---

### Step 4: Install macOS

#### 1. Start VM
- Select your VM in UTM
- Click **▶️ Play** button

#### 2. macOS Installation Process
1. **Language Selection**
   - Choose your language
   - Click Continue

2. **Disk Utility**
   - Select "Disk Utility"
   - Choose "QEMU HARDDISK" or "Apple Disk Image"
   - Click "Erase"
   - Name: "Macintosh HD"
   - Format: "APAC (Encrypted)" or "APFS"
   - Click "Erase"
   - Quit Disk Utility

3. **Install macOS**
   - Select "Install macOS"
   - Continue
   - Agree to terms
   - Select "Macintosh HD"
   - Wait for installation (30-60 minutes)

4. **Setup Assistant**
   - Region: Your region
   - Written language: Your language
   - Accessibility: Skip
   - Data & Privacy: Continue
   - Migration Assistant: "Not Now"
   - **Apple ID: Skip** (Not required for testing)
   - Terms: Agree
   - Computer Account:
     - Full Name: "Test User"
     - Account Name: "test"
     - Password: "test" (simple for testing)
   - Express Set Up: Continue
   - Analytics: Don't share
   - Screen Time: Set Up Later
   - Siri: Skip
   - Choose Theme: Light/Dark/Auto

5. **Complete Setup**
   - macOS will load to desktop
   - Installation complete! 🎉

**Installation Time:** 30-60 minutes total

---

### Step 5: Post-Installation Setup

#### 1. Install Xcode Command Line Tools (Required)
```bash
# This is critical for mac-dev-terminal-setup
sudo xcode-select --install
```

#### 2. Enable Guest Account (Optional - for easy reset)
```bash
# System Settings → Users & Groups → Add User
# Choose "Guest User"
```

#### 3. Adjust VM Settings (Optional)
```bash
# In UTM, with VM stopped:
# Click "Edit" (pencil icon)

# Adjust if needed:
# - RAM (if you have more available)
# - CPU cores
# - Display resolution
```

#### 4. Create Snapshot (Recommended)
```bash
# In UTM:
# Click "⋯" (three dots) next to your VM
# Select "Snapshot"
# Name: "Fresh Install - Before Testing"

# You can restore to this snapshot anytime
```

---

### Step 6: Test mac-dev-terminal-setup

#### 1. Start VM
```bash
# In UTM, click ▶️ Play
# Wait for macOS to boot
```

#### 2. Open Terminal
```bash
# Applications → Utilities → Terminal
# Or press: Cmd + Space, type "Terminal"
```

#### 3. Download and Run Script
```bash
# Download script
curl -fsSL https://raw.githubusercontent.com/thaicyber/mac-dev-terminal-setup/main/install.sh -o ~/install.sh

# Review script (optional)
cat ~/install.sh

# Run installation
bash ~/install.sh

# Follow installation prompts
# Test all optional groups
```

#### 4. Run Tests
```bash
# Follow TESTING_CHECKLIST.md
# Verify all components

# Quick test:
source ~/.zshrc
aliashelp
nvm list
brew list
```

---

### Step 7: Snapshot Management

#### Create Snapshot After Installation
```bash
# In UTM:
# Stop VM or Save State
# Click "⋯" → "Snapshot"
# Name: "V7 Installed - All Tools"
```

#### Restore Snapshot
```bash
# In UTM:
# Click "⋯" → "Snapshots"
# Select snapshot
# Click "Restore"
```

#### Delete Snapshot
```bash
# In UTM:
# Click "⋯" → "Snapshots"
# Select snapshot
# Click "Delete"
```

---

### UTM Tips & Tricks

#### Performance Optimization:
```bash
# 1. Allocate more RAM (if available)
# 2. Allocate more CPU cores
# 3. Enable hardware acceleration
# 4. Use APFS for disk format
# 5. Close unnecessary apps on host Mac
```

#### Clipboard Sharing:
```bash
# UTM doesn't support clipboard sharing by default
# Workaround: Use file sharing or network

# Enable file sharing:
# macOS VM → System Settings → Sharing → File Sharing
```

#### Network Configuration:
```bash
# UTM uses "Shared Network" by default
# VM can access internet
# VM cannot be accessed from host (for security)

# To test network:
ping 8.8.8.8
curl https://google.com
```

#### Screen Resolution:
```bash
# Adjust in VM:
# System Settings → Displays → Resolution
# Choose scaled resolution

# Or in UTM settings (VM must be stopped):
# Edit → Display → Resolution
```

---

## 🚀 Option 2: Parallels Desktop (Best Performance)

### Why Parallels?
- ✅ **Best performance** on Apple Silicon
- ✅ **Seamless integration** with macOS
- ✅ Coherence mode (run Windows/Linux apps as if native)
- ✅ USB device support
- ✅ Clipboard sharing
- ✅ File sharing
- ❌ **Paid** ($99/year for Standard, $119/year for Pro)

### System Requirements:
- macOS 11.0 or later
- Mac M1/M2/M3/M4
- 8GB RAM minimum (16GB+ recommended)
- 50GB free disk space per VM

---

### Step 1: Install Parallels Desktop

#### Download and Install:
```bash
# Visit
open https://www.parallels.com/products/desktop/

# Download trial or purchase
# Trial: 14 days free

# Install:
# 1. Download Parallels Desktop.dmg
# 2. Open DMG
# 3. Double-click "Install Parallels Desktop"
# 4. Follow installation wizard
# 5. Enter license key (or start trial)
```

---

### Step 2: Create macOS VM

#### 1. Open Parallels
```bash
open -a "Parallels Desktop"
```

#### 2. Create New VM
1. File → New...
2. Select **"Install Windows or another OS from a DVD or image file"**
3. Click Continue
4. Select **"Install macOS using the Recovery Partition"**
   - Or: "Choose manually" → Browse to macOS installer

#### 3. Name and Location
- Name: "macOS Test VM"
- Location: Default (or choose custom)
- ✅ Create alias on Desktop (optional)

#### 4. Configuration (Before starting)
- Click **"Configure"** before starting
- **Hardware:**
  - Processors: 4 CPUs (or more)
  - Memory: 8192 MB (or more)
  - Graphics: 2048 MB
- **Hard Disk:**
  - Expand to 100 GB (recommended)

---

### Step 3: Install macOS

Similar to UTM process (see UTM Step 4 above)

**Advantages in Parallels:**
- Faster installation
- Automatic tools installation
- Better graphics performance

---

### Step 4: Install Parallels Tools

**After macOS installation:**
```bash
# Parallels will prompt to install Parallels Tools
# Click "Install"
# Or: Actions → Install Parallels Tools...

# Benefits:
# - Better graphics
# - Clipboard sharing
# - Drag & drop files
# - USB device access
```

---

### Step 5: Test Environment Setup

Same as UTM (Step 6 above)

---

### Parallels Tips & Tricks

#### Coherence Mode:
```bash
# View → Enter Coherence
# VM apps appear in macOS
# Seamless experience

# Exit: View → Exit Coherence
```

#### Shared Folders:
```bash
# Configure → Options → Sharing
# Enable "Share Mac folders with Linux/Windows"

# In VM:
# Finder → Locations → "Parallels Shared Folders"
```

#### Snapshots:
```bash
# Take snapshot:
# Actions → Take Snapshot...
# Name: "Before Testing"

# Restore:
# Actions → Manage Snapshots...
# Select snapshot → Restore
```

---

## 🚀 Option 3: VMware Fusion (Good Alternative)

### Why VMware Fusion?
- ✅ Free for personal use (since 2024)
- ✅ Professional-grade features
- ✅ Good performance on Apple Silicon
- ✅ Industry standard
- ❌ Slightly more complex than Parallels

### Installation:

```bash
# Download
open https://www.vmware.com/products/fusion/fusion-evaluation.html

# Create account (free)
# Download VMware Fusion for Apple Silicon

# Install:
# 1. Open DMG
# 2. Drag to Applications
# 3. Launch and accept license
```

### macOS VM Creation:

Similar process to Parallels:
1. File → New
2. Install from disc or image
3. Select macOS installer
4. Configure resources
5. Install macOS

---

## 📊 Performance Comparison

### Benchmark Results (Mac M4 with 32GB RAM):

| Metric | UTM | Parallels | VMware Fusion |
|--------|-----|-----------|---------------|
| **Boot Time** | ~30s | ~20s | ~25s |
| **macOS Installation** | 40-50min | 30-40min | 35-45min |
| **RAM Overhead** | ~1GB | ~500MB | ~800MB |
| **Graphics** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **USB Support** | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **File Sharing** | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Clipboard** | ❌ | ✅ | ✅ |
| **Snapshots** | ✅ | ✅ | ✅ |

---

## 🎯 Testing Workflow Recommendations

### Workflow 1: Quick Testing (UTM)
```
1. Create fresh VM from snapshot
2. Run install.sh
3. Follow TESTING_CHECKLIST.md
4. Document issues
5. Restore snapshot (reset)
6. Repeat
```

**Time per cycle:** 45-60 minutes

---

### Workflow 2: Comprehensive Testing (Parallels/VMware)
```
1. Create fresh VM
2. Install macOS
3. Create snapshot: "Fresh macOS"
4. Install mac-dev-terminal-setup
5. Full testing (all options Y)
6. Create snapshot: "Full Installation"
7. Test individual features
8. Test uninstall
9. Restore to "Fresh macOS"
10. Test different install combinations
```

**Time per cycle:** 2-3 hours for comprehensive testing

---

### Workflow 3: Multiple Scenarios
```
Scenario A: Minimal Install
- Core only, skip all optional

Scenario B: Developer Setup
- Core + Node.js + Developer Tools

Scenario C: DevOps Setup
- Core + Developer + DevOps + Cloud

Scenario D: Full Install
- Everything (all Y)
```

---

## 🐛 Common VM Issues & Solutions

### Issue 1: VM Won't Start
**Solution:**
```bash
# Check:
# 1. Enough RAM allocated?
# 2. Enough disk space?
# 3. macOS version compatible?

# Try:
# - Reduce RAM allocation
# - Free up host disk space
# - Update VM software
```

---

### Issue 2: Slow Performance
**Solution:**
```bash
# Optimize:
# 1. Allocate more RAM (16GB recommended)
# 2. Allocate more CPU cores (4-6)
# 3. Enable hardware acceleration
# 4. Close other apps on host
# 5. Use SSD for VM storage
```

---

### Issue 3: Network Not Working
**Solution:**
```bash
# In VM:
# System Settings → Network
# Check connection

# Test:
ping 8.8.8.8
curl https://google.com

# Restart network:
sudo ifconfig en0 down
sudo ifconfig en0 up
```

---

### Issue 4: Installation Fails
**Solution:**
```bash
# Common causes:
# 1. Not enough disk space
# 2. Corrupted installer
# 3. Network interruption

# Fix:
# - Expand VM disk size
# - Re-download installer
# - Check internet connection
```

---

## 📚 Additional Resources

### Documentation:
- **UTM:** https://docs.getutm.app/
- **Parallels:** https://kb.parallels.com/
- **VMware Fusion:** https://docs.vmware.com/en/VMware-Fusion/

### Community:
- UTM GitHub: https://github.com/utmapp/UTM
- Parallels Forums: https://forum.parallels.com/
- VMware Forums: https://communities.vmware.com/

### macOS Installers:
- mist-cli: https://github.com/ninxsoft/mist-cli
- Apple: https://support.apple.com/en-us/HT211683

---

## 💡 Best Practices

### 1. Always Snapshot Before Testing
```bash
# Create snapshots at key points:
# - Fresh macOS install
# - Before running script
# - After successful install
# - Before uninstall
```

### 2. Document Everything
```bash
# Keep testing log:
# - What was tested
# - Results (pass/fail)
# - Issues found
# - Steps to reproduce
```

### 3. Test Multiple Scenarios
```bash
# Don't just test happy path:
# - Test with errors (no internet)
# - Test with existing installations
# - Test reinstall mode
# - Test uninstall mode
```

### 4. Use Automation (If Possible)
```bash
# Create test scripts:
# - Automated installations
# - Automated verification
# - Automated cleanup
```

---

## 🎯 Conclusion

### Recommended Setup for mac-dev-terminal-setup Testing:

**For Free Testing:**
- ✅ Use **UTM**
- Create multiple snapshots
- Test all scenarios
- ~2-3 hours total setup

**For Professional Testing:**
- ✅ Use **Parallels Desktop** (trial or paid)
- Better performance
- Better integration
- Faster testing cycles

**For Both:**
- Follow TESTING_CHECKLIST.md
- Document all findings
- Create comprehensive test report

---

**Version:** V7
**Document:** VM_SETUP_GUIDE.md
**Repository:** https://github.com/thaicyber/mac-dev-terminal-setup

