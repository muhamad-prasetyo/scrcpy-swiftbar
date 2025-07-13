#!/bin/bash

PLUGIN_DIR="$HOME/Documents/SwiftBarPlugins"
PLUGIN_FILE="scrcpy.1m.sh"

# Cek dan buat folder plugin jika belum ada
mkdir -p "$PLUGIN_DIR"

# Salin plugin ke folder
cp "./$PLUGIN_FILE" "$PLUGIN_DIR/$PLUGIN_FILE"
chmod +x "$PLUGIN_DIR/$PLUGIN_FILE"

# Install scrcpy jika belum ada
if ! command -v scrcpy >/dev/null 2>&1; then
  echo "🔧 Menginstall scrcpy..."
  brew install scrcpy
fi

# Install adb jika belum ada
if ! command -v adb >/dev/null 2>&1; then
  echo "🔧 Menginstall adb..."
  brew install android-platform-tools
fi

# Buka SwiftBar
echo "🚀 Membuka SwiftBar..."
open -a SwiftBar

echo "✅ Plugin scrcpy untuk SwiftBar telah terpasang!"
