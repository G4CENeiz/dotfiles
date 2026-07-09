# Dotfiles TODO

## Phase 1: WSL Setup

- [ ] Clone repo: `git clone <repo> ~/remaster/dotfiles`
- [ ] Install Nix: `sh <(curl -L https://nixos.org/nix/install) --daemon`
- [ ] Enable flakes: `echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf`
- [ ] Install packages: `cd ~/remaster/dotfiles && nix profile install .#`
- [ ] Link configs: `./link.sh`
- [ ] Install Docker (see MANUAL-INSTALLS.md)
- [ ] Install VS Code (see MANUAL-INSTALLS.md)
- [ ] Install nvm (see MANUAL-INSTALLS.md)
- [ ] Install bun (see MANUAL-INSTALLS.md)
- [ ] Install pnpm (see MANUAL-INSTALLS.md)
- [ ] Install uv (see MANUAL-INSTALLS.md)
- [ ] Install sdkman (see MANUAL-INSTALLS.md)
- [ ] Install herd-lite (see MANUAL-INSTALLS.md)
- [ ] Set up SSH key (see MANUAL-INSTALLS.md)
- [ ] Set up GPG key (see MANUAL-INSTALLS.md)
- [ ] Log out and back in
- [ ] Test: `nu`

## Phase 2: Workstation

- [ ] Install Proxmox on workstation
- [ ] Create Fedora VM
- [ ] Clone repo
- [ ] Run setup steps from Phase 1
- [ ] Test everything matches WSL
