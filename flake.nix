{
  description = "Gace's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      # Change this when switching machines:
      #   x86_64-linux  — Intel/AMD Linux
      #   aarch64-linux — ARM Linux
      #   x86_64-darwin — Intel Mac
      #   aarch64-darwin — Apple Silicon Mac
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # Import package lists (pure lists, no logic)
      bunGlobals = import ./modules/packages/bun-globals.nix;
      vpGlobals = import ./modules/packages/vp-globals.nix;

      # Import modules
      nonNix = import ./modules/non-nix-installs.nix { inherit pkgs bunGlobals vpGlobals; };
      docker = import ./modules/tools/docker.nix { inherit pkgs; };

      homeManagerPackages = home-manager.packages.${system};
    in
    {
      # ── Home Manager config (used by `home-manager switch`) ──
      homeConfigurations."gace" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
        extraSpecialArgs = { dotfiles = ./.; };
      };

      # ── ONE command: `nix run .` does everything ──
      packages.${system} = nonNix.packages // docker.packages // {
        default = pkgs.writeShellApplication {
          name = "dotfiles-setup";
          runtimeInputs = with pkgs; [
            homeManagerPackages.home-manager
            git
            bash
          ] ++ nonNix.runtimeDeps
            ++ docker.runtimeDeps;
          text = ''
            set -euo pipefail
            REPO_DIR="$(pwd)"

            echo "╔══════════════════════════════════╗"
            echo "║   Gace's Dotfiles Setup          ║"
            echo "╚══════════════════════════════════╝"
            echo ""

            # ── Step 1: Home Manager ──
            echo "── [1/2] Home Manager ──"
            cd "$REPO_DIR"
            home-manager switch --flake .#gace
            echo ""

            # ── Step 2: Non-nix tools ──
            echo "── [2/2] Non-nix tools ──"
            ${nonNix.setupCommands}
            ${docker.installCommand}
            echo ""

            echo "╔══════════════════════════════════╗"
            echo "║   Setup complete!                 ║"
            echo "║   Restart your shell.             ║"
            echo "╚══════════════════════════════════╝"
          '';
        };
      };
    };
}
