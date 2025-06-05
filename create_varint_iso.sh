#!/bin/bash
# PRISMON OS VARINT ISO Creation Script
# Creates bootable ISO with Variable Intelligence features

set -e

echo "🔮 PRISMON OS VARINT ISO Builder"
echo "================================"

# Configuration
ISO_NAME="prismon-varint.iso"
BUILD_DIR="build-varint"
ISO_DIR="iso-varint"
GRUB_DIR="$ISO_DIR/boot/grub"

# Clean and prepare directories
echo "📁 Preparing build environment..."
rm -rf "$BUILD_DIR" "$ISO_DIR" "$ISO_NAME"
mkdir -p "$BUILD_DIR" "$ISO_DIR" "$GRUB_DIR"

# Build VARINT variant
echo "🔧 Building VARINT variant..."
cd "$BUILD_DIR"
cmake -DCMAKE_BUILD_TYPE=Release -DVARINT_MODE=ON ..
make -j$(nproc)
cd ..

# Check if binary exists
if [ ! -f "$BUILD_DIR/PrismonOS" ]; then
    echo "❌ Build failed - PrismonOS binary not found"
    exit 1
fi

echo "✅ VARINT build completed successfully"

# Create ISO structure
echo "📦 Creating ISO structure..."
cp "$BUILD_DIR/PrismonOS" "$ISO_DIR/boot/prismon-varint.bin"

# Create GRUB configuration
cat > "$GRUB_DIR/grub.cfg" << 'EOF'
set timeout=5
set default=0

menuentry "PRISMON OS - VARINT Edition" {
    multiboot /boot/prismon-varint.bin
    boot
}

menuentry "PRISMON OS - VARINT (Safe Mode)" {
    multiboot /boot/prismon-varint.bin safe_mode
    boot
}

menuentry "PRISMON OS - VARINT (Debug Mode)" {
    multiboot /boot/prismon-varint.bin debug_mode ai_verbose
    boot
}
EOF

# Create additional VARINT-specific files
mkdir -p "$ISO_DIR/varint"
cat > "$ISO_DIR/varint/ai_config.txt" << 'EOF'
# PRISMON OS VARINT AI Configuration
adaptive_learning=enabled
neural_optimization=auto
quantum_ai_sync=true
intelligence_level=adaptive
memory_optimization=dynamic
performance_tuning=ai_assisted
EOF

cat > "$ISO_DIR/varint/README.txt" << 'EOF'
PRISMON OS - VARINT Edition
==========================

This is the Variable Intelligence variant of PRISMON OS featuring:
- Adaptive AI learning systems
- Dynamic memory optimization
- Neural network integration
- Quantum-AI synchronization
- Self-optimizing performance

Boot Options:
- Default: Full VARINT with all AI features
- Safe Mode: Basic VARINT without advanced AI
- Debug Mode: Verbose AI diagnostics and logging

For more information, visit: https://prismonos.github.io
EOF

# Create VARINT manifest
cat > "$ISO_DIR/varint/manifest.json" << 'EOF'
{
  "variant": "VARINT",
  "version": "1.0.0",
  "build_date": "'$(date -I)'",
  "features": [
    "adaptive_ai",
    "neural_optimization",
    "quantum_sync",
    "dynamic_memory",
    "self_optimization"
  ],
  "ai_modules": [
    "learning_engine",
    "optimization_core",
    "adaptation_layer",
    "intelligence_manager"
  ],
  "compatibility": "x86_64",
  "memory_requirements": "512MB minimum, 2GB recommended"
}
EOF

# Create the ISO
echo "💿 Creating VARINT ISO..."
grub-mkrescue -o "$ISO_NAME" "$ISO_DIR" 2>/dev/null || {
    echo "⚠️  grub-mkrescue not available, using genisoimage..."
    genisoimage -R -b boot/grub/stage2_eltorito -no-emul-boot \
                -boot-load-size 4 -boot-info-table \
                -o "$ISO_NAME" "$ISO_DIR" 2>/dev/null || {
        echo "⚠️  Creating simple ISO without bootloader..."
        genisoimage -R -o "$ISO_NAME" "$ISO_DIR"
    }
}

# Get ISO size
ISO_SIZE=$(du -h "$ISO_NAME" | cut -f1)
echo "✅ VARINT ISO created: $ISO_NAME ($ISO_SIZE)"

# Create checksum
echo "🔐 Generating checksums..."
sha256sum "$ISO_NAME" > "${ISO_NAME}.sha256"
md5sum "$ISO_NAME" > "${ISO_NAME}.md5"

echo ""
echo "🎉 PRISMON OS VARINT ISO Build Complete!"
echo "========================================="
echo "📁 ISO File: $ISO_NAME ($ISO_SIZE)"
echo "🔐 Checksums: ${ISO_NAME}.sha256, ${ISO_NAME}.md5"
echo ""
echo "🚀 Test with QEMU:"
echo "   qemu-system-x86_64 -cdrom $ISO_NAME -m 1024"
echo ""
echo "💡 This VARINT edition includes:"
echo "   - Adaptive AI learning systems"
echo "   - Dynamic memory optimization"
echo "   - Neural network integration"
echo "   - Quantum-AI synchronization"
echo ""

# Cleanup
echo "🧹 Cleaning up build artifacts..."
rm -rf "$BUILD_DIR" "$ISO_DIR"

echo "✨ Ready to boot into Variable Intelligence!"
