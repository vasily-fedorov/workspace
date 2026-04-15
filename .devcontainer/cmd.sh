#!/usr/bin/env sh

sudo chmod a+rwx ~/.cache
openclaw gateway &
opencode web --port=9631 --hostname=0.0.0.0 &
emacs --daemon

