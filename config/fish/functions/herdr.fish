function herdr --description 'Herdr with a paper frame and readable dark terminal panes'
    # CLI helpers do not change terminal colors.
    if test (count $argv) -gt 0; and not string match -qr '^--(session|remote|no-session)$' -- $argv[1]
        command herdr $argv
        return $status
    end
    set -l rice_config "$HOME/.config/kitty"
    if set -q KITTY_LISTEN_ON; and set -q KITTY_WINDOW_ID
        kitten @ --to "$KITTY_LISTEN_ON" set-colors --match "id:$KITTY_WINDOW_ID" "$rice_config/herdr-dark.conf" 2>/dev/null
    end
    command herdr $argv
    set -l result $status
    if set -q KITTY_LISTEN_ON; and set -q KITTY_WINDOW_ID
        kitten @ --to "$KITTY_LISTEN_ON" set-colors --match "id:$KITTY_WINDOW_ID" "$rice_config/neobrutal.conf" 2>/dev/null
    end
    return $result
end
