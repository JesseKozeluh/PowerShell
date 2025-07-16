# Zoom Application Cleanup Script

Removes all user-specific installations and registry remnants of Zoom from a Windows machine.  
Designed for administrators seeking full Zoom removal across multiple user profiles — including residual registry keys and AppData folders.

---

## Author

**Jesse Kozeluh**  
📅 Created: 16 July 2025  
🔧 Version: 1.0

---

## Features

- Deletes Zoom folders from each user's AppData (`Roaming`, `Local`, and Start Menu shortcuts)
- Cleans Zoom-related registry entries for:
  - Currently logged-in user
  - Other user profiles on the system
  - `UsrClass.dat` and `NTUSER.dat` hive-loaded registries
- Avoids interruption with silent error handling (`ErrorAction SilentlyContinue`)
- Uses .NET garbage collection to safely unload registry hives

---

## Requirements

- PowerShell 5.1+
- Run as Administrator (required to load/unload registry hives and remove files in protected profiles)
- Windows OS (tested on Windows 10/11)
- Zoom must be installed in user context (this script does not remove system-wide installations via MSI)

---

## Usage

1. Run the script in an elevated PowerShell session
2. The script will automatically:
   - Enumerate all users under `C:\Users`
   - Remove Zoom folders from `AppData\Roaming`, `AppData\Local`, and Start Menu
   - Clean registry entries for the current user (`HKCU`) and load registry hives for other profiles
3. No manual input is required

---

## Notes

- Registry hives are loaded using:
  - `UsrClass.dat` (for HKCU\Software\Classes keys)
  - `NTUSER.dat` (for uninstall keys under `Software`)
- Script uses `reg load` and `reg unload` to access keys under `HKLM\TempHive` and `HKLM\TempUserHive`
- Uses `[gc]::Collect()` to release handles before unloading registry hives
- The base64-encoded icon has been omitted in this version; it may be added for GUI branding in future versions

---

## Limitations

- Does not remove Zoom system-wide MSI installations — use standard uninstaller for those
- Does not scan alternate profile locations (e.g. redirected folders or domain profiles stored elsewhere)
- Assumes local user profiles reside under `C:\Users`

---

## License

Provided as-is for internal administrative use by **Jesse Kozeluh**.  
Feel free to fork, extend, or adapt for other applications such as Teams, Slack, or similar cleanup operations.
