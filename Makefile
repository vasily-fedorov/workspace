.PHONY: show-env

all: bash-history

show-env:
	awk '{if (/^[[:space:]]*#/) print; else {sub(/=.*/, "="); print}}' .devcontainer/.env > .devcontainer/show-env

bash-history: .devcontainer/bash_history
	touch .devcontainer/bash_history
