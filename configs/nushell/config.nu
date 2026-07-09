# Nushell Config
source alias.nu

$env.config = {
  edit_mode: 'emacs'
  show_banner: false
  buffer_editor: "nvim"

  history = {
    file_format: sqlite
    max_size: 5_000_000
    sync_on_enter: true
    isolation: true
  }

  table = { mode: "compact" }

  completions = {
    case_sensitive = false
    quick: true
    partial = true
    algorithm = "fuzzy"
    external: {
      enable = true
      max_results = 100
      completer: {|spans|
        carapace $spans.0 nushell ...$spans | from json
      }
    }
  }

  hooks = {
    pre_prompt = [{ ||
      if (which direnv | is-empty) { return }
      direnv export json | from json | default {} | load-env
      if 'ENV_CONVERSIONS' in $env and 'PATH' in $env.ENV_CONVERSIONS {
        $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
      }
    }]
  }
}
