#!/usr/bin/env sh

sudo chmod a+rwx ~/.cache
emacs --daemon
openclaw gateway &
opencode web --port=9631 --hostname=0.0.0.0 &

