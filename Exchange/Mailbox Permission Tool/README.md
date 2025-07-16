# 📬 Mailbox Access Manager (Exchange GUI Tool)

An interactive PowerShell GUI that connects to Exchange via remote PowerShell and grants mailbox permissions to specified users.  
Useful for administrators who manage shared mailboxes across organizations and want a controlled, visual interface for access delegation.

---

## ⚙️ Features

- Connects to Microsoft Exchange via remote PowerShell session (`Kerberos`)
- Dropdown menu to select from a predefined list of shared mailboxes
- Text field to input a user's `SAMAccountName`
- GUI buttons for:
  - Connect / Disconnect Exchange session
  - Grant `FullAccess` mailbox rights
  - Grant `Send As` permission via `Add-ADPermission`
- Uses `System.Windows.Forms` to create a lightweight and responsive window

---

## 🧰 Requirements

- PowerShell 5.1+
- Microsoft Exchange Management Shell access via remote PowerShell
- Kerberos authentication enabled for `$connectionURI`
- Exchange permissions to run:
  - `Add-MailboxPermission`
  - `Add-ADPermission`
- GUI-capable Windows environment (.NET and WinForms)

---

## 🛠️ Setup

1. Replace the following placeholder URI with your Exchange endpoint:

   ```powershell
   $connectionURI = "http://mail.server.com/PowerShell/"

2. Replace the following placeholder mailboxes with your desired mailboxes:

   ```powershell
   $$sharedMailboxes = @(
    "mailbox1@email.com",

---

## Optional
Use PS2EXE to package this as an executable.
