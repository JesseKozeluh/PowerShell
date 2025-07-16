# Network Share Folder Permission Report v1.0

Generates an Excel-based report detailing NTFS permissions across multiple network-shared folders and their subdirectories. Designed to assist system administrators in auditing access control for shared storage.

---

## Author

**Jesse Kozeluh**  
📅 Created: 16 July 2025

---

## Features

- Prompts user to select a save location via a Windows Explorer dialog
- Accepts a list of predefined folder paths for audit
- Captures:
  - Timestamp of scan
  - Folder path
  - Identity reference (user or group)
  - File system rights
  - Inheritance status
- Exports each path’s data to a dedicated Excel worksheet
- Logs ACL errors without interrupting workflow

---

## Requirements

- **PowerShell 5.1+**
- **ImportExcel module** installed (used for `Export-Excel`)
- Access permissions to the target folder paths
- Windows environment (for GUI SaveFileDialog functionality)

---

## Usage

1. Run the script directly in PowerShell
2. When prompted, choose a destination and filename for the Excel output
3. Script will iterate through all listed folders and their immediate subdirectories
4. Results saved in `.xlsx` format with one sheet per folder

---

## Customization

To audit different folders, modify the `$folderpath` array in the script:

```powershell
$folderpath = @(
    "\\FILESERVER\Share1",
    "\\FILESERVER\Share2",
    "\\FILESERVER\Share3"
)
