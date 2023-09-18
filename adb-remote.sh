set -x
adb disconnect
adb connect 192.168.2.134:3000
adb devices -l
