#!/bin/bash
# Build script for RAK3112 firmware
set -e

echo "=================================================="
echo "RAK3112 Firmware Build Script"
echo "=================================================="
echo ""

# Check if PlatformIO is installed
if ! command -v pio &> /dev/null; then
    echo "Installing PlatformIO..."
    pip3 install -U platformio
fi

echo "PlatformIO version:"
pio --version
echo ""

# Build environment
ENV_NAME="rak3112"
echo "Building environment: $ENV_NAME"
echo ""

# Try to build
echo "Starting build process..."
echo "This may take 10-20 minutes on first run as it downloads"
echo "the ESP32 SDK, toolchains, and library dependencies."
echo ""

if pio run -e $ENV_NAME; then
    echo ""
    echo "=================================================="
    echo "Build successful!"
    echo "=================================================="
    echo ""
    
    # Find the build output
    BUILD_DIR=".pio/build/$ENV_NAME"
    VERSION=$(./bin/buildinfo.py long 2>/dev/null || echo "unknown")
    
    echo "Firmware files generated:"
    echo ""
    ls -lh "$BUILD_DIR"/firmware-$ENV_NAME-*.bin 2>/dev/null || echo "No .bin files found"
    ls -lh "$BUILD_DIR"/firmware-$ENV_NAME-*.factory.bin 2>/dev/null || echo "No .factory.bin files found"
    ls -lh "$BUILD_DIR"/firmware-$ENV_NAME-*.elf 2>/dev/null || echo "No .elf files found"
    echo ""
    
    echo "Files are located in: $BUILD_DIR"
    echo ""
    
    # Copy to release directory
    if [ -d "release" ]; then
        rm -rf release/*
    else
        mkdir -p release
    fi
    
    if [ -f "$BUILD_DIR/firmware-$ENV_NAME-$VERSION.bin" ]; then
        cp "$BUILD_DIR"/firmware-$ENV_NAME-* release/ 2>/dev/null || true
        echo "Firmware copied to ./release/ directory"
        ls -lh release/
    fi
else
    echo ""
    echo "=================================================="
    echo "Build failed!"
    echo "=================================================="
    echo ""
    echo "Common issues:"
    echo "1. Network connectivity - requires access to:"
    echo "   - registry.platformio.org"
    echo "   - github.com"
    echo "   - dl.espressif.com"
    echo ""
    echo "2. Insufficient disk space (need ~2GB)"
    echo "3. Missing system dependencies"
    echo ""
    echo "See BUILD_INSTRUCTIONS.md for alternative build methods"
    exit 1
fi
