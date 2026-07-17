# Nushell environment config

# --- Paths ---
$env.BUN_INSTALL = ($env.HOME | path join ".bun")
$env.PATH = (
    $env.PATH
    | prepend ($env.BUN_INSTALL | path join "bin")
    | prepend ($env.HOME | path join ".local" | path join "bin")
    | prepend ($env.HOME | path join "bin")
)
# --- Vite+ (https://viteplus.dev) ---
if ($env.HOME | path join ".vite-plus/env.nu" | path exists) { source ~/.vite-plus/env.nu }

# --- History ---
$env.HISTORY_SIZE = 500_000

# --- Editor ---
# $env.EDITOR = "vim"
# --- Nix profile ---
if (($env.HOME | path join ".nix-profile/bin") | path exists) {
    $env.PATH = ($env.PATH | prepend ($env.HOME | path join ".nix-profile/bin"))
}

# pnpm
$env.PNPM_HOME = "/home/gace/.local/share/pnpm"
$env.PATH = ($env.PATH | split row (char esep) | prepend ($env.PNPM_HOME | path join "bin") )
# pnpm end
