# Dotfiles

Distro-agnostic Linux dotfiles. Works on Ubuntu, Fedora, Arch, anything.

## Quick Start

```bash
git clone https://github.com/G4CENeiz/dotfiles.git ~/remaster/dotfiles
cd ~/remaster/dotfiles

# 1. Install Nix (Determinate Systems - better than official installer)
curl -fsSL https://install.determinate.systems/nix | sh -s -- install

# 2. Install packages
nix profile install .#

# 3. Link configs
chmod +x link.sh
./link.sh

# 4. Manual installs (see MANUAL-INSTALLS.md)
# Docker, VS Code, nvm, bun, pnpm, uv, sdkman, herd-lite, hunk

# 5. Log out/in, then: nu
```

## What's Installed (via Nix)

| Category | Tools |
|----------|-------|
| Shell | nushell |
| Editor | neovim (lazy.vim) |
| Terminal | ghostty |
| CLI | eza, ripgrep, fd, jq, yq, curl, wget, zip, unzip, tar, delta, direnv, carapace, starship, zoxide, bat, fzf, btop, tree |
| TUI | yazi, lazygit, lazydocker, lazysql |
| DevOps | kubectl, helm, k9s, httpie, hurl |
| VCS | jj, jjui, herdr |
| Languages | typst, tinymist, typstyle |
| Media | ffmpeg, imagemagick, yt-dlp |
| Other | mosh, gh, bun, pnpm |

## Manual Installs

See [MANUAL-INSTALLS.md](MANUAL-INSTALLS.md):
- Docker, VS Code
- nvm, sdkman, bun, pnpm, uv, herd-lite
- Hunk (not in nixpkgs yet)
- SSH/GPG keys

## Structure

```
~/remaster/dotfiles/
├── flake.nix              # Nix packages
├── link.sh                # Symlink script
├── README.md              # This file
├── MANUAL-INSTALLS.md     # Manual installs
├── TODO.md                # Setup checklist
└── configs/               # Config files (symlinked)
    ├── agents/
    ├── bash/
    ├── bat/
    ├── btop/
    ├── fzf/
    ├── ghostty/
    ├── git/
    ├── herdr/
    ├── jj/
    ├── jjui/
    ├── lazydocker/
    ├── lazygit/
    ├── nushell/
    ├── nvim/
    ├── omp/
    ├── opencode/
    ├── pi/
    ├── starship/
    ├── yazi/
    └── zsh/
```
