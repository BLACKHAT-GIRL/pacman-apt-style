#!/bin/bash
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
