# Gace's Dotfiles

Declarative environment setup using Nix Flakes + Home Manager.

## What's Managed

**Nix packages** (from nixpkgs):
git, curl, wget, gnupg, unzip, tar, ripgrep, fd, fzf, bat, jq, yq, eza, delta, tree,
htop, btop, jujutsu, jjui, lazygit, lazydocker, lazysql, bash, bash-completion, nushell,
carapace, starship, zoxide, direnv, ffmpeg, imagemagick, yt-dlp, yazi, httpie, hurl,
kubectl, kubernetes-helm, k9s, typst, tinymist

**Non-nix tools** (installed via official scripts):
bun, vite-plus, uv, pnpm, SDKMAN, herdr, herd-lite, docker, zen-browser, DankMaterialShell

**Config files** (symlinked to system paths):
- `~/.config/nushell/config.nu` → `config/.config/nushell/config.nu`
- `~/.config/nushell/env.nu` → `config/.config/nushell/env.nu`
- `~/.config/herdr/` → `config/.config/herdr/`
- `~/.config/gh/config.yml` → `config/.config/gh/config.yml`
- `~/.config/lazygit/config.yml` → `config/.config/lazygit/config.yml`
- `~/.config/niri/` → `config/.config/niri/` (window manager + DMS theme)
- `~/.config/DankMaterialShell/` → `config/.config/DankMaterialShell/` (browser CSS)
- `~/.config/ghostty/` → `config/.config/ghostty/` (DankLinux theme)
- `~/.agents/` → `agents/`

**Programs configured** (via Home Manager):
- git (with delta as diff tool, aliases)
- bash (with zoxide, carapace)
- nushell (with carapace)
- starship prompt
- zoxide
- direnv

**Not managed** (install manually):
VS Code, code editors

## Quick Start

```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
```

Restart your shell, then:

```bash
git clone https://github.com/G4CENeiz/dotfiles ~/.dotfiles
cd ~/.dotfiles
sudo -v && nix run .
```

That's it. `sudo -v` caches your password once so the setup script can run Docker and battery threshold commands without prompting mid-run.

## Updating

### Update all pinned inputs (nixpkgs, home-manager)
```bash
cd ~/.dotfiles
nix flake update
sudo -v && nix run .
```

### Update just nixpkgs (not home-manager)
```bash
cd ~/.dotfiles
nix flake lock --update-input nixpkgs
sudo -v && nix run .
```

### See what would change before updating
```bash
cd ~/.dotfiles
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

nix run .#install-zen
nix run .#install-dms
nix run .#setup-battery-sudoers
nix run .#install-uv
nix run .#install-zen
nix run .#setup-battery-sudoers
nix run .#set-battery-threshold
```

## Battery Charge Limit

Your battery charges to 80% by default. To change the limit, edit `threshold = 80` in `modules/tools/battery-threshold.nix` and re-run `nix run .`.

To re-apply after reboot without a full setup:

```bash
set-battery-threshold
```

## Repository Structure

```
~/.dotfiles/
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
│       ├── herdr/
│       │   └── config.toml
│       ├── gh/
│       │   └── config.yml
│       ├── lazygit/
│       │   └── config.yml
│       ├── niri/
│       │   ├── config.kdl
│       │   └── dms/
│       ├── DankMaterialShell/
│       │   ├── firefox.css
│       │   └── zen.css
│       └── ghostty/
│           ├── config
│           └── themes/
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
        ├── docker.nix
        └── battery-threshold.nix
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
```

Choose: (1) RSA, (4096 bits), (0) No expiration, your name and email.

### Get your key ID
```bash
gpg --list-secret-keys --keyid-format=long
```

Look for `sec: rsa4096/XXXXXXXXXXXXXXXX`.

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

Then run:
```bash
nix run .
```

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
      exit 0
    fi
    curl -fsSL https://example.com/install.sh | bash
  '';
};
```

Add it to `setupCommands` and `runtimeDeps`.

Then run:
```bash
nix run .
```

## Adding a New Bun Global

Edit `modules/packages/bun-globals.nix`:
```nix
[
  "existing-package"
  "new-package"
]
```

Then run:
```bash
nix run .
```

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
- Zen Browser is installed via official tarball script, skipped on WSL.
- DankMaterialShell is installed via COPR on Fedora, includes niri, ghostty, and quickshell. Skipped on WSL.
- Battery charge limit defaults to 80%, configurable in `modules/tools/battery-threshold.nix`.
