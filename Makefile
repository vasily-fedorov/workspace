.PHONY: env-dist

env-dist:
	awk '{if (/^[[:space:]]*#/) print; else {sub(/=.*/, "="); print}}' .devcontainer/.env > .devcontainer/.env-dist