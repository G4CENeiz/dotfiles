{ pkgs, bunGlobals, vpGlobals }:

let
  installBunGlobals = pkgs.writeShellApplication {
    name = "install-bun-globals";
    runtimeInputs = [ pkgs.bash ];
    text = ''
      BUN="''${BUN_INSTALL:-$HOME/.bun}/bin/bun"
      # Also check vp global bin
      if [ ! -x "$BUN" ] && [ -x "$HOME/.vite-plus/bin/bun" ]; then
        BUN="$HOME/.vite-plus/bin/bun"
      fi
      if [ ! -x "$BUN" ]; then
        echo "✗ bun not found — skipping globals"
        exit 0
      fi
      echo "Installing bun globals..."
      ${pkgs.lib.concatMapStringsSep "\n" (pkg: ''
        echo "  ${pkg}"
        "$BUN" install -g "${pkg}"
      '') bunGlobals}
      echo "✓ bun globals installed"
    '';
  };

  installVp = pkgs.writeShellApplication {
    name = "install-vp";
    runtimeInputs = with pkgs; [ curl bash ];
    text = ''
      set -euo pipefail
      if [ -x "$HOME/.vite-plus/bin/vp" ]; then
        echo "vite-plus already installed"
        exit 0
      fi
      echo "Installing vite-plus..."
      curl -fsSL https://vite.plus | bash
      if [ -x "$HOME/.vite-plus/bin/vp" ]; then
        echo "✓ vite-plus installed"
      else
        echo "✗ vite-plus installation failed"
        exit 1
      fi
    '';
  };

  installVpGlobals = pkgs.writeShellApplication {
    name = "install-vp-globals";
    runtimeInputs = [ pkgs.bash ];
    text = ''
      set -euo pipefail
      VP="$HOME/.vite-plus/bin/vp"
      if [ ! -x "$VP" ]; then
        echo "✗ vite-plus not found — skipping globals"
        exit 0
      fi
      echo "Installing vite-plus globals..."
      ${pkgs.lib.concatMapStringsSep "\n" (pkg: ''
        echo "  ${pkg}"
        "$VP" install -g "${pkg}"
      '') vpGlobals}
      echo "✓ vite-plus globals installed"
    '';
  };

  installUv = pkgs.writeShellApplication {
    name = "install-uv";
    runtimeInputs = with pkgs; [ curl bash gawk ];
    text = ''
      set -euo pipefail
      if command -v uv &>/dev/null; then
        echo "uv already installed: $(uv --version)"
        exit 0
      fi
      echo "Installing uv..."
      curl -LsSf https://astral.sh/uv/install.sh | bash
      if command -v uv &>/dev/null; then
        echo "✓ uv $(uv --version) installed"
      else
        echo "✗ uv installation failed"
        exit 1
      fi
    '';
  };

  installSdkman = pkgs.writeShellApplication {
    name = "install-sdkman";
    runtimeInputs = with pkgs; [ curl bash ];
    text = ''
      set -euo pipefail
      SDKMAN_DIR="$HOME/.sdkman"
      SDK_INIT="$SDKMAN_DIR/bin/sdkman-init.sh"
      CANDIDATES_DIR="$SDKMAN_DIR/candidates"

      # Check if SDKMAN is installed with meaningful content
      if [ -f "$SDK_INIT" ] && [ -d "$CANDIDATES_DIR" ]; then
        INSTALLED=$(find "$CANDIDATES_DIR" -mindepth 2 -maxdepth 2 -type d 2>/dev/null | head -1)
        if [ -n "$INSTALLED" ]; then
          echo "SDKMAN installed with packages — skipping"
          exit 0
        fi
        echo "SDKMAN installed but empty — reinstalling..."
      fi

      # Remove if exists
      [ -d "$SDKMAN_DIR" ] && rm -rf "$SDKMAN_DIR"

      # SDKMAN installer fails on read-only .bashrc symlink
      # Temporarily replace with a copy, then restore
      BASHRC_BAK=""
      if [ -L "$HOME/.bashrc" ]; then
        BASHRC_BAK="$(readlink -f "$HOME/.bashrc")"
        rm "$HOME/.bashrc"
        cp "$BASHRC_BAK" "$HOME/.bashrc" 2>/dev/null || echo "# .bashrc" > "$HOME/.bashrc"
      fi

      echo "Installing SDKMAN!..."
      curl -s "https://get.sdkman.io" | bash -s -- -s

      # Restore symlink
      if [ -n "$BASHRC_BAK" ]; then
        rm -f "$HOME/.bashrc"
        ln -s "$BASHRC_BAK" "$HOME/.bashrc"
      fi

      if [ -f "$SDK_INIT" ]; then
        echo "✓ SDKMAN installed"
      else
        echo "✗ SDKMAN installation failed"
        exit 1
      fi
    '';
  };
  installHerdr = pkgs.writeShellApplication {
    name = "install-herdr";
    runtimeInputs = with pkgs; [ curl bash gawk ];
    text = ''
      set -euo pipefail
      if command -v herdr &>/dev/null; then
        echo "herdr already installed"
        exit 0
      fi
      echo "Installing herdr..."
      curl -fsSL https://herdr.dev/install | bash
      if command -v herdr &>/dev/null; then
        echo "✓ herdr installed"
      else
        echo "✗ herdr installation failed"
        exit 1
      fi
    '';
  };

  installHerdLite = pkgs.writeShellApplication {
    name = "install-herd-lite";
    runtimeInputs = with pkgs; [ curl bash gawk ];
    text = ''
      set -euo pipefail
      if [ -x "$HOME/.config/herd-lite/bin/php" ]; then
        echo "herd-lite already installed"
      fi
      HERD_DIR="$HOME/.config/herd-lite/bin"
      mkdir -p "$HERD_DIR"
      # Pre-add to PATH so installer skips bashrc modification
      export PATH="$HERD_DIR:$PATH"
      echo "Installing herd-lite..."
      curl -fsSL https://php.new/install/linux | bash
      if [ -x "$HERD_DIR/php" ]; then
        echo "✓ herd-lite installed"
      else
        echo "✗ herd-lite installation failed"
        exit 1
      fi
    '';
  };

  installZen = pkgs.writeShellApplication {
    name = "install-zen";
    runtimeInputs = with pkgs; [ curl bash ];
    text = ''
      set -euo pipefail

      # Skip on WSL — no native GPU for Zen's rendering
      if grep -qi microsoft /proc/version 2>/dev/null; then
        echo "WSL detected — skipping zen-browser install"
        exit 0
      fi

      ZEN_DIR="$HOME/.tarball-installations/zen"
      if [ -x "$ZEN_DIR/zen" ]; then
        echo "zen-browser already installed"
        exit 0
      fi

      echo "Installing Zen Browser..."
      curl -fsSL https://github.com/zen-browser/updates-server/raw/refs/heads/main/install.sh | bash
      if [ -x "$ZEN_DIR/zen" ]; then
        echo "✓ zen-browser installed"
      else
        echo "✗ zen-browser installation failed"
        exit 1
      fi
    '';
  };

  installDms = pkgs.writeShellApplication {
    name = "install-dms";
    runtimeInputs = with pkgs; [ curl bash gnugrep ];
    text = ''
      set -euo pipefail

      # Skip on WSL
      if grep -qi microsoft /proc/version 2>/dev/null; then
        echo "WSL detected — skipping DankMaterialShell install"
        exit 0
      fi

      # Check if already installed
      if command -v dms &>/dev/null; then
        echo "dms already installed: $(dms --version 2>/dev/null || echo 'unknown version')"
        exit 0
      fi

      echo "Installing DankMaterialShell with niri + ghostty..."
      sudo -v && curl -fsSL https://install.danklinux.com | sh -s -- -c niri -t ghostty -y

      if command -v dms &>/dev/null; then
        echo "✓ DankMaterialShell installed (niri, ghostty, quickshell)"
      else
        echo "✗ DankMaterialShell installation failed"
        exit 1
      fi
    '';
  };
  setupCommands = pkgs.lib.concatStringsSep "\n" [
    "install-vp"
    "install-vp-globals"
    "install-bun-globals"
    "install-uv"
    "install-sdkman"
    "install-herdr"
    "install-herd-lite"
    "install-zen"
    "install-dms"
  ];

  runtimeDeps = [
    installBunGlobals
    installVp
    installVpGlobals
    installUv
    installSdkman
    installHerdr
    installHerdLite
    installZen
    installDms
  ];

in {
  inherit runtimeDeps setupCommands;
  packages = {
    inherit
      installBunGlobals
      installVp installVpGlobals
      installUv installSdkman
      installHerdr installHerdLite
      installZen installDms;
  };
}
