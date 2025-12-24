FROM node:20-slim

RUN apt-get update && apt-get install -y \
    git \
    curl \
    ssh \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# gh CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update && apt-get install -y gh

# Claude Code
RUN npm install -g @anthropic-ai/claude-code

# Set up node user's home for Claude CLI credentials
RUN mkdir -p /home/node/.claude && \
    chown -R node:node /home/node/.claude

WORKDIR /app
COPY package.json ./
RUN npm install
COPY src ./src

# Give node user ownership of app
RUN chown -R node:node /app

# Create work directory
RUN mkdir -p /tmp/work && chown -R node:node /tmp/work

# Switch to non-root user
USER node

# Git config for commits (as node user)
RUN git config --global user.email "noreply@anthropic.com" \
    && git config --global user.name "Claude"

EXPOSE 3000
CMD ["node", "src/server.js"]
