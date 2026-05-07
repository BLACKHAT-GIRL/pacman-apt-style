# pacman-apt-style
Simple patch for pacman to facilitate apt-style operation using MSYS2

```bash
grep -q "pacman() {" ~/.bashrc || cat << 'EOF' | expand -t 2 | tee -a ~/.bashrc
pacman() {
  local ARGS=()
  local YES=()

  # Loop to capture and convert -y or --yes into --noconfirm
  for arg in "$@"; do
    case "$arg" in
      -y|--yes) YES=("--noconfirm") ;;
      *) ARGS+=("$arg") ;;
    esac
  done

  case "${ARGS}" in
    search)
      /usr/bin/pacman -Ss "${ARGS[@]:1}"
      ;;
    update)
      /usr/bin/pacman -Syu "${YES[@]}" "${ARGS[@]:1}"
      ;;
    install)
      /usr/bin/pacman -S "${YES[@]}" "${ARGS[@]:1}"
      ;;
    remove)
      /usr/bin/pacman -Rs "${YES[@]}" "${ARGS[@]:1}"
      ;;
    list)
      /usr/bin/pacman -Q "${ARGS[@]:1}"
      ;;
    help|-h|--help)
      echo -e "\e[1;32mUsage (Simplified):\e[0m"
      printf "  pacman %-10s %-20s - %s\n" "search" "<pkg>" "Search for packages"
      printf "  pacman %-10s %-20s - %s\n" "update" "[-y|--yes]" "Update the system"
      printf "  pacman %-10s %-20s - %s\n" "install" "<pkg> [-y]" "Install packages"
      printf "  pacman %-10s %-20s - %s\n" "remove" "<pkg> [-y]" "Remove packages and dependencies"
      printf "  pacman %-10s %-20s - %s\n" "list" "" "List all installed packages"
      printf "  pacman %-10s %-20s - %s\n\n" "help" "" "Show full help manual"
      /usr/bin/pacman --help
      ;;
    "")
      echo -e "\e[1;32mUsage (Simplified):\e[0m"
      printf "  pacman %-10s %s\n" "search" "<pkg>"
      printf "  pacman %-10s %s\n" "update" "[-y|--yes]"
      printf "  pacman %-10s %s\n" "install" "<pkg> [-y|--yes]"
      printf "  pacman %-10s %s\n" "remove" "<pkg> [-y|--yes]"
      printf "  pacman %-10s %s\n" "list" ""
      printf "  pacman %-10s %s\n\n" "help" ""
      /usr/bin/pacman
      ;;
    *)
      /usr/bin/pacman "$@"
      ;;
  esac
}
EOF
source ~/.bashrc
```

Apply the patch to a line (copy and paste)
```bash
export PATCH_URL='https://raw.githubusercontent.com/BLACKHAT-GIRL/pacman-apt-style/refs/heads/main/patch.sh' \
DL=$(command -v curl || command -v wget) \
&& [ -n "$DL" ] && $DL \
$([ "${DL##*/}" = "curl" ] && \
echo "-sSL" || echo "-qO-") "$PATCH_URL" | bash && . ~/.bashrc
```

```console
root@BLACKHAT:~# pacman
Usage (Simplified):
  pacman search     <pkg>
  pacman update     [-y|--yes]
  pacman install    <pkg> [-y|--yes]
  pacman remove     <pkg> [-y|--yes]
  pacman list
  pacman help

error: no operation specified (use -h for help)
root@BLACKHAT:~# pacman --help
Usage (Simplified):
  pacman search     <pkg>                - Search for packages
  pacman update     [-y|--yes]           - Update the system
  pacman install    <pkg> [-y]           - Install packages
  pacman remove     <pkg> [-y]           - Remove packages and dependencies
  pacman list                            - List all installed packages
  pacman help                            - Show full help manual

usage:  pacman <operation> [...]
operations:
    pacman {-h --help}
    pacman {-V --version}
    pacman {-D --database} <options> <package(s)>
    pacman {-F --files}    [options] [file(s)]
    pacman {-Q --query}    [options] [package(s)]
    pacman {-R --remove}   [options] <package(s)>
    pacman {-S --sync}     [options] [package(s)]
    pacman {-T --deptest}  [options] [package(s)]
    pacman {-U --upgrade}  [options] <file(s)>

use 'pacman {-h --help}' with an operation for available options
root@BLACKHAT:~#
```
