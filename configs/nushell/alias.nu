# Nushell Aliases

alias :q = exit
alias :Q = exit

# Navigation
alias ll = eza -la
alias la = eza -a
alias lt = eza -T
alias cat = bat

# Git
alias gs = git status
alias ga = git add
alias gc = git commit
alias gp = git push
alias gl = git log --oneline -20
alias gd = git diff
alias gds = git diff --staged
alias gco = git checkout
alias gbr = git branch

# Kubernetes
alias k = kubectl
alias kgp = kubectl get pods
alias kgn = kubectl get nodes
alias kgs = kubectl get services

# Dev
alias lg = lazygit
alias ld = lazydocker
alias y = yazi
alias tp = typst compile
alias tw = typst watch

# Laravel
alias art = php artisan
alias sail = ./vendor/bin/sail
