# ⚙️ PowerShell Script Library

A growing collection of PowerShell scripts focused on system administration, network auditing, and Exchange management.

---

## 📁 Directory Structure

- [Active Directory Scripts](https://github.com/JesseKozeluh/PowerShell/tree/main/Active%20Directory)  
  GUI-based and command-line tools for performing administative tasks in AD environments.

- [Exchange Scripts](https://github.com/JesseKozeluh/PowerShell/tree/main/Exchange)  
  Scripts for managing and auditing Microsoft Exchange environments.

- [Misc Scripts](https://github.com/JesseKozeluh/PowerShell/tree/main/Misc)  
  Tools and scripts for general purpose administrative tasks.

- [Network Scripts](https://github.com/JesseKozeluh/PowerShell/tree/main/Network)  
  Tools and scripts for network related administrative tasks.

More directories will be added as additional tooling is developed and tested.

---

## 🧰 Requirements

To run scripts in this repository effectively, ensure your environment includes:

- PowerShell 5.1+
- Administrator privileges (for filesystem and mailbox access)
- [ImportExcel](https://github.com/dfinke/ImportExcel) module installed (used for `.xlsx` exports)
- Access to domain resources such as Active Directory and network file servers
- Exchange Management Shell and AD module (for Exchange scripts)

---

## 📄 Usage

Each script is standalone and can be run directly from PowerShell.  
Some scripts include interactive prompts, graphical save dialogs, or modular input arrays for folder selection.

Refer to the `README.md` files in each subdirectory for usage instructions, requirements, and sample output.

---

## 🛠️ Contributions & Extensions

Ideas and feature expansions are always welcome. Future additions may include:

- Scheduled reporting tasks with built-in logging
- Permissions change tracking and historical comparison
- UI-driven launcher for script selection and preview
- Config file support for scalable audits

Feel free to fork, extend, or open Pull Requests to contribute improvements.

---

## 👨‍💻 Author

Maintained by **Jesse Kozeluh**

If you'd like to report issues, suggest enhancements, or collaborate on broader scripting toolkits, GitHub Issues and Discussions are open.
