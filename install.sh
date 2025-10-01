#!/usr/bin/env bash
#DESC: Install script for Admin Menu
set -euo pipefail
IFS=$'\n\t'

clear
echo "🛠️ Admin Menu Framework Installer"
echo "----------------------------"

# --- Load supervision email from common.sh ---
#
# Source default variables
# --
source "./lib/common.sh"

# Show what the actual email address is.
# Ask to keep or to change. Edits are permanent.
# To change, either run this script again or edit in ./lib/common.sh
# --
echo "📧 Supervision email is set to: $SUPERVISION_EMAIL"
read -rp "Use this email for test reports? [Y/n]: " EMAIL_CONFIRM
if [[ "$EMAIL_CONFIRM" =~ ^[Nn]$ ]]; then
    read -rp "Enter new supervision email: " NEW_EMAIL
    SUPERVISION_EMAIL="$NEW_EMAIL"
    echo "✅ Updated supervision email to: $SUPERVISION_EMAIL"

    # Persist change to lib/common.sh
    # --
    sed -i.bak "s|^SUPERVISION_EMAIL=.*|SUPERVISION_EMAIL=\"$SUPERVISION_EMAIL\"|" ./lib/common.sh
    echo "📝 common.sh updated"
fi

# --- Step 1: Choose destination ---
# --
read -rp "📍 Enter installation path (default: ./menu-admin): " DEST
DEST="${DEST:-./menu-admin}"

if [[ -d "$DEST" ]]; then
    echo "⚠️  Destination '$DEST' already exists."
    read -rp "Overwrite existing installation? [y/N]: " OVERWRITE
    if [[ ! "$OVERWRITE" =~ ^[Yy]$ ]]; then
        echo "❌ Installation aborted."
        exit 1
    fi
    rm -rf "$DEST"
fi

# Creating folder structure in destination
# --
mkdir -p "$DEST"/{commands,lib}
echo "✅ Created folder structure at $DEST"

# --- Step 2: Copy core files ---
# --
cp menu.sh "$DEST/"
cp test.sh "$DEST/"
cp lib/common.sh "$DEST/lib/"
echo "📦 Copied menu.sh, test.sh, and common.sh"

# --- Step 3: Create placeholder commands ---
# Adding some default scripts.
# --
for cmd in backup cleanup report; do
    cmd_path="$DEST/commands/$cmd.sh"
    if [[ ! -f "$cmd_path" ]]; then
        cat > "$cmd_path" <<EOF
#!/usr/bin/env bash
#DESC: Placeholder for $cmd command
#TEST: args=; expect=Running $cmd...
source "\$(dirname "\$0")/../lib/common.sh"
log "Running $cmd..."
EOF
        chmod +x "$cmd_path"
        echo "🧩 Created placeholder: $cmd.sh"
    fi
done

# Making scripts executable
# --
chmod +x "$DEST/menu.sh" "$DEST/test.sh"
echo "✅ Made menu.sh and test.sh executable"

# --- Step 4: Optional symlink ---
# Creating a symlink in /usr/local/bin. This will put the menu script in your path
# and allow you to call the script from anywhere with menu.sh
# --
echo ""
echo "🔗 Symlink Setup"
echo "----------------"
read -rp "Create symlink to menu.sh in /usr/local/bin (name: adminmenu)? [y/N]: " LINK
if [[ "$LINK" =~ ^[Yy]$ ]]; then
    sudo ln -sf "$(realpath "$DEST/menu.sh")" /usr/local/bin/adminmenu
    echo "✅ Symlink created: adminmenu → $DEST/menu.sh"
    echo "You can now run it from anywhere with: adminmenu"
fi

# --- Step 5: Optional archive ---
# Create an archive package here
# --
echo ""
echo "📦 Archive Packaging"
echo "--------------------"
read -rp "Create .tar.gz archive of installation? [y/N]: " ARCHIVE
if [[ "$ARCHIVE" =~ ^[Yy]$ ]]; then
    ARCHIVE_NAME="$(basename "$DEST")-$(date +%Y%m%d_%H%M%S).tar.gz"
    tar -czf "$ARCHIVE_NAME" -C "$(dirname "$DEST")" "$(basename "$DEST")"
    echo "✅ Archive created: $ARCHIVE_NAME"
fi

# End of script
echo ""
echo "🎉 Installation complete!"
exit 1