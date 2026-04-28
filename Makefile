.PHONY: show-env test-mcp mcp-chrome-devtools mcp-gitlab mcp-graylog mcp-n8n mcp-atlassian mcp-pandoc mcp-bitrix24-mcp mcp-docling mcp-mattermost 

all: bash-history

show-env:
	awk '{if (/^[[:space:]]*#/) print; else {sub(/=.*/, "="); print}}' .devcontainer/.env > .devcontainer/show-env

bash-history:
	touch .devcontainer/bash_history

constitution-md:
	envsubst < ./.config/constitution.md.template > ./.specify/memory/constitution.md

test-mcp: mcp-chrome-devtools mcp-gitlab mcp-graylog mcp-n8n mcp-atlassian mcp-pandoc mcp-bitrix24-mcp mcp-docling mcp-mattermost 

mcp-chrome-devtools:
	@echo "Testing mcp-chrome-devtools..."
	npx -y chrome-devtools-mcp --browser-url=http://127.0.0.1:9222

mcp-gitlab:
	@echo "Testing mcp-gitlab..."
	npx -y @zereight/mcp-gitlab

mcp-graylog:
	@echo "Testing mcp-graylog..."
	sh -c 'cd /home/work/.mcp_graylog && ./start.sh'

mcp-mattermost:
	@echo "Testing mcp-mattermost..."
	node /home/work/.mattermost-mcp/build/index.js

mcp-n8n:
	@echo "Testing mcp-n8n..."
	npx -y n8n-mcp

mcp-atlassian:
	@echo "Testing mcp-atlassian..."
	uvx mcp-atlassian

mcp-pandoc:
	@echo "Testing mcp-pandoc..."
	uvx mcp-pandoc

mcp-bitrix24-mcp:
	@echo "Testing mcp-bitrix24..."
	uvx bitrix24-mcp

mcp-docling:
	@echo "Testing mcp-docling..."
	curl -s http://docling-serve:5002/mcp
