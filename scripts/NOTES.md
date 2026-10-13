# 📋 System & Desktop Command Cheatsheet (`NOTES.md`)

Consolidated quick-reference commands, launch flags, and snippets previously stored as individual text files in `commands/`.

---

## 1. Wayland / Electron Launch Flags
Use these flags for VS Code, Cursor, Antigravity, or other Chromium/Electron applications to force native Wayland rendering:
```bash
--enable-features=UseOzonePlatform --ozone-platform=wayland
```

---

## 2. Gaming, Vulkan ICD & GPU Selection

### Feral GameMode
Verify if GameMode is currently active while a game is running:
```bash
gamemoded -s
```
Steam Launch Options to enable GameMode:
```bash
gamemoderun %command%
```

### Vulkan ICD Selection (Force Specific GPU)
Force an application or Steam game to run on a specific Vulkan driver:
```bash
# Force Intel UHD / HD Integrated Graphics:
VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/intel_icd.x86_64.json %command%

# Force AMD Radeon (RADV):
VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/radeon_icd.x86_64.json %command%

# Force NVIDIA Discrete GPU:
VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json %command%
```

### Optimus Manager (HP Omen / Hybrid Laptops)
Configuration file location:
```bash
/etc/optimus-manager/optimus-manager.conf
```

---

## 3. Power Profiles Daemon (`powerprofilesctl`)
Or use `~/dotfiles/scripts/hardware/common/power-profile.sh [status|cycle|performance|balanced|power-saver]`.
```bash
# List available profiles and active driver (intel_pstate / amd-pstate):
powerprofilesctl

# Switch profile manually:
powerprofilesctl set performance
powerprofilesctl set balanced
powerprofilesctl set power-saver
```

---

## 4. Disk & NTFS Mounting
Or use `~/dotfiles/scripts/system/mount-games-disk.sh`.
```bash
# Inspect block devices and partitions:
sudo fdisk -l
lsblk -f

# Mount NTFS drive using the .bashrc alias (sudo mount -t ntfs-3g):
mountntfs /dev/sda1 /mnt/drive

# Fix dirty NTFS volume if Windows fast-startup locked it:
fixntfs /dev/sda1
```

---

## 5. Git & Dotfiles Quick Reference

### Dotfiles (`~/dotfiles` Symlinked Workflow)
```bash
dotsync "Commit message"   # Snapshot packages, machine profile, configs & push to GitHub
dotstatus                  # Check git status of ~/dotfiles
dotdiff                    # View unstaged changes in ~/dotfiles
dotcd                      # Jump to ~/dotfiles
```

### SSH & GitHub Connectivity Check
```bash
ssh -T git@github.com
gh auth status
```

### Legacy Bare-Repo Reference (Historical)
```bash
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dotfiles add <file>
dotfiles commit -am "Update"
dotfiles push
```

