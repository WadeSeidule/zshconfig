function update_dotfiles_if_time() {
    # run update dotfiles every week
    current_time=$(date +%s)
    needs_update=0
    if [ ! -f "$HOME/.dotfiles_last_updated" ]; then
        echo "$current_time" > "$HOME/.dotfiles_last_updated"
        needs_update=1
    fi
    last_updated=$(cat "$HOME/.dotfiles_last_updated")
    if [ $((current_time - last_updated)) -gt 604800 ]; then
        needs_update=1
    fi
    if [ $needs_update -eq 1 ]; then
        echo "Updating dotfiles"
        update_dotfiles
        echo "$current_time" > "$HOME/.dotfiles_last_updated"
    fi
}