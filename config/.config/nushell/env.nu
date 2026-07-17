# Nushell environment config

# Fix locale warnings
$env.LC_ALL = "C.utf8"
$env.LANG = "C.utf8"

# --- Environment variables (set BEFORE PATH) ---
$env.BUN_INSTALL = ($env.HOME | path join ".bun")
$env.PNPM_HOME = ($env.HOME | path join ".local/share/pnpm")
$env.SDKMAN_DIR = ($env.HOME | path join ".sdkman")

# Hostname
if ("/etc/hostname" | path exists) {
    $env.HOSTNAME = (open /etc/hostname | str trim)
} else {
    $env.HOSTNAME = "unknown"
}

# --- Build PATH ---
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

# --- Vite+ (skip env.nu - it's incompatible with nushell PATH handling) ---
# vp binary is already in PATH above

# --- History ---
$env.HISTORY_SIZE = 500_000

# SDKMAN (bash wrapper for nushell)
def sdk [...args: string] {
    let sdkdir = $env.SDKMAN_DIR
    bash -c $"source ($sdkdir)/bin/sdkman-init.sh; sdk ($args | str join ' ')"
}
