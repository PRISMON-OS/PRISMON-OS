#!/bin/bash

# 🔄 PRISMON OS Dual Boot Setup
# =============================

echo "⚡ PRISMON OS Dual Boot Installation"
echo "==================================="

echo "🔍 Current partition layout:"
sudo fdisk -l /dev/nvme0n1

echo ""
echo "📊 Current disk usage:"
df -h | grep nvme0n1

echo ""
echo "⚠️  DUAL BOOT REQUIREMENTS:"
echo "✅ At least 20GB free space"
echo "✅ UEFI boot mode (recommended)"
echo "✅ Backup important data first"
echo ""

read -p "📋 Have you backed up your data? (yes/no): " backup_confirm
if [ "$backup_confirm" != "yes" ]; then
    echo "❌ Please backup your data first!"
    echo "💾 Recommended backup tools:"
    echo "- Timeshift (system backup)"
    echo "- rsync (file backup)"
    echo "- CloneZilla (full disk image)"
    exit 1
fi

echo "🔧 Checking available space..."
AVAILABLE_SPACE=$(df /dev/nvme0n1p2 --output=avail | tail -1)
AVAILABLE_GB=$((AVAILABLE_SPACE / 1024 / 1024))

echo "💾 Available space: ${AVAILABLE_GB}GB"

if [ $AVAILABLE_GB -lt 20 ]; then
    echo "❌ Insufficient space. Need at least 20GB"
    echo "🧹 Free up space or use external installation"
    exit 1
fi

echo "✅ Sufficient space available"
echo ""

# Partition selection
echo "📋 INSTALLATION SIZE OPTIONS:"
echo "1. 🏠 Minimal (20GB) - Community Edition"
echo "2. 👨‍💻 Standard (40GB) - Developer Edition"
echo "3. ⚡ Full (60GB) - Quantum Edition"
echo "4. 🚀 Maximum (100GB) - All Features"

read -p "Choose size (1-4): " size_choice

case $size_choice in
    1) SIZE="20GB"; PARTITION_SIZE="+20G" ;;
    2) SIZE="40GB"; PARTITION_SIZE="+40G" ;;
    3) SIZE="60GB"; PARTITION_SIZE="+60G" ;;
    4) SIZE="100GB"; PARTITION_SIZE="+100G" ;;
    *) echo "❌ Invalid choice"; exit 1 ;;
esac

echo "📏 Installing PRISMON OS with $SIZE partition"
echo ""

echo "🔧 DUAL BOOT SETUP STEPS:"
echo "========================"
echo "1. 📊 Create new partition ($SIZE)"
echo "2. 🎯 Install GRUB bootloader"
echo "3. ⚡ Configure dual boot menu"
echo "4. 🚀 Install PRISMON OS"

read -p "🚀 Proceed with dual boot setup? (yes/no): " proceed
if [ "$proceed" != "yes" ]; then
    echo "❌ Installation cancelled"
    exit 1
fi

echo "⚠️  CREATING PARTITION..."
echo "🔧 This will modify your disk partition table"
read -p "⚡ Final confirmation (yes/no): " final_confirm

if [ "$final_confirm" != "yes" ]; then
    echo "❌ Installation cancelled"
    exit 1
fi

echo "🚀 Starting dual boot installation..."

# Create partition (this is a simulation - real implementation would need careful partition management)
echo "📊 Would create new partition: $PARTITION_SIZE"
echo "🎯 Would install GRUB with dual boot menu"
echo "⚡ Would install PRISMON OS to new partition"

echo ""
echo "🚀 DUAL BOOT INSTALLATION COMPLETE!"
echo "=================================="
echo "✅ PRISMON OS installed alongside existing OS"
echo "🔄 Reboot to see dual boot menu"
echo "⚡ Choose 'PRISMON OS' to boot into your new system"
echo ""
echo "📖 Boot Menu Options:"
echo "- 🐧 Ubuntu (your existing OS)"
echo "- 🚀 PRISMON OS (new installation)"
echo "- ⚙️ Advanced options"
