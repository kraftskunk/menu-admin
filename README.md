# Menu-Admin
_Streamline your Linux server tasks with a clean, menu script.__

---

## 📖 Introduction

The cloud promised convenience, but at the cost of control—data locked into platforms,
mined for profit, and even used to train models without consent. Self‑hosting takes more
effort, yet it guarantees something the cloud never can: true ownership.

I self‑host to keep my data safe, private, and independent of third‑party policies.
As a photographer, my archives are my livelihood and memory, so I run Linux‑based storage
servers to ensure they remain in my hands. This menu script reflects that
philosophy—streamlining the management of self‑hosted environments while keeping control
where it belongs: with the user.

---

## ✨ Features

- Modular design: easily extend with new commands (=scripts)
- Dynamic discovery of available scripts and functions
- Error handling (`set -euo pipefail`) for reliability
- Simple, text‑based interface for quick navigation
- Lightweight, and no external dependencies beyond Bash

---

## ⚙️ Installation

**Requirements:**
- Linux OS
- Tested on Debian 12
- Bash 4.0+

**Setup:**
1. Clone this repository
2. Make the script executable:
   ```bash
   chmod +x menu.sh
   ```
3. Run it:
   ```
   ./menu.sh
   ```

---

## 🚀 Usage

- Launch the script to see the interactive menu
- Navigate options with keyboard input
- Add your own scripts by dropping them into the `commands` folder

---

## 🔧 Configuration

- Config files live in `lib/`
- Add new menu items by creating scripts in the `commands/` folder
- Each module should follow the same function naming convention for consistency

---

## 🌱 Roadmap

- Add logging and audit features
- Multi‑language support for menus
- Optional TUI (text‑user interface) enhancements
- Integration with system monitoring tools

---

## 📜 License

This project is licensed under the **GNU GENERAL PUBLIC LICENSE Version 3**

---

## 🙏 Acknowledgments

- Inspired by the self‑hosting community
- Thanks to open‑source and Linux
- Built with the philosophy of ownership and independence in mind

---

## 🌍 Why This Matters

For as long as people have been putting services online, there’s been a tension between
**self‑hosting** and relying on the **cloud**. The cloud promised convenience,
scalability, and freedom from hardware maintenance, but it came eventually at the cost of
control.

While it makes collaboration and access easy, it also centralizes power in the hands of
providers who monetize user data, lock customers into ecosystems, and increasingly use
private information to train their models. Self‑hosting, on the other hand, demands more
responsibility but offers something far more valuable: **ownership**.

I choose to self‑host because I want my data to remain mine: safe, private, and accessible
without depending on someone else’s infrastructure or policies. It’s a conscious stand
against the “data grab” culture that treats personal work as raw material for corporate
gain. As a photographer, my archives are not just files; they are years of creative effort
and memory. By self-hosting and running my Debian‑based storage server, I ensure that my
images and projects live on systems I control, with workflows I trust.

This menu script grew out of that philosophy: a tool designed to make managing self‑hosted
environments simpler, more reliable, and more enjoyable.