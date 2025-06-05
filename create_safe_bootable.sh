#!/bin/bash

echo "🔥 ULTRA SAFE PRISMON OS BOOTABLE CREATOR 🔥"
echo "=============================================="

# Check available ISOs
echo "📀 Available SAFE ISOs:"
echo "1. Community Edition (12MB) - Perfect for testing"
echo "2. Developer Edition (12MB) - Programming tools included"  
echo "3. Quantum Edition (5GB) - Full featured"

echo ""
echo "🎯 SAFEST OPTION: Boot from ISO without installation"
echo "✅ No changes to your hard drive"
echo "✅ Test PRISMON OS completely safely"
echo "✅ Can install later if you like it"
echo ""

# Show current ISOs
echo "📋 Ready ISOs:"
ls -lh docs/*.iso | awk '{print $9, $5}' | head -5

echo ""
echo "🚀 ULTRA FAST OPTIONS:"
echo ""
echo "Option A: Boot Community Edition (FASTEST)"
echo "   - Burn docs/prismon-community-fast.iso to DVD/USB"
echo "   - 12MB download, boots in seconds"
echo ""
echo "Option B: Boot Developer Edition (RECOMMENDED)"  
echo "   - Burn docs/prismon-developer-fast.iso to DVD/USB"
echo "   - 12MB, includes programming tools"
echo ""
echo "Option C: Boot Quantum Edition (FULL POWER)"
echo "   - Burn docs/prismon-quantum-fast.iso to DVD/USB" 
echo "   - 5GB, all features included"
echo ""
echo "🔥 TO BOOT SAFELY:"
echo "1. Insert USB/DVD"
echo "2. Restart laptop"
echo "3. Boot from USB/DVD (F12 or F2 during startup)"
echo "4. Enjoy PRISMON OS - NO INSTALLATION NEEDED!"
echo ""
echo "✅ COMPLETELY SAFE - Your existing OS stays untouched!"
