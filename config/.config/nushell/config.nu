# Nushell config

# --- Prompt ---
$env.PROMPT_COMMAND = { || $"(ansi green)($env.USER)(ansi reset):(ansi blue)(pwd)(ansi reset) $" }
$env.PROMPT_COMMAND_RIGHT = { || "" }
$env.PROMPT_INDICATOR = { || $"(ansi green)>(ansi reset) " }
$env.PROMPT_MULTILINE_INDICATOR = { || $"(ansi green)::>(ansi reset) " }

# --- History ---
$env.HISTORY_FILE_FORMAT = "sqlite"

# --- Aliases ---
alias ll = ls -la
alias la = ls -a
alias l = ls

# --- Keybindings ---
$env.config = {
    edit_mode: emacs
    history: {
        max_size: 500_000
        sync_on_enter: true
        file_format: "sqlite"
    }
    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "fuzzy"
    }
    color_config: {
        separator: dark_gray
        leading_trailing_space_bg: { attr: n }
        header: green_bold
        date: yellow
        filesize: cyan
        row_index: green_bold
        bool: light_cyan
        int: green
        duration: blue
        range: yellow
        float: light_cyan
        string: green
        nothing: light_gray
        binary: light_gray
        cellpath: light_gray
        record: green_bold
        list: green_bold
        table: green_bold
        shape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: b }
        shape_binary: light_cyan_bold
        shape_bool: light_cyan
        shape_bytes: cyan_bold
        shape_cellpath: green
        shape_closure: green_bold
        shape_custom: green
        shape_datetime: yellow_bold
        shape_directory: cyan_bold
        shape_external: light_cyan
        shape_externalarg: green_bold
        shape_filesize: cyan_bold
        shape_flag: blue_bold
        shape_float: light_cyan_bold
        shape_globpattern: cyan_bold
        shape_int: green_bold
        shape_internalcall: light_cyan_bold
        shape_list: green_bold
        shape_literal: blue
        shape_match_pattern: green
        shape_matching_brackets: { attr: u }
        shape_nothing: light_cyan
        shape_operator: yellow
        shape_or: yellow
        shape_pipe: yellow
        shape_range: yellow_bold
        shape_record: green_bold
        shape_redirection: yellow_bold
        shape_signature: green_bold
        shape_string: green
        shape_string_interpolation: cyan_bold
        shape_table: green_bold
        shape_variable: blue
        shape_vardecl: blue
    }
}
