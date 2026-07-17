# Gace's Dotfiles

Declarative environment setup using Nix Flakes + Home Manager.

## What's Managed

**Nix packages** (from nixpkgs):
git, curl, wget, gnupg, unzip, tar, ripgrep, fd, fzf, bat, jq, yq, eza, delta, tree,
htop, btop, jujutsu, jjui, lazygit, lazydocker, lazysql, bash, bash-completion, nushell,
carapace, starship, zoxide, direnv, ffmpeg, imagemagick, yt-dlp, yazi, httpie, hurl,
kubectl, kubernetes-helm, k9s, typst, tinymist

**Non-nix tools** (installed via official scripts):
bun, vite-plus, uv, pnpm, SDKMAN, herdr, herd-lite, docker

**Config files** (symlinked to system paths):
- `~/.config/nushell/config.nu` → `config/.config/nushell/config.nu`
- `~/.config/nushell/env.nu` → `config/.config/nushell/env.nu`
- `~/.config/herdr/` → `config/.config/herdr/`
- `~/.agents/` → `agents/`

**Programs configured** (via Home Manager):
- git (with delta as diff tool, aliases)
- bash (with zoxide, carapace)
- nushell (with carapace)
- starship prompt
- zoxide
- direnv

**Not managed** (install manually):
VS Code, Neovim, Ghostty, code editors

## Quick Start

```bash
# 1. Install Nix via Determinate Systems (one-time)
#    Flakes enabled by default, no manual config needed
curl -fsSL https://install.determinate.systems/nix | sh -s -- install

# 2. Restart your shell (or run: source ~/.bashrc)

# 3. Clone and run
git clone https://github.com/G4CENeiz/dotfiles ~/dotfiles
cd ~/dotfiles

# 4. Set your username (edit home.nix lines 11-12)
#    Change "gace" to your Linux username
sed -i 's/home.username = "gace"/home.username = "YOUR_USERNAME"/' home.nix
sed -i 's|home.homeDirectory = "/home/gace"|home.homeDirectory = "/home/YOUR_USERNAME"|' home.nix

# 5. Apply
nix run .
```

**Important:** You MUST change the username in `home.nix` before running `nix run .`. Nix flakes don't have access to environment variables during evaluation, so the username can't be auto-detected.

## Updating

### Update all pinned inputs (nixpkgs, home-manager)
```bash
cd ~/dotfiles
nix flake update
nix run .
```

### Update just nixpkgs (not home-manager)
```bash
nix flake lock --update-input nixpkgs
nix run .
```

### See what would change before updating
```bash
nix flake update --dry-run
```

### Update non-nix tools individually
```bash
bun upgrade
uv self update
pnpm update
```

## Reinstalling Individual Tools

If something breaks, reinstall just that tool:
```bash
nix run .#install-bun
nix run .#install-docker
nix run .#install-uv
nix run .#install-pnpm
```

## Repository Structure

```
~/dotfiles/
├── flake.nix                    # Entry point
├── flake.lock                   # Pinned versions
├── home.nix                     # Home Manager config
├── README.md
├── config/
│   ├── home/
│   │   ├── .bashrc
│   │   ├── .profile
│   │   ├── .gitconfig
│   │   └── .bash_logout
│   └── .config/
│       ├── nushell/
│       │   ├── config.nu
│       │   └── env.nu
│       └── herdr/
│           └── config.toml
├── agents/
│   ├── .skill-lock.json
│   └── skills/
│       ├── find-skills/
│       ├── grill-me/
│       ├── grill-with-docs/
│       └── grilling/
└── modules/
    ├── non-nix-installs.nix     # Catalog of non-nix tools
    ├── packages/
    │   ├── bun-globals.nix
    │   └── vp-globals.nix
    ├── shell/
    │   └── bash.nix
    └── tools/
        └── docker.nix
```

## Git Signing with SSH (Recommended)

SSH signing is simpler than GPG and works with GitHub out of the box.

### Generate an SSH key for signing
```bash
ssh-keygen -t ed25519 -C "your-email@example.com" -f ~/.ssh/git_signing_key
```

### Configure git to use it
```bash
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/git_signing_key.pub
git config --global commit.gpgSign true
git config --global tag.gpgSign true
```

### Add the public key to GitHub
1. Copy the public key: `cat ~/.ssh/git_signing_key.pub`
2. Go to GitHub → Settings → SSH and GPG keys → New SSH key
3. Paste the key and select "Signing Key"

### Sign commits
Commits are now automatically signed. Verify with:
```bash
git log --show-signature -1
```

## Git Signing with GPG

If you prefer GPG over SSH:

### Generate a GPG key
```bash
gpg --full-generate-key
# Choose: (1) RSA, (4096 bits), (0) No expiration, your name and email
```

### Get your key ID
```bash
gpg --list-secret-keys --keyid-format=long
# Look for sec: rsa4096/XXXXXXXXXXXXXXXX
```

### Configure git
```bash
git config --global user.signingkey XXXXXXXXXXXXXXXX
git config --global commit.gpgSign true
git config --global tag.gpgSign true
```

### Add to GitHub
1. Export: `gpg --armor --export XXXXXXXXXXXXXXXX`
2. GitHub → Settings → SSH and GPG keys → New GPG key
3. Paste the exported key

## Adding a New Nix Package

Edit `home.nix`, add to `home.packages`:
```nix
home.packages = with pkgs; [
  # ... existing packages ...
  your-new-package
];
```

Then run `nix run .`

## Adding a New Non-Nix Tool

Edit `modules/non-nix-installs.nix`, add a new entry in the `let` block:
```nix
installMyTool = pkgs.writeShellApplication {
  name = "install-my-tool";
  runtimeInputs = with pkgs; [ curl bash ];
  text = ''
    set -euo pipefail
    if command -v my-tool &>/dev/null; then
      echo "my-tool already installed"
      return 0 2>/dev/null || exit 0
    fi
    curl -fsSL https://example.com/install.sh | bash
  '';
};
```

Add it to `setupCommands` and `runtimeDeps`.

## Adding a New Bun Global

Edit `modules/packages/bun-globals.nix`:
```nix
[
  "existing-package"
  "new-package"
]
```

Then run `nix run .`

## Platform Support

- **Linux**: Fully supported (Ubuntu, Fedora, etc.)
- **macOS (Apple Silicon)**: Partial — Home Manager works, non-nix tools may need platform-specific adjustments
- **WSL2**: Docker detection built in (expects Docker Desktop on Windows)

## Notes

- Config files in `config/` are symlinked, not copied. Edit them directly.
- `env.nu` and `.bashrc` include paths for bun, vite-plus, and nix profile.
- Nushell history files are gitignored.
- Herdr runtime files (logs, sockets) are gitignored.
- Agents skills are synced via symlink from `agents/` to `~/.agents/`.
