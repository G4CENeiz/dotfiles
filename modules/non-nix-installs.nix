{ pkgs, bunGlobals, vpGlobals }:

let
  installBun = pkgs.writeShellApplication {
    name = "install-bun";
    runtimeInputs = with pkgs; [ curl bash ];
    text = ''
      set -euo pipefail
      BUN_HOME="''${BUN_INSTALL:-$HOME/.bun}"
      BUN_BIN="$BUN_HOME/bin/bun"
      if [ -x "$BUN_BIN" ]; then
        echo "bun already installed: $(''$BUN_BIN --version)"
        exit 0
      fi
      echo "Installing bun..."
      curl -fsSL https://bun.sh/install | bash
      if [ -x "$BUN_BIN" ]; then
        echo "✓ bun $(''$BUN_BIN --version) installed"
      else
        echo "✗ bun installation failed"
        exit 1
      fi
    '';
  };

  installBunGlobals = pkgs.writeShellApplication {
    name = "install-bun-globals";
    runtimeInputs = [ pkgs.bash ];
    text = ''
      set -euo pipefail
      BUN="''${BUN_INSTALL:-$HOME/.bun}/bin/bun"
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
      curl -s "https://get.sdkman.io" | bash
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
    runtimeInputs = with pkgs; [ curl bash ];
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
    runtimeInputs = with pkgs; [ curl bash ];
    text = ''
      set -euo pipefail
      if command -v herd &>/dev/null; then
        echo "herd-lite already installed"
        exit 0
      fi
      echo "Installing herd-lite..."
      curl -fsSL https://php.new/install/linux | bash
      if command -v herd &>/dev/null; then
        echo "✓ herd-lite installed"
      else
        echo "✗ herd-lite installation failed"
        exit 1
      fi
    '';
  };

  installPnpm = pkgs.writeShellApplication {
    name = "install-pnpm";
    runtimeInputs = with pkgs; [ curl bash gcc.cc.lib ];
    text = ''
      set -euo pipefail
      if command -v pnpm &>/dev/null; then
        echo "pnpm already installed: $(pnpm --version)"
        exit 0
      fi
      echo "Installing pnpm..."
      curl -fsSL https://get.pnpm.io/install.sh | bash
      if command -v pnpm &>/dev/null; then
        echo "✓ pnpm $(pnpm --version) installed"
      else
        echo "✗ pnpm installation failed"
        exit 1
      fi
    '';
  };

  setupCommands = pkgs.lib.concatStringsSep "\n" [
    "install-bun"
    "install-bun-globals"
    "install-vp"
    "install-vp-globals"
    "install-uv"
    "install-pnpm"
    "install-sdkman"
    "install-herdr"
    "install-herd-lite"
  ];

  runtimeDeps = [
    installBun
    installBunGlobals
    installVp
    installVpGlobals
    installUv
    installPnpm
    installSdkman
    installHerdr
    installHerdLite
  ];

in {
  inherit runtimeDeps setupCommands;
  packages = {
    inherit
      installBun installBunGlobals
      installVp installVpGlobals
      installUv installPnpm installSdkman
      installHerdr installHerdLite;
  };
}
