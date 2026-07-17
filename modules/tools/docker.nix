# modules/tools/docker.nix
# Docker — handles WSL2 Docker Desktop, bare metal, and macOS warnings.
{ pkgs }:

let
  installer = pkgs.writeShellApplication {
    name = "install-docker";
    runtimeInputs = with pkgs; [ curl bash gnugrep ];
    text = ''
      set -euo pipefail

      # ── macOS: skip with warning ──
      if [ "$(uname -s)" = "Darwin" ]; then
        echo "WARNING: Docker module is Linux-only."
        echo "Install Docker Desktop for Mac from:"
        echo "  https://docs.docker.com/desktop/install/mac-install/"
        exit 0
      fi

      # ── WSL2 + Docker Desktop? ──
      if grep -qi microsoft /proc/version 2>/dev/null; then
        if command -v docker &>/dev/null && docker info --format '{{.OperatingSystem}}' 2>/dev/null | grep -qi docker; then
          echo "Docker Desktop running on WSL2: $(docker --version)"
          exit 0
        fi
        echo "WSL2 detected but Docker Desktop not running."
        echo ""
        echo "Install Docker Desktop from:"
        echo "  https://docs.docker.com/desktop/install/windows-install/"
        echo ""
        echo "Then enable WSL2 integration in:"
        echo "  Docker Desktop → Settings → Resources → WSL Integration"
        exit 0
      fi

      # ── Bare metal: already installed? ──
      if command -v docker &>/dev/null; then
        echo "Docker found: $(docker --version)"
        if docker info &>/dev/null; then
          echo "Docker daemon running."
          exit 0
        fi
        echo "Docker daemon NOT running. Starting..."
        sudo systemctl start docker
        sudo systemctl enable docker
        echo "✓ Docker daemon started"
        exit 0
      fi

      # ── Bare metal: fresh install ──
      echo "Installing Docker..."
      curl -fsSL https://get.docker.com | sudo bash

      echo ""
      echo "Adding $USER to docker group..."
      sudo usermod -aG docker "$USER"

      echo ""
      echo "Starting Docker daemon..."
      sudo systemctl start docker
      sudo systemctl enable docker

      echo ""
      echo "✓ Docker installed and running"
      echo "  $(docker --version)"
      echo ""
      echo "IMPORTANT: Run 'newgrp docker' or re-login"
      echo "for group changes to take effect."
    '';
  };

  installCommand = "install-docker";
  runtimeDeps = [ installer ];
in
{
  inherit installCommand runtimeDeps;
  packages.install-docker = installer;
}
