# Flutter App API Connection Guide

## Issue: API Not Working on Physical Device

### Problem:
When running a Flutter app on an **emulator**, the IP `10.0.2.2` maps to `localhost` on your computer. However, for a **physical device**, using `10.0.2.2` won't work. Instead, the phone needs to access the **computer's local network IP**.

### Solution:
To make API calls work on a physical device, follow these steps:

### Step 1: Find Your Computer's Local IP Address
On **Windows**, open **Command Prompt (cmd)** and run:
```sh
ipconfig
```
On **Mac/Linux**, open **Terminal** and run:
```sh
ifconfig  # Or
ip a
```
Look for the **IPv4 Address** under the active Wi-Fi connection (e.g., `192.168.1.100`).

### Step 2: Update API URL in Flutter App
Modify your API URL in Flutter code:
```dart
final String apiUrl = "http://192.168.1.100/on_duty/lib/login.php";
```
Replace `192.168.1.100` with your actual **IPv4 Address**.

### Step 3: Ensure Both Devices Are on the Same Wi-Fi Network
Make sure your **computer** (running the server) and **phone** (running the Flutter app) are connected to the **same Wi-Fi network**.

### Step 4: Allow Incoming Connections on Your Computer
If using **XAMPP, WAMP, or a local PHP server**, you may need to allow external access:
- Disable the **Windows Defender Firewall** (or allow traffic on port 80 or 8000).
- If using `php -S`, run:
  ```sh
  php -S 0.0.0.0:8000
  ```

### Step 5: Forward Ports (For USB Debugging Only)
If testing via **USB (without Wi-Fi)**, you can forward traffic using ADB:
```sh
adb reverse tcp:80 tcp:80
```

### Final Check:
- Run the API URL in a browser on your **phone**: `http://192.168.1.100/on_duty/lib/login.php`.
- If it loads, your phone can reach the server! 🎉

Now, your **Flutter app should work on both emulator and physical devices!** 🚀

