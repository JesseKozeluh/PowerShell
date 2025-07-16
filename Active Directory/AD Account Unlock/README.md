# AD Account Unlock Tool v3.0

A GUI-based PowerShell utility to scan for locked-out Active Directory user accounts and unlock them interactively. Designed for sysadmins who want a fast, user-friendly interface for managing account lockouts without diving into complex scripts.

---

## Author

**Jesse Kozeluh**  
📅 Created: 6 August 2024  
🔧 Version: 3.0

---

## Features

- Displays a Windows Forms GUI to list currently locked-out AD users
- Allows multiple account selection and bulk unlocking
- Includes cancel and refresh buttons for control and visibility
- Uses custom icon branding via embedded Base64 icon string
- Automatically updates the list after unlocking accounts

---

## Requirements

- PowerShell 5.1+
- Active Directory module (`Search-ADAccount`, `Unlock-ADAccount`)
- Windows OS with GUI capabilities (`System.Windows.Forms`)
- Administrator or delegated rights to unlock AD user accounts
- Optional: A valid Base64-encoded `.ico` file string for UI branding

---

## Installation Instructions

To delegate unlock permissions to a non-domain admin user:

1. **Install RSAT** on the client machine:  
   Download and install `WindowsTH-KB2693643-x64.msu` for Remote Server Administration Tools (RSAT)

2. **Open Active Directory Users and Computers**

3. Navigate to the organizational unit (OU) — e.g., `Users`

4. **Right-click the OU**, then select `Delegate Control...`

5. Add the required user and click **Next**

6. Select `Create a custom task to delegate` and click **Next**

7. Choose `Only the following objects in the folder`  
   - Tick `User objects`, then click **Next**

8. Select `Property-specific`  
   - Tick **Read lockoutTime** and **Write lockoutTime**, then click **Next** to confirm

This ensures the user can query and modify lockout status without full admin rights.

---

## Usage

1. Run the script in a PowerShell session with AD access
2. A GUI window will open showing currently locked-out accounts
3. Select one or more accounts from the list
4. Click **Unlock** to unlock all selected accounts
5. Click **Refresh** to re-scan for new lockouts
6. Click **Cancel** to exit the tool

Terminal output confirms each account unlocked, showing both display name and SamAccountName.

---

## [OPTIONAL]
Use PS2EXE to package this as an executable.

---

## Customization

To personalize the icon used in the GUI header:

```powershell
$iconBase64 = "<your_encoded_icon_string_here>"
