#!/bin/bash
# PRISMON OS - VARINT (Variable Intelligence) Build Script
# Usage: ./build_varint.sh [adaptive|quantum|neural] [debug|release]

set -e  # Exit on any error

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${PROJECT_ROOT}/build-varint"

# Parse arguments
BUILD_CONFIG="${1:-adaptive}"
BUILD_TYPE="${2:-release}"

# Set options based on configuration
case "${BUILD_CONFIG}" in
    adaptive)
        VARINT_MODE="ADAPTIVE"
        QUANTUM_FEATURES="ON"
        NEURAL_NET="OFF"
        AI_OPTIMIZATION="ON"
        ;;
    quantum)
        VARINT_MODE="QUANTUM"
        QUANTUM_FEATURES="ON"
        NEURAL_NET="ON"
        AI_OPTIMIZATION="ON"
        ;;
    neural)
        VARINT_MODE="NEURAL"
        QUANTUM_FEATURES="OFF"
        NEURAL_NET="ON"
        AI_OPTIMIZATION="ON"
        ;;
    debug)
        VARINT_MODE="ADAPTIVE"
        QUANTUM_FEATURES="ON"
        NEURAL_NET="ON"
        AI_OPTIMIZATION="ON"
        BUILD_TYPE="debug"
        ;;
    *)
        echo "Usage: $0 [adaptive|quantum|neural|debug] [debug|release]"
        echo "Examples:"
        echo "  $0 adaptive         # Adaptive intelligence build"
        echo "  $0 quantum          # Quantum-enhanced build"
        echo "  $0 neural           # Neural network optimized build"
        echo "  $0 debug            # Full debug build with all features"
        exit 1
        ;;
esac

echo "=== PRISMON OS VARINT Build System ==="
echo "Configuration: ${BUILD_CONFIG}"
echo "Build Type: ${BUILD_TYPE}"
echo "VARINT Mode: ${VARINT_MODE}"
echo "Quantum Features: ${QUANTUM_FEATURES}"
echo "Neural Networks: ${NEURAL_NET}"
echo "AI Optimization: ${AI_OPTIMIZATION}"
echo "======================================="

# Clean and prepare build directory
if [[ -d "${BUILD_DIR}" ]]; then
    echo "Cleaning previous VARINT build..."
    rm -rf "${BUILD_DIR}"
fi

mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

# Configure CMake with VARINT options
echo "Configuring VARINT build..."
cmake \
    -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" \
    -DPRISMON_VARINT_BUILD=ON \
    -DPRISMON_VARINT_MODE="${VARINT_MODE}" \
    -DPRISMON_QUANTUM_FEATURES="${QUANTUM_FEATURES}" \
    -DPRISMON_NEURAL_NET="${NEURAL_NET}" \
    -DPRISMON_AI_OPTIMIZATION="${AI_OPTIMIZATION}" \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    "${PROJECT_ROOT}"

# Build the project
echo "Building VARINT variant..."
make -j"$(nproc)" PrismonOS

# Verify build output
if [[ -f "PrismonOS" ]]; then
    echo ""
    echo "✅ VARINT build completed successfully!"
    echo "📁 Output: ${BUILD_DIR}/PrismonOS"
    echo "🧠 Intelligence Mode: ${VARINT_MODE}"
    
    # Display build statistics
    echo ""
    echo "=== Build Statistics ==="
    ls -lh PrismonOS
    file PrismonOS
    echo "========================"
    
    # Optional: Run QEMU test if requested
    if [[ "${3}" == "test" ]]; then
        echo ""
        echo "🚀 Starting QEMU test..."
        cd "${PROJECT_ROOT}"
        ./test_qemu.sh
    fi
else
    echo "❌ Build failed - no output binary found"
    exit 1
fi

echo ""
echo "🎯 VARINT build process completed!"
echo "To test: ./test_qemu.sh"
echo "To create ISO: ./create_quantum_iso.sh"
