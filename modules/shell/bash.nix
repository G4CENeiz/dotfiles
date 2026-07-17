# modules/shell/bash.nix
# Bash shell configuration
{ pkgs }:

{
  # Bash packages (completions, etc.)
  buildInputs = with pkgs; [
    bash
    bash-completion
  ];
}
