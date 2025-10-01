#!/usr/bin/env bash
#DESC: Main Admin Menu
set -euo pipefail
IFS=$'\n\t'

COMMANDS_DIR="$(dirname "$0")/commands"

# Show help menu with --help
# --
show_help() {

clear
echo ""
cat <<EOF
Usage:
  ./menu.sh                 # Launch interactive menu
  ./menu.sh <command> [...] # Run command directly with arguments
  ./menu.sh --list          # Show available commands with descriptions
  ./menu.sh --ci            # Run tests, then launch menu
  ./menu.sh --ci-only       # Run tests and exit
  ./menu.sh --help          # Show this help message
echo ""
EOF

}

# List all scripts in commands/
# --
list_commands() {

echo ""
echo "Available commands:"
echo ""
mapfile -t scripts < <(find "$COMMANDS_DIR" -maxdepth 1 -type f -name "*.sh" -exec basename {} \; | sort)
for script in "${scripts[@]}"; do
	desc=$(grep -m1 '^#DESC:' "$COMMANDS_DIR/$script" | sed 's/^#DESC:[[:space:]]*//')
	printf "  %-15s %s\n" "${script%.sh}" "${desc:-}"
	echo ""
done

}

# Run extra options
# --
if [[ $# -gt 0 ]]; then
    case "$1" in

		# Show help
    	# --
        --help) show_help; exit 0 ;;

		# Show all commands
		# --
        --list) list_commands; exit 0 ;;

        # Run test and launch menu
        # --
        --ci)
            echo "🔍 Running CI test suite..."
            if [[ -f "./test.sh" ]]; then
                bash ./test.sh
                echo "✅ CI complete. Launching menu..."
            else
                echo "⚠️  test.sh not found. Skipping tests."
            fi
            ;;
        
        # Run test only
        # --
        --ci-only)
            echo "🔍 Running CI test suite only..."
            if [[ -f "./test.sh" ]]; then
                bash ./test.sh --markdown
                exit 0
            else
                echo "⚠️  test.sh not found. Skipping tests."
                exit 1
            fi
            ;;
        -*)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
        *)
            cmd="$1"
            shift
            script_path="$COMMANDS_DIR/$cmd.sh"
            if [[ -f "$script_path" ]]; then
                bash "$script_path" "$@"
                exit 0
            else
                echo "Command '$cmd' not found."
                exit 1
            fi
            ;;
    esac
fi

# Generate menu with scripts in command/
# --
while true; do
    clear
    echo "======================= Dynamic Menu ======================="
    echo ""
    echo "Available commands:"
    echo ""
    mapfile -t scripts < <(find "$COMMANDS_DIR" -maxdepth 1 -type f -name "*.sh" -exec basename {} \; | sort)
    for i in "${!scripts[@]}"; do
        script_path="$COMMANDS_DIR/${scripts[$i]}"
        desc=$(grep -m1 '^#DESC:' "$script_path" | sed 's/^#DESC:[[:space:]]*//')
        printf "%2d) %-20s %s\n" "$((i+1))" "${scripts[$i]%.sh}" "${desc:-}"
    done
    printf "%2d) Quit\n" "$(( ${#scripts[@]} + 1 ))"
	echo ""
    echo "============================================================"
	echo ""
    read -rp "Select an option: " choice

    if [[ "$choice" -eq $(( ${#scripts[@]} + 1 )) ]]; then
    	clear
    	echo ""
    	echo "============================================================"
        echo ""
        echo "Goodbye!"
        echo ""
        echo "============================================================"
        echo ""
        exit 0
    fi

    if [[ "$choice" =~ ^[0-99]+$ ]] && (( choice >= 1 && choice <= ${#scripts[@]} )); then
        script="${scripts[$((choice-1))]}"
        bash "$COMMANDS_DIR/$script"
        echo ""
        read -rp "Press Enter to return to menu..."
		echo ""
    else
        echo "Invalid choice."
        sleep 1
    fi
done