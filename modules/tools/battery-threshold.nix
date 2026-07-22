# modules/tools/battery-threshold.nix
# Battery charge limit — caps charge at a configurable percentage.
#
# Architecture:
#   1. home.nix installs ~/.local/bin/set-battery-threshold (plain script)
#   2. setup-battery-sudoers grants NOPASSWD for that stable path
#   3. The script reads config and writes to sysfs via sudo
#
# After `nix run .`, just run `set-battery-threshold` anytime to re-apply.
{ pkgs }:

let
  threshold = 80; # ← change this to your preferred percentage

  # Plain shell script (no derivation wrapper) — home.file installs it directly
  script = pkgs.writeShellScript "set-battery-threshold" ''
    set -euo pipefail

    THRESHOLD="${toString threshold}"
    BAT="/sys/class/power_supply/BAT0/charge_control_end_threshold"

    if [ ! -f "$BAT" ]; then
      echo "⚠  No battery charge control found at $BAT"
      echo "   Your hardware may not support charge thresholds."
      exit 0
    fi

    current=$(cat "$BAT")
    if [ "$current" = "$THRESHOLD" ]; then
      echo "✓  Battery threshold already set to $THRESHOLD%"
      exit 0
    fi

    echo "$THRESHOLD" | sudo tee "$BAT" > /dev/null
    echo "✓  Battery charge limit set to $THRESHOLD%"
  '';

  # One-time sudoers setup — grants NOPASSWD for the stable ~/.local/bin path
  setupSudoers = pkgs.writeShellApplication {
    name = "setup-battery-sudoers";
    runtimeInputs = with pkgs; [ bash ];
    text = ''
      set -euo pipefail

      SCRIPT="$HOME/.local/bin/set-battery-threshold"
      SUDOERS_FILE="/etc/sudoers.d/battery-threshold"
      ENTRY="$(whoami) ALL=(ALL) NOPASSWD: $SCRIPT"

      if [ ! -x "$SCRIPT" ]; then
        echo "⚠  $SCRIPT not found — run home-manager switch first"
        exit 1
      fi

      if [ -f "$SUDOERS_FILE" ] && grep -qF "$ENTRY" "$SUDOERS_FILE" 2>/dev/null; then
        echo "✓  Sudoers already configured for battery threshold"
        exit 0
      fi

      echo "Setting up passwordless sudo for battery threshold..."
      echo "$ENTRY" | sudo tee "$SUDOERS_FILE" > /dev/null
      sudo chmod 440 "$SUDOERS_FILE"
      echo "✓  Sudoers configured"
    '';
  };

in {
  inherit script setupSudoers;
  inherit threshold;

  packages = {
    inherit setupSudoers;
  };
}
