#!/usr/bin/env sh

sudo chmod a+rwx ~/.cache
emacs --daemon
openclaw gateway &
export PATH="$HOME/.opencode/bin:$PATH"
opencode web --port=9631 --hostname=0.0.0.0 &
