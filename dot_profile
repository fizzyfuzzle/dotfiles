# Automatic start/restore TMUX on servers
if [ $(tty) != /dev/tty1 ] && command -v tmux &>/dev/null && [ -z "$TMUX" ]; then
    tmux attach -t $(hostname) || sleep 0.1; tmux new -s $(hostname)
fi
