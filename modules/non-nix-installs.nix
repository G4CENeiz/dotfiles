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
      if [ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
        echo "SDKMAN already installed"
        exit 0
      fi
      echo "Installing SDKMAN!..."
      curl -s "https://get.sdkman.io" | bash -s -- -s
      if [ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
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


  setupCommands = pkgs.lib.concatStringsSep "\n" [
    "install-vp"
    "install-vp-globals"
    "install-bun-globals"
    "install-uv"
    "install-sdkman"
    "install-herdr"
    "install-herd-lite"
  ];

  runtimeDeps = [
    installBunGlobals
    installVp
    installVpGlobals
    installUv
    installSdkman
    installHerdr
    installHerdLite
  ];

in {
  inherit runtimeDeps setupCommands;
  packages = {
    inherit
      installBunGlobals
      installVp installVpGlobals
      installUv installSdkman
      installHerdr installHerdLite;
  };
}
