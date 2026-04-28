#!/usr/bin/env sh

sudo chmod a+rwx ~/.cache
sudo mkdir -p ~/.local/share/opencode && sudo chown -R $(id -u):$(id -g) ~/.local/share/opencode
emacs --daemon
export PATH="$HOME/.opencode/bin:$PATH"
opencode web --port=$PORT --hostname=0.0.0.0 &
