#!/bin/bash

echo "🔥 ULTRA FAST USB BURNING GUIDE 🔥"
echo "=================================="
echo ""
echo "⚡ STEP 1: INSERT USB DRIVE (8GB+)"
echo "⚡ STEP 2: CHOOSE YOUR METHOD"
echo ""

# Check available USB drives
echo "🔍 Detecting USB drives..."
USB_DRIVES=$(lsblk -d -n -o NAME,SIZE,MODEL | grep -E 'sd[a-z]' || echo "No USB detected")

if [[ "$USB_DRIVES" != "No USB detected" ]]; then
    echo "✅ USB drives found:"
    echo "$USB_DRIVES"
    echo ""
else
    echo "❌ No USB drives detected. Please insert USB drive first!"
    echo ""
fi

echo "🚀 BURNING METHODS (CHOOSE ONE):"
echo ""

echo "════════════════════════════════════════"
echo "METHOD 1: COMMAND LINE (FASTEST) ⚡"
echo "════════════════════════════════════════"
echo ""
echo "🎯 For Community Edition (12MB):"
echo "sudo dd if=prismon-community-fast.iso of=/dev/sdX bs=4M status=progress"
echo ""
echo "🎯 For Developer Edition (12MB):" 
echo "sudo dd if=prismon-developer-fast.iso of=/dev/sdX bs=4M status=progress"
echo ""
echo "🎯 For Quantum Edition (5GB):"
echo "sudo dd if=docs/prismon-quantum-fast.iso of=/dev/sdX bs=4M status=progress"
echo ""
echo "⚠️  Replace 'sdX' with your USB drive (like sdb, sdc, etc.)"
echo ""

echo "════════════════════════════════════════"
echo "METHOD 2: GRAPHICAL TOOLS (EASY) 🖱️"
echo "════════════════════════════════════════"
echo ""
echo "🔥 Install burning tool:"
echo "sudo apt install balena-etcher-electron"
echo "# OR"
echo "sudo snap install rpi-imager"
echo ""
echo "📀 Then:"
echo "1. Open Etcher or Raspberry Pi Imager"
echo "2. Select ISO file (prismon-community-fast.iso)"
echo "3. Select USB drive"
echo "4. Click 'Flash' or 'Write'"
echo ""

echo "════════════════════════════════════════"
echo "METHOD 3: AUTO DETECTION (SAFEST) 🛡️"
echo "════════════════════════════════════════"
echo ""
echo "🎯 Run auto-burn script:"
echo "./auto_burn.sh"
echo ""

echo "🔥 AFTER BURNING:"
echo "1. Safely eject USB"
echo "2. Insert into target laptop"
echo "3. Restart laptop"
echo "4. Press F12, F2, or DEL during boot"
echo "5. Select USB drive to boot"
echo "6. Enjoy PRISMON OS!"
echo ""
echo "✅ COMPLETELY SAFE - No changes to hard drive!"
echo ""

# Create auto-burn script
cat > auto_burn.sh << 'EOF'
#!/bin/bash

echo "🔥 AUTO USB BURNER 🔥"
echo "==================="

# Detect USB drives
USB_LIST=$(lsblk -d -n -o NAME,SIZE,MODEL | grep -E 'sd[a-z]')

if [[ -z "$USB_LIST" ]]; then
    echo "❌ No USB drives detected!"
    echo "Please insert a USB drive (8GB+) and try again."
    exit 1
fi

echo "📀 Available USB drives:"
echo "$USB_LIST"
echo ""

read -p "Enter USB drive name (like sdb): " USB_DRIVE

if [[ ! -b "/dev/$USB_DRIVE" ]]; then
    echo "❌ Invalid drive: /dev/$USB_DRIVE"
    exit 1
fi

echo ""
echo "🎯 Choose PRISMON OS edition:"
echo "1. Community Edition (12MB) - Fastest"
echo "2. Developer Edition (12MB) - Recommended"
echo "3. Quantum Edition (5GB) - Full features"
echo ""

read -p "Choose (1-3): " CHOICE

case $CHOICE in
    1)
        ISO_FILE="prismon-community-fast.iso"
        ;;
    2)
        ISO_FILE="prismon-developer-fast.iso"
        ;;
    3)
        ISO_FILE="docs/prismon-quantum-fast.iso"
        ;;
    *)
        echo "❌ Invalid choice!"
        exit 1
        ;;
esac

if [[ ! -f "$ISO_FILE" ]]; then
    echo "❌ ISO file not found: $ISO_FILE"
    exit 1
fi

echo ""
echo "⚠️  WARNING: This will erase all data on /dev/$USB_DRIVE"
echo "🎯 ISO: $ISO_FILE"
echo "🎯 Target: /dev/$USB_DRIVE"
echo ""

read -p "Continue? (yes/no): " CONFIRM

if [[ "$CONFIRM" != "yes" ]]; then
    echo "❌ Cancelled!"
    exit 1
fi

echo ""
echo "🔥 Burning ISO to USB..."
echo "⚡ This will take 1-2 minutes..."

sudo dd if="$ISO_FILE" of="/dev/$USB_DRIVE" bs=4M status=progress

if [[ $? -eq 0 ]]; then
    echo ""
    echo "✅ SUCCESS! USB bootable drive created!"
    echo ""
    echo "🚀 NEXT STEPS:"
    echo "1. Safely eject USB"
    echo "2. Insert into target laptop"
    echo "3. Restart and press F12/F2"
    echo "4. Boot from USB"
    echo "5. Enjoy PRISMON OS!"
else
    echo "❌ Error creating bootable USB!"
    exit 1
fi
EOF

chmod +x auto_burn.sh

echo "🎯 BONUS: Auto-burn script created! Run: ./auto_burn.sh"
