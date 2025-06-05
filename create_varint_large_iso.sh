#!/bin/bash
# PRISMON OS VARINT Large Distribution ISO Creation Tool
# Creates a 4GB bootable ISO with VARINT features

set -e

echo "Building PRISMON OS VARINT Large Distribution ISO (6GB)..."

# First build the VARINT variant
echo "Building VARINT variant..."
if [ ! -f "build_varint.sh" ]; then
    echo "Error: build_varint.sh not found"
    exit 1
fi

chmod +x build_varint.sh
./build_varint.sh

# Check if kernel was built
KERNEL_PATH=""
if [ -f "build-varint/PrismonOS" ]; then
    KERNEL_PATH="build-varint/PrismonOS"
elif [ -f "build-varint/prismon_kernel" ]; then
    KERNEL_PATH="build-varint/prismon_kernel"
else
    echo "Error: VARINT kernel not found in build-varint/"
    exit 1
fi

echo "Using kernel: $KERNEL_PATH"

# Create large ISO with 6GB target size
if [ ! -f "tools/create_large_iso.sh" ]; then
    echo "Error: tools/create_large_iso.sh not found"
    exit 1
fi

chmod +x tools/create_large_iso.sh
./tools/create_large_iso.sh "$KERNEL_PATH" "prismon-varint-large.iso" "6G"

# Copy to docs directory for website
cp "prismon-varint-large.iso" "docs/"

echo "VARINT Large ISO created successfully!"
echo "File: prismon-varint-large.iso (6GB)"
echo "Website copy: docs/prismon-varint-large.iso"

# Show file sizes
ls -lh prismon-varint-large.iso docs/prismon-varint-large.iso 2>/dev/null || echo "Files created"
