# Nushell Environment

# PATH
$env.PATH = ($env.PATH | split row (char esep) | prepend $"($env.HOME)/.local/bin")
$env.PATH = ($env.PATH | split row (char esep) | prepend $"($env.HOME)/.bun/bin")

# Editor
$env.EDITOR = "nvim"
$env.VISUAL = "nvim"

# Herd Lite
$env.PATH = ($env.PATH | split row (char esep) | prepend $"($env.HOME)/.config/herd-lite/bin")
$env.PHP_INI_SCAN_DIR = $"($env.HOME)/.config/herd-lite/bin"
