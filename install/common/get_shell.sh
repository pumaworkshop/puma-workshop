#!/bin/bash

shell_profile() {
  SHELL_PROFILE=""
  case "$SHELL" in
    *bash*)
        SHELL_PROFILE="$HOME/.bash_profile"
        if [ ! -f "$SHELL_PROFILE" ]; then
            SHELL_PROFILE="$HOME/.bashrc"
        fi
        ;;
    *zsh*)
        SHELL_PROFILE="$HOME/.zshrc"
        ;;
    *ksh*)
        SHELL_PROFILE="$HOME/.kshrc"
        ;;
    *fish*)
        SHELL_PROFILE="$HOME/.config/fish/config.fish"
        ;;
    *dash*)
        SHELL_PROFILE="$HOME/.profile"
        ;;
    *sh*)
        SHELL_PROFILE="$HOME/.profile"
        ;;
    *)
        echo "Unsupported shell: $CURRENT_SHELL"
        exit 1
        ;;
esac
echo "$SHELL_PROFILE"
}