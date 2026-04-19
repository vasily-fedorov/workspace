.PHONY: show-env test-mcp mcp-chrome-devtools mcp-gitlab mcp-graylog mcp-mattermost mcp-n8n mcp-atlassian mcp-pandoc mcp-bitrix24-mcp

all: bash-history

show-env:
	awk '{if (/^[[:space:]]*#/) print; else {sub(/=.*/, "="); print}}' .devcontainer/.env > .devcontainer/show-env

bash-history:
	touch .devcontainer/bash_history

test-mcp: mcp-chrome-devtools mcp-gitlab mcp-graylog mcp-mattermost mcp-n8n mcp-atlassian mcp-pandoc mcp-bitrix24-mcp

mcp-chrome-devtools:
	@echo "Testing mcp-chrome-devtools..."
	@timeout 5s npx -y chrome-devtools-mcp --browser-url=http://127.0.0.1:9222 --help 2>&1 | head -5 && echo "✓ mcp-chrome-devtools OK" || echo "✗ mcp-chrome-devtools FAILED"

mcp-gitlab:
	@echo "Testing mcp-gitlab..."
	@timeout 5s npx -y @zereight/mcp-gitlab --help 2>&1 | head -5 && echo "✓ mcp-gitlab OK" || echo "✗ mcp-gitlab FAILED"

mcp-graylog:
	@echo "Testing mcp-graylog..."
	@if [ -f /home/work/.mcp_graylog/start.sh ]; then \
		timeout 5s sh -c 'cd /home/work/.mcp_graylog && ./start.sh --help 2>&1 | head -5' && echo "✓ mcp-graylog OK" || echo "✗ mcp-graylog FAILED"; \
	else \
		echo "✗ mcp-graylog not found"; \
	fi

mcp-mattermost:
	@echo "Testing mcp-mattermost..."
	@if [ -f /home/work/.mattermost-mcp/build/index.js ]; then \
		timeout 5s node /home/work/.mattermost-mcp/build/index.js --help 2>&1 | head -5 && echo "✓ mcp-mattermost OK" || echo "✗ mcp-mattermost FAILED"; \
	else \
		echo "✗ mcp-mattermost not found"; \
	fi

mcp-n8n:
	@echo "Testing mcp-n8n..."
	@timeout 5s npx -y n8n-mcp --help 2>&1 | head -5 && echo "✓ mcp-n8n OK" || echo "✗ mcp-n8n FAILED"

mcp-atlassian:
	@echo "Testing mcp-atlassian..."
	@timeout 5s uvx mcp-atlassian --help 2>&1 | head -5 && echo "✓ mcp-atlassian OK" || echo "✗ mcp-atlassian FAILED"

mcp-pandoc:
	@echo "Testing mcp-pandoc..."
	@timeout 5s uvx mcp-pandoc --help 2>&1 | head -5 && echo "✓ mcp-pandoc OK" || echo "✗ mcp-pandoc FAILED"

mcp-bitrix24-mcp:
	@echo "Testing mcp-bitrix24..."
	@timeout 5s uvx bitrix24-mcp --help 2>&1 | head -5 && echo "✓ mcp-bitrix24 OK" || echo "✗ mcp-bitrix24 FAILED"
