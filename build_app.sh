#!/bin/bash

# HiDPI Configurator App Build Script
# This script builds the SwiftUI application

set -e

echo "🚀 Building HiDPI Configurator App..."

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode is not installed or not in PATH"
    echo "Please install Xcode from the App Store"
    exit 1
fi

# Check if we're in the right directory
if [[ ! -f "hidpi.sh" ]]; then
    echo "❌ Please run this script from the project root directory"
    exit 1
fi

# Create build directory
BUILD_DIR="build"
mkdir -p "$BUILD_DIR"

echo "📦 Building application..."

# Build the app
xcodebuild \
    -project "HiDPI_Configurator.xcodeproj" \
    -scheme "HiDPI Configurator" \
    -configuration Release \
    -derivedDataPath "$BUILD_DIR" \
    build

# Check if build was successful
if [[ $? -eq 0 ]]; then
    echo "✅ Build completed successfully!"
    
    # Copy the built app to the current directory
    APP_PATH="$BUILD_DIR/Build/Products/Release/HiDPI Configurator.app"
    if [[ -d "$APP_PATH" ]]; then
        cp -R "$APP_PATH" "./"
        echo "📱 App copied to: ./HiDPI Configurator.app"
        echo ""
        echo "🎉 HiDPI Configurator is ready!"
        echo "You can now run: open 'HiDPI Configurator.app'"
    else
        echo "❌ Built app not found at expected location"
        exit 1
    fi
else
    echo "❌ Build failed"
    exit 1
fi

echo ""
echo "🔧 Additional setup:"
echo "1. The app will need to access the hidpi.sh script"
echo "2. Make sure hidpi.sh has execute permissions: chmod +x hidpi.sh"
echo "3. The app may need accessibility permissions to run system commands"
echo ""
echo "📋 To run the app:"
echo "   open 'HiDPI Configurator.app'"
echo ""
echo "🔒 If you get permission errors, you may need to:"
echo "   - Go to System Preferences > Security & Privacy > Privacy > Accessibility"
echo "   - Add 'HiDPI Configurator' to the list of allowed apps"
