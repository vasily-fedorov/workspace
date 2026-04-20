#!/usr/bin/env -S docker build . --tag=devcontainer --network=host --file
ARG IMAGE=ubuntu:latest
FROM $IMAGE AS base
ARG USER_ID=${UID}
ARG USERNAME=${COMPOSE_PROJECT_NAME}
ARG PORT=8642
ARG VSEGPT_API_KEY
ARG VSEGPT_API
ARG OPENCLAW_TOKEN
ARG MATTERMOST_URL
ARG MATTERMOST_ACCESS_TOKEN
ARG MATTERMOST_TEAM_ID
ENV USERNAME=${USERNAME}
ENV DEBIAN_FRONTEND=noninteractive
ENV VSEGPT_API_KEY=${VSEGPT_API_KEY}
ENV VSEGPT_API=${VSEGPT_API}
ENV OPENCLAW_TOKEN=${OPENCLAW_TOKEN}
ENV MATTERMOST_URL=${MATTERMOST_URL}
ENV MATTERMOST_ACCESS_TOKEN=${MATTERMOST_ACCESS_TOKEN}
ENV MATTERMOST_TEAM_ID=${MATTERMOST_TEAM_ID}
# for .bashrc
ENV PROMPT_COMMAND='history -a'

RUN rm -f /etc/apt/apt.conf.d/docker-clean ; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache && \
    mkdir -p /etc/emacs/site-start.d

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/root/.cache,sharing=locked \
    --mount=type=cache,target=/home/$USERNAME/.cache,uid=$USER_ID,gid=1000,sharing=locked \
    apt update && apt -y install --no-install-recommends --no-install-suggests \
    adduser sudo curl bash less ca-certificates ssh-client git unzip pandoc \
    pipx npm nodejs file poppler-utils wget jq emacs gettext-base gpg htop \
    language-pack-ru locales bash-completion \
    && sudo locale-gen ru_RU.UTF-8 && sudo update-locale LANG=ru_RU.UTF-8
# RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
#     --mount=type=cache,target=/var/lib/apt,sharing=locked \
#     --mount=type=cache,target=/root/.cache,sharing=locked \
#     --mount=type=cache,target=/home/$USERNAME/.cache,sharing=locked \
#   apt-get update && apt-get install -y software-properties-common curl gnupg \
#  && add-apt-repository ppa:xtradeb/apps -y && apt-get update \
#  && apt-get install -y chromium \
#  && add-apt-repository ppa:mozillateam/ppa && apt-get install -y firefox \
#  && add-apt-repository "deb https://repo.yandex.ru/yandex-browser/deb stable main" \
#  && apt-get update && apt-get install yandex-browser-stable


# If UID is 1000, rename the existing user instead of creating a new one
RUN if [ "$USER_ID" = "1000" ]; then \
        existing_user=$(getent passwd 1000 | cut -d: -f1); \
        if [ -n "$existing_user" ] && [ "$existing_user" != "$USERNAME" ]; then \
            usermod -l $USERNAME $existing_user && \
            usermod -d /home/$USERNAME -m $USERNAME && \
            groupmod -n $USERNAME $existing_user; \
        fi; \
    else \
        adduser --disabled-password --uid $USER_ID $USERNAME && adduser $USERNAME sudo; \
    fi

RUN echo "$USERNAME ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/$USERNAME

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/root/.cache,sharing=locked \
    --mount=type=cache,target=/home/$USERNAME/.cache,uid=$USER_ID,gid=1000,sharing=locked \
 curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg \
 && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list \
 && sudo apt update \
 && sudo apt install -y google-chrome-stable

USER $USERNAME
WORKDIR /workspace
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/root/.cache,sharing=locked \
    --mount=type=cache,target=/home/$USERNAME/.cache,sharing=locked \
  curl -fsSL https://opencode.ai/install | bash \
  && curl -LsSf https://astral.sh/uv/install.sh | sh \
  && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash \
  && export NVM_DIR="$HOME/.nvm" \
  && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
  && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" \
  && nvm install 24.9.0

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/root/.cache,sharing=locked \
    --mount=type=cache,target=/home/$USERNAME/.cache,uid=$USER_ID,gid=1000,sharing=locked \
 pipx install uv

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/root/.cache,sharing=locked \
    --mount=type=cache,target=/home/$USERNAME/.cache,uid=$USER_ID,gid=1000,sharing=locked \
 curl -s https://api.github.com/repos/be5invis/Iosevka/releases/latest | grep browser_download_url | grep -i ttc | head -1 | cut -d'"' -f4 | xargs wget -O iosevka.zip && sudo unzip iosevka.zip -d /usr/share/fonts/ && fc-cache -fv

RUN git clone https://github.com/mothlike/mcp_graylog.git /home/$USERNAME/.mcp_graylog

# Mattermost MCP Server
RUN git clone https://github.com/vasily-fedorov/mattermost-mcp.git /home/$USERNAME/.mattermost-mcp && \
    cd /home/$USERNAME/.mattermost-mcp && \
    npm install && \
    npm run build

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/root/.cache,sharing=locked \
    --mount=type=cache,target=/home/$USERNAME/.cache,uid=$USER_ID,gid=1000,sharing=locked \
 curl -sS https://raw.githubusercontent.com/hezkore/bash-ai/main/install.sh | bash \
 && mkdir -p /home/$USERNAME/.bai_tools \
 && curl -sS https://raw.githubusercontent.com/hezkore/bash-ai/main/tools/cat.sh -o /home/$USERNAME/.bai_tools/cat.sh \
 && curl -sS https://raw.githubusercontent.com/hezkore/bash-ai/main/tools/find-wild.sh -o /home/$USERNAME/.bai_tools/find-wild.sh \
 && curl -sS https://raw.githubusercontent.com/hezkore/bash-ai/main/tools/ls.sh -o /home/$USERNAME/.bai_tools/ls.sh

RUN mkdir -p /home/$USERNAME/.config

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/root/.cache,sharing=locked \
    --mount=type=cache,target=/home/$USERNAME/.cache,uid=$USER_ID,gid=1000,sharing=locked \
 pipx run uv tool install specify-cli --from git+https://github.com/github/spec-kit.git

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/root/.cache,sharing=locked \
    --mount=type=cache,target=/home/$USERNAME/.cache,uid=$USER_ID,gid=1000,sharing=locked \
 curl -fsSL https://openclaw.ai/install.sh | bash -s -- --no-onboard

# org-mcp: Install Emacs MCP server packages from MELPA
RUN --mount=type=cache,target=/home/$USERNAME/.cache,uid=$USER_ID,gid=1000,sharing=locked \
    emacs --batch --eval '(progn \
      (require (quote package)) \
      (add-to-list (quote package-archives) (cons "melpa" "https://melpa.org/packages/") t) \
      (package-refresh-contents) \
      (package-install (quote mcp-server-lib)) \
      (package-install (quote org-mcp)))'

RUN mkdir -p /home/$USERNAME/.emacs.d && \
    cat > /home/$USERNAME/.emacs.d/init-org-mcp.el << 'EOF'
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(require 'org-mcp)
(require 'mcp-server-lib)
(setq org-mcp-allowed-files (directory-files-recursively (expand-file-name "org" (getenv "HOME")) "\\.org$"))
(mcp-server-lib-install)
(org-mcp-enable)
(mcp-server-lib-start)
EOF

RUN cat > /home/$USERNAME/.emacs << 'EOF'
;; Load org-mcp configuration
(load "~/.emacs.d/init-org-mcp.el")
EOF

COPY --chown=$USER_ID .devcontainer /workspace/.devcontainer

USER root
# features begin: run install.sh for every feature
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/root/.cache,sharing=locked \
    --mount=type=cache,target=/home/$USERNAME/.cache,sharing=locked \
    if [ -f /workspace/.devcontainer/dood/install.sh ]; then bash /workspace/.devcontainer/dood/install.sh; fi
# features end
USER $USERNAME  


# Copy .config templates and process them with env vars from build args
COPY --chown=$USER_ID .config/*.template /tmp/templates/
RUN mkdir -p /home/$USERNAME/.config /home/$USERNAME/.openclaw /home/$USERNAME/.mattermost-mcp && \
    envsubst < /tmp/templates/bai.cfg.template > /home/$USERNAME/.config/bai.cfg && \
    envsubst < /tmp/templates/openclaw.json.template > /home/$USERNAME/.openclaw/openclaw.json && \
    envsubst < /tmp/templates/mattermost-mcp.json.template > /home/$USERNAME/.mattermost-mcp/config.local.json && \
    cp /tmp/templates/opencode.json.template /home/$USERNAME/.opencode/opencode.json && \
    rm -rf /tmp/templates
RUN npm config delete prefix && npm config delete globalconfig
WORKDIR /workspace


CMD ["sh", "-c", "sh /workspace/.devcontainer/cmd.sh && sleep infinity"]
