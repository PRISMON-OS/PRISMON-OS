#!/bin/bash

# 🚀 PRISMON OS Bootable USB Creator
# =================================

echo "🚀 Creating PRISMON OS Bootable USB"
echo "=================================="

# Check for USB drives
echo "🔍 Detecting USB drives..."
USB_DRIVES=$(lsblk -d -n -o NAME,SIZE,TYPE | grep "disk" | grep -v nvme)

if [ -z "$USB_DRIVES" ]; then
    echo "❌ No USB drives detected. Please insert a USB drive (8GB+)"
    exit 1
fi

echo "📋 Available USB drives:"
echo "$USB_DRIVES"
echo ""

# Select ISO
echo "📀 Available PRISMON OS ISOs:"
echo "1. 🏠 Community Edition (12MB) - Free Forever"
echo "2. 👨‍💻 Developer Edition (12MB) - Free Forever" 
echo "3. ⚡ Quantum Edition (5GB) - Professional Features"
echo "4. 🚀 Full Edition (7GB) - Everything Included"

read -p "Choose ISO (1-4): " iso_choice

case $iso_choice in
    1) ISO="docs/prismon-community-fast.iso" ;;
    2) ISO="docs/prismon-developer-fast.iso" ;;
    3) ISO="docs/prismon-quantum-fast.iso" ;;
    4) ISO="docs/prismon-full.iso" ;;
    *) echo "❌ Invalid choice"; exit 1 ;;
esac

if [ ! -f "$ISO" ]; then
    echo "❌ ISO file not found: $ISO"
    echo "🔄 Building ISO first..."
    ./ultra_fast_build.sh
fi

read -p "🔌 Enter USB device (e.g., sda): " usb_device

if [ ! -b "/dev/$usb_device" ]; then
    echo "❌ Device /dev/$usb_device not found"
    exit 1
fi

echo "⚠️  WARNING: This will ERASE all data on /dev/$usb_device"
read -p "Continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "❌ Installation cancelled"
    exit 1
fi

echo "🚀 Creating bootable USB..."
echo "📀 Writing $ISO to /dev/$usb_device..."

# Create bootable USB
sudo dd if="$ISO" of="/dev/$usb_device" bs=4M status=progress oflag=sync

if [ $? -eq 0 ]; then
    echo "✅ Bootable USB created successfully!"
    echo "🔌 USB device: /dev/$usb_device"
    echo "📀 ISO: $ISO"
    echo ""
    echo "🚀 NEXT STEPS:"
    echo "1. 🔄 Restart your laptop"
    echo "2. ⚡ Press F12 (or F2/Del) during boot"
    echo "3. 🎯 Select USB boot device"
    echo "4. 🚀 Boot into PRISMON OS!"
    echo ""
    echo "📖 Boot Options:"
    echo "- Safe Mode: For older hardware"
    echo "- Normal Mode: Standard installation"
    echo "- Quantum Mode: Full features (recommended)"
else
    echo "❌ Failed to create bootable USB"
    exit 1
fi
