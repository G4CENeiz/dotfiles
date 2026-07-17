# Nushell environment config

# Fix locale warnings
$env.LC_ALL = "C.utf8"
$env.LANG = "C.utf8"

# --- Paths ---
$env.SDKMAN_DIR = ($env.HOME | path join ".sdkman")

$env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend ($env.SDKMAN_DIR | path join "bin")
    | prepend ($env.HOME | path join ".config/herd-lite/bin")
    | prepend $env.PNPM_HOME
    | prepend ($env.HOME | path join ".nix-profile/bin")
    | prepend ($env.HOME | path join "bin")
    | prepend ($env.HOME | path join ".local/bin")
    | prepend ($env.BUN_INSTALL | path join "bin")
    | uniq
)

# --- Vite+ (https://viteplus.dev) ---
if ($env.HOME | path join ".vite-plus/env.nu" | path exists) { source ~/.vite-plus/env.nu }

# --- History ---
$env.HISTORY_SIZE = 500_000

# SDKMAN (bash wrapper for nushell)
def sdk [...args: string] {
    let sdkdir = $env.SDKMAN_DIR
    bash -c $"source ($sdkdir)/bin/sdkman-init.sh; sdk ($args | str join ' ')"
}
