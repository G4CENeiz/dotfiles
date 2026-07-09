#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.config-backup/$(date +%Y%m%d-%H%M%S)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ok()   { echo -e "${GREEN}[ok]${NC} $*"; }
warn() { echo -e "${YELLOW}[warn]${NC} $*"; }

# ── Backup existing configs ────────────────────────────────
mkdir -p "$BACKUP_DIR"

backup_config() {
    local src="$HOME/$1"
    if [ -e "$src" ] && [ ! -L "$src" ]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$1")"
        mv "$src" "$BACKUP_DIR/$1"
        ok "Backed up $1"
    elif [ -L "$src" ]; then
        rm "$src"
        ok "Removed symlink $1"
    fi
}

# ── Create symlinks ────────────────────────────────────────
link_config() {
    local src="$DOTFILES_DIR/configs/$1"
    local dest="$HOME/$2"
    mkdir -p "$(dirname "$dest")"
    ln -sf "$src" "$dest"
    ok "Linked $2"
}

echo "=== Linking configs ==="

# Backup
for cfg in .bashrc .profile .zshrc .gitconfig .agents .omp .pi .config/nushell .config/nvim .config/herdr .config/yazi .config/lazygit .config/lazydocker .config/btop .config/bat .config/fzf .config/jj .config/jjui .config/ghostty .config/starship .config/opencode; do
    backup_config "$cfg"
done

# Link - Shell
link_config "bash/.bashrc" ".bashrc"
link_config "bash/.profile" ".profile"
link_config "zsh/.zshrc" ".zshrc"

# Link - Git
link_config "git/.gitconfig" ".gitconfig"

# Link - Agents
link_config "agents" ".agents"
link_config "omp/config.yml" ".omp/agent/config.yml"
link_config "pi/settings.json" ".pi/agent/settings.json"

# Link - Configs
link_config "nushell" ".config/nushell"
link_config "nvim" ".config/nvim"
link_config "ghostty/config" ".config/ghostty/config"
link_config "starship/starship.toml" ".config/starship.toml"
link_config "yazi/yazi.toml" ".config/yazi/yazi.toml"
link_config "lazygit/config.yml" ".config/lazygit/config.yml"
link_config "lazydocker/config.yml" ".config/lazydocker/config.yml"
link_config "btop/btop.conf" ".config/btop/btop.conf"
link_config "bat/config" ".config/bat/config"
link_config "fzf/fzfrc" ".config/fzf/fzfrc"
link_config "herdr/config.toml" ".config/herdr/config.toml"
link_config "jj/config.toml" ".config/jj/config.toml"
link_config "jjui/config.toml" ".config/jjui/config.toml"
link_config "opencode/opencode.json" ".config/opencode/opencode.json"

echo ""
echo -e "${GREEN}Done.${NC} Configs linked."
echo ""
echo "Still need to install manually (see MANUAL-INSTALLS.md):"
command -v docker &>/dev/null || echo "  - Docker"
command -v code &>/dev/null || echo "  - VS Code"
command -v nvm &>/dev/null || echo "  - nvm"
command -v bun &>/dev/null || echo "  - bun"
command -v pnpm &>/dev/null || echo "  - pnpm"
command -v uv &>/dev/null || echo "  - uv"
[ -d "$HOME/.sdkman" ] || echo "  - sdkman"
