#!/bin/bash
# PRISMON OS FULL Large Distribution ISO Creation Tool
# Creates a 7GB bootable ISO with all features

set -e

echo "Building PRISMON OS FULL Large Distribution ISO (7GB)..."

# First build the FULL variant
echo "Building FULL variant..."
./build_final.sh

# Check if kernel was built
KERNEL_PATH=""
if [ -f "build-final/PrismonOS" ]; then
    KERNEL_PATH="build-final/PrismonOS"
elif [ -f "build-final/prismon_kernel" ]; then
    KERNEL_PATH="build-final/prismon_kernel"
else
    echo "Error: FULL kernel not found in build-final/"
    exit 1
fi

echo "Using kernel: $KERNEL_PATH"

# Create large ISO with 7GB target size
if [ ! -f "tools/create_large_iso.sh" ]; then
    echo "Error: tools/create_large_iso.sh not found"
    exit 1
fi

chmod +x tools/create_large_iso.sh
./tools/create_large_iso.sh "$KERNEL_PATH" "prismon-full-large.iso" "7G"

# Copy to docs directory for website
cp "prismon-full-large.iso" "docs/"

echo "FULL Large ISO created successfully!"
echo "File: prismon-full-large.iso (7GB)"
echo "Website copy: docs/prismon-full-large.iso"

# Show file sizes
ls -lh prismon-full-large.iso docs/prismon-full-large.iso 2>/dev/null || echo "Files created"
