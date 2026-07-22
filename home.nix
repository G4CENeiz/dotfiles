# home.nix — Home Manager configuration
# Packages from nixpkgs + symlinked config files
{ pkgs, config, dotfiles, username, homeDirectory, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;

  # Battery threshold module
  battery = import ./modules/tools/battery-threshold.nix { inherit pkgs; };
in
{
  home.stateVersion = "24.11";
  home.username = username;
  home.homeDirectory = homeDirectory;

  # ── Nix packages (installed from nixpkgs) ──
  home.packages = with pkgs; [
    # Core CLI tools
    git
    curl
    wget
    gnupg
    gh
    unzip
    gnutar

    # Editor
    neovim

    # Search & find
    ripgrep
    fd
    fzf

    # Display & format
    bat
    jq
    yq
    eza
    delta
    tree

    # System
    htop
    btop

    # Version control
    lazygit

    # Docker TUIs
    lazydocker

    # Database TUI
    lazysql

    # Shell
    bash
    bash-completion
    nushell
    carapace
    starship
    zoxide
    direnv

    # Media
    ffmpeg
    imagemagick
    yt-dlp

    # File manager
    yazi

    # HTTP
    httpie
    hurl

    # Kubernetes
    kubectl
    kubernetes-helm
    k9s

    # Typst
    typst
    tinymist
  ];

  # ── Bash ──
  programs.bash = {
    enable = true;
    shellOptions = [];
    historyControl = [ "ignoreboth" ];
    historySize = 10000;
    historyFileSize = 20000;
    shellAliases = {
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
    };
    initExtra = ''
      # Fix locale warnings
      export LC_ALL=C.utf8

      # bun
      export BUN_INSTALL="$HOME/.bun"
      export PATH="$BUN_INSTALL/bin:$PATH"

      # Vite+ (https://viteplus.dev)
      [ -f "$HOME/.vite-plus/env" ] && source "$HOME/.vite-plus/env"

      # Local bin
      export PATH="$HOME/.local/bin:$PATH"

      # Nix profile
      export PATH="$HOME/.nix-profile/bin:$PATH"

      # SDKMAN
      export SDKMAN_DIR="$HOME/.sdkman"
      [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

      # herd-lite
      export PATH="$HOME/.config/herd-lite/bin:$PATH"

      # zoxide
      eval "$(zoxide init bash)"

      # carapace
      eval "$(carapace bash)"
    '';
  };

  # Fix locale warnings in bash (set before bashrc loads)
  home.file.".profile".text = ''
    export LC_ALL=C.utf8
    export LANG=C.utf8
  '';



  # ── Git ──
  programs.git = {
    enable = true;
    userName = "Baihaqi";
    userEmail = "116696555+G4CENeiz@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      merge.conflictstyle = "zdiff3";
      diff.algorithm = "histogram";
      core.pager = "${pkgs.delta}/bin/delta";
      interactive.diffFilter = "${pkgs.delta}/bin/delta --color-only";
      delta = {
        navigate = true;
        light = false;
        line-numbers = true;
        side-by-side = false;
      };
      # gh CLI integration
      gh = {
        aliases = {
          pr = "pull-request";
        };
      };
    };
    aliases = {
      s = "status";
      d = "diff";
      ds = "diff --staged";
      co = "checkout";
      br = "branch";
      ci = "commit";
      lg = "log --oneline --graph --decorate -20";
      undo = "reset HEAD~1 --mixed";
      amend = "commit --amend --no-edit";
      stash-all = "stash push --include-untracked";
      # gh shortcuts
      prs = "gh pr list";
      prc = "gh pr create";
      prv = "gh pr view";
      issues = "gh issue list";
    };
  };

  # ── Starship prompt ──
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };
      git_branch = {
        symbol = " ";
      };
      git_status = {
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        staged = "[+\${count}](green)";
        modified = "[!\${count}](yellow)";
        untracked = "[?\${count}](red)";
      };
      cmd_duration = {
        format = "[$\{duration}]($\{style}) ";
      };
      nix_shell = {
        symbol = " ";
      };
    };
  };

  # ── Zoxide (smarter cd) ──
  programs.zoxide = {
    enable = true;
  };

  # ── Direnv ──
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  # ── Symlinked config files ──
  # These point to your repo, not the nix store.
  # Edit directly — no rebuild needed.
  xdg.configFile = {
    # Nushell — symlink config.nu, let env.nu stay ours too
    "nushell/config.nu" = {
      source = mkOutOfStoreSymlink "${dotfiles}/config/.config/nushell/config.nu";
    };
    "nushell/env.nu" = {
      source = mkOutOfStoreSymlink "${dotfiles}/config/.config/nushell/env.nu";
    };

    # Herdr
    "herdr" = {
      source = mkOutOfStoreSymlink "${dotfiles}/config/.config/herdr";
      recursive = true;
    };

    # Neovim — symlink config, managed by lazy.nvim
    "nvim" = {
      source = mkOutOfStoreSymlink "${dotfiles}/config/.config/nvim";
      recursive = true;
    };
  };

  # Agents skills — sync from dotfiles
  # home.file targets ~/. not ~/.config/
  home.file.".agents" = {
    source = mkOutOfStoreSymlink "${dotfiles}/agents";
    recursive = true;
  };

  # Battery threshold — stable path for sudoers
  home.file.".local/bin/set-battery-threshold" = {
    source = battery.script;
    executable = true;
  };
}
