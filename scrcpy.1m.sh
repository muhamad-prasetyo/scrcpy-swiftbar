#!/bin/zsh
# <swiftbar.title>📱 scrcpy</swiftbar.title>
# <swiftbar.refreshOnClick>true</swiftbar.refreshOnClick>
# <swiftbar.runInTerminal>true</swiftbar.runInTerminal>
# <swiftbar.hideTerminal>false</swiftbar.hideTerminal>
# <swiftbar.refreshInterval>300</swiftbar.refreshInterval>

# Fungsi ambil info device (IP & model)
get_device_info() {
  if [[ -f ~/.scrcpy_last_ip ]]; then
    IP=$(cat ~/.scrcpy_last_ip)
    MODEL=$(adb -s $IP:5555 shell getprop ro.product.model | tr -d '\r')
    echo "$MODEL@$IP"
  else
    echo "No device"
  fi
}

# Cek koneksi device
if adb devices | grep -w "device" > /dev/null || [[ -f ~/.scrcpy_last_ip ]]; then
  DEVICE_INFO=$(get_device_info)
  echo "📱 $DEVICE_INFO"
else
  echo "⚠️ No device"
fi

echo "---"
echo "Connect Wireless & Launch | bash='$0' param1=run terminal=true"
echo "Reconnect Last Device | bash='$0' param1=reconnect terminal=true"
echo "Reset ADB & Forget IP | bash='$0' param1=reset terminal=true"
echo "---"
echo "About - by MUHAMAD PRASETYO | bash='open' param1='https://github.com/muhamad-prasetyo'terminal=false"


# Fungsi koneksi & jalankan scrcpy via WiFi
auto_scrcpy() {
  adb kill-server
  adb start-server
  sleep 1

  if adb devices | grep -w "device" > /dev/null; then
    adb tcpip 5555
    sleep 1
    IP=$(adb shell ip -f inet addr show | grep inet | grep -v '127.0.0.1' | awk '{print $2}' | cut -d/ -f1 | head -n1)

    if [[ -n "$IP" ]]; then
      echo "$IP" > ~/.scrcpy_last_ip
      adb connect "$IP:5555" > /dev/null
      osascript -e 'display notification "scrcpy berhasil dijalankan via WiFi." with title "scrcpy"'
      afplay /System/Library/Sounds/Glass.aiff
      adb disconnect # ⛔ auto disconnect USB
      scrcpy -s "$IP:5555"
    else
      osascript -e 'display notification "Gagal mendapatkan IP dari device." with title "scrcpy"'
    fi
  else
    osascript -e 'display notification "Device USB tidak terdeteksi atau belum authorize." with title "scrcpy"'
  fi
}

# Fungsi reconnect ke device sebelumnya
reconnect_scrcpy() {
  if [[ -f ~/.scrcpy_last_ip ]]; then
    IP=$(cat ~/.scrcpy_last_ip)
    if ping -c 1 -W 1 "$IP" >/dev/null; then
      adb connect "$IP:5555" > /dev/null
      osascript -e "display notification \"Reconnect ke $IP\" with title \"scrcpy\""
      afplay /System/Library/Sounds/Glass.aiff
      scrcpy -s "$IP:5555"
    else
      osascript -e "display notification \"Gagal reconnect. Device offline.\" with title \"scrcpy\""
    fi
  else
    osascript -e 'display notification "Tidak ada IP tersimpan sebelumnya." with title "scrcpy"'
  fi
}

# Fungsi reset semuanya
reset_all() {
  adb kill-server
  rm -f ~/.scrcpy_last_ip
  osascript -e 'display notification "ADB dimatikan & IP terakhir dihapus." with title "scrcpy"'
}

# Jalankan berdasarkan argumen SwiftBar
case "$1" in
  run)
    auto_scrcpy
    ;;
  reconnect)
    reconnect_scrcpy
    ;;
  reset)
    reset_all
    ;;
esac

