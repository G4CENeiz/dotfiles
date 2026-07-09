{
  description = "gace's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system}.default = pkgs.buildEnv {
        name = "gace-tools";
        paths = [
          # ── Shell ───────────────────────────────────────
          pkgs.nushell

          # ── Editor ──────────────────────────────────────
          pkgs.neovim

          # ── Terminal ────────────────────────────────────
          pkgs.ghostty

          # ── Git ─────────────────────────────────────────
          pkgs.git

          # ── CLI Tools ───────────────────────────────────
          pkgs.eza           # better ls
          pkgs.ripgrep       # better grep
          pkgs.fd            # better find
          pkgs.jq            # JSON processor
          pkgs.yq            # YAML processor
          pkgs.curl
          pkgs.wget
          pkgs.zip
          pkgs.unzip
          pkgs.gnutar
          pkgs.delta     # better git diff
          pkgs.direnv        # auto env loading
          pkgs.carapace      # shell completions
          pkgs.starship      # prompt
          pkgs.zoxide        # smart cd
          pkgs.bat           # better cat
          pkgs.fzf           # fuzzy finder
          pkgs.btop          # system monitor
          pkgs.tree          # directory listing

          # ── TUI Apps ────────────────────────────────────
          pkgs.yazi          # file manager
          pkgs.lazygit       # git TUI
          pkgs.lazydocker    # docker TUI
          pkgs.lazysql       # database TUI

          # ── DevOps ──────────────────────────────────────
          pkgs.kubectl
          pkgs.kubernetes-helm
          pkgs.k9s
          pkgs.httpie
          pkgs.hurl

          # ── VCS ─────────────────────────────────────────
          pkgs.jujutsu       # jj
          pkgs.jjui          # jj TUI
          pkgs.herdr         # terminal multiplexer

          # ── Languages ───────────────────────────────────
          pkgs.typst
          pkgs.tinymist      # typst LSP
          pkgs.typstyle      # typst formatter

          # ── Media ───────────────────────────────────────
          pkgs.ffmpeg
          pkgs.imagemagick
          pkgs.yt-dlp

          # ── Other ───────────────────────────────────────
          pkgs.mosh          # mobile shell
          pkgs.gh            # GitHub CLI
          pkgs.bun           # JS runtime
          pkgs.pnpm          # package manager
        ];
      };
    };
}
