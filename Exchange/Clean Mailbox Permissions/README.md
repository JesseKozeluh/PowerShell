# 📬 Clean Shared Mailbox Permissions v1.0

Automates the auditing and cleanup of **Send As** and **Full Access** permissions for a specified **mailboxes** in Microsoft Exchange. It identifies disabled users with legacy permissions and optionally removes them. There are two versions, one written for Exchange Server 2019 and the other for Exchange Online.

---

## 👤 Author

**Jesse Kozeluh**  
📅 Created: 16 July 2025

---

## 🧰 Script Overview

This PowerShell script performs the following actions:

- Written for shared mailboxes, but can be used for user mailboxes (doesn't handle Send-On-Behalf perms)
- Prompts for a mailbox email address
- Retrieves the mailbox’s Distinguished Name
- Audits **Send-As** permissions via `Get-ADPermission`
- Audits **Full Access** permissions via `Get-MailboxPermission`
- Identifies users that are **disabled in AD** but still retain permissions
- Offers interactive removal of invalid permissions

---

## ⚙️ Requirements

- PowerShell with access to:
  - Exchange Management Shell
  - Active Directory module
- Exchange URI for remote PowerShell connection
- Appropriate administrative privileges

---

## 🔐 Authentication

Replace the placeholder URI in the script:

```powershell
$connectionURI = "http://mail.server.com/PowerShell/"
