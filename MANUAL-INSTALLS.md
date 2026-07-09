# Manual Installs

These tools are NOT managed by Nix. Install them yourself.

---

## Nix

Why: Use Determinate Systems installer (better than official).

```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
```

This installs Nix with flakes enabled and proper daemon setup.

---

## Docker

Why: Nix-managed Docker has systemd integration issues.

### Ubuntu/Debian
```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER
```

### Fedora
```bash
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
```

### Arch
```bash
sudo pacman -Sy docker docker-compose
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
```

**Post-install:** Log out and back in for group changes.

---

## VS Code

Why: Extensions marketplace doesn't work with Nix-managed VS Code.

### Ubuntu/Debian
```bash
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt-get update && sudo apt-get install -y code
```

### Fedora
```bash
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf install -y code
```

### Arch
```bash
sudo pacman -Sy code
```

---

## Version Managers

### nvm (Node Version Manager)
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
```

### sdkman (Java/Kotlin)
```bash
curl -s "https://get.sdkman.io" | bash
```

### bun (JavaScript Runtime)
```bash
curl -fsSL https://bun.sh/install | bash
```

### pnpm (Package Manager)
```bash
curl -fsSL https://get.pnpm.io/install.sh | sh -
```

### uv (Python Package Manager)
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

---

## PHP/Laravel

### Herd Lite
```bash
curl -fsSL https://herd.laravel.com/install-linux | bash
```

---

## AI Coding Agents

### Oh My Pi (AI Terminal Agent)
```bash
# Not in nixpkgs
# Install from GitHub:
git clone https://github.com/can1357/oh-my-pi.git
cd oh-my-pi
cargo install --path .
# Or download binary from: https://github.com/can1357/oh-my-pi/releases
```

---

## TUI Apps (not in nixpkgs yet)

### Hunk (Diff Viewer)
```bash
# Not in nixpkgs yet (PR #517626 open)
# Install from GitHub:
cargo install hunk-cli
# Or download binary from: https://github.com/modem-dev/hunk/releases
```

---

## SSH Key Setup

```bash
ssh-keygen -t ed25519 -C "116696555+G4CENeiz@users.noreply.github.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
```

---

## GPG Key Setup (for commit signing)

```bash
gpg --full-generate-key
# Select: ECC (sign only), 256 bits, no expiration

gpg --list-secret-keys --keyid-format=long

git config --global user.signingkey <YOUR_KEY_ID>
git config --global gpg.format ssh

echo "$(git config --get user.email) namespaces=\"git\" $(cat ~/.ssh/id_ed25519.pub)" >> ~/.ssh/allowed_signers
```

---

## Config Files Tracked

These configs are symlinked into place by `link.sh`:

| Config | Source | Destination |
|--------|--------|-------------|
| Nushell | `configs/nushell/` | `~/.config/nushell/` |
| Neovim | `configs/nvim/` | `~/.config/nvim/` |
| Git | `configs/git/.gitconfig` | `~/.gitconfig` |
| Ghostty | `configs/ghostty/config` | `~/.config/ghostty/config` |
| Starship | `configs/starship/starship.toml` | `~/.config/starship.toml` |
| Yazi | `configs/yazi/yazi.toml` | `~/.config/yazi/yazi.toml` |
| Lazygit | `configs/lazygit/config.yml` | `~/.config/lazygit/config.yml` |
| Lazydocker | `configs/lazydocker/config.yml` | `~/.config/lazydocker/config.yml` |
| Btop | `configs/btop/btop.conf` | `~/.config/btop/btop.conf` |
| Bat | `configs/bat/config` | `~/.config/bat/config` |
| Fzf | `configs/fzf/fzfrc` | `~/.config/fzf/fzfrc` |
| Herdr | `configs/herdr/config.toml` | `~/.config/herdr/config.toml` |
| jj | `configs/jj/config.toml` | `~/.config/jj/config.toml` |
| jjui | `configs/jjui/config.toml` | `~/.config/jjui/config.toml` |
