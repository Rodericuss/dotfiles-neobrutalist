fish_add_path ~/.local/bin ~/.cargo/bin
set -gx EDITOR nvim
set -gx VISUAL nvim
if status is-interactive
    zoxide init fish --cmd cd | source
    starship init fish | source
    direnv hook fish | source
    alias ls eza
    alias ll 'eza -l'
    alias la 'eza -la'
    alias lt 'eza --tree'
end
