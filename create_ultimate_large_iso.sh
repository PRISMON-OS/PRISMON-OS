#!/bin/bash
# PRISMON OS ULTIMATE Large Distribution ISO Creation Tool
# Creates an 8GB bootable ISO with ultimate features

set -e

echo "Building PRISMON OS ULTIMATE Large Distribution ISO (8GB)..."

# First build the ultimate variant (using final build)
echo "Building ULTIMATE variant..."
./build_final.sh

# Check if kernel was built
KERNEL_PATH=""
if [ -f "build-final/PrismonOS" ]; then
    KERNEL_PATH="build-final/PrismonOS"
elif [ -f "build-final/prismon_kernel" ]; then
    KERNEL_PATH="build-final/prismon_kernel"
else
    echo "Error: ULTIMATE kernel not found in build-final/"
    exit 1
fi

echo "Using kernel: $KERNEL_PATH"

# Create large ISO with 8GB target size
if [ ! -f "tools/create_large_iso.sh" ]; then
    echo "Error: tools/create_large_iso.sh not found"
    exit 1
fi

chmod +x tools/create_large_iso.sh
./tools/create_large_iso.sh "$KERNEL_PATH" "prismon-ultimate-large.iso" "8G"

# Copy to docs directory for website
cp "prismon-ultimate-large.iso" "docs/"

echo "ULTIMATE Large ISO created successfully!"
echo "File: prismon-ultimate-large.iso (8GB)"
echo "Website copy: docs/prismon-ultimate-large.iso"

# Show file sizes
ls -lh prismon-ultimate-large.iso docs/prismon-ultimate-large.iso 2>/dev/null || echo "Files created"
