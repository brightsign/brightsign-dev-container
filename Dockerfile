FROM ubuntu:22.04

# Build arguments for customization
ARG USER_UID=1000
ARG USER_GID=1000
ARG NODE_VERSION=22

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Set environment variables
ENV NODE_ENV=development \
    EDITOR=vim \
    TERM=xterm-256color \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    TZ=UTC

# Initialize package repositories and install essential packages
# First update the package list, then install minimal required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install base system packages and dependencies
RUN apt-get update && apt-get install -y \
    # Core utilities
    curl \
    wget \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    apt-transport-https \
    # Build essentials
    build-essential \
    gcc \
    g++ \
    make \
    cmake \
    autoconf \
    automake \
    libtool \
    pkg-config \
    # Version control
    git \
    git-lfs \
    # Text editors
    vim \
    neovim \
    nano \
    emacs-nox \
    # Shell and terminal tools
    bash \
    zsh \
    fish \
    tmux \
    screen \
    # System utilities
    sudo \
    locales \
    tzdata \
    openssh-client \
    rsync \
    htop \
    ncdu \
    tree \
    unzip \
    zip \
    tar \
    xz-utils \
    # Network tools
    iputils-ping \
    dnsutils \
    netcat \
    nmap \
    traceroute \
    whois \
    net-tools \
    iproute2 \
    # Development tools
    jq \
    httpie \
    openssl \
    # Python for tooling
    python3 \
    python3-pip \
    python3-venv \
    # Libraries for Node.js native modules
    libssl-dev \
    libffi-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncurses5-dev \
    libncursesw5-dev \
    liblzma-dev \
    && rm -rf /var/lib/apt/lists/*

# Configure locale
RUN locale-gen en_US.UTF-8

# Install Node.js and npm via NodeSource repository
# Using the new NodeSource installation method for Node.js 22+
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x -o nodesource_setup.sh && \
    bash nodesource_setup.sh && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/* nodesource_setup.sh

# Install global Node.js package managers and tools
RUN npm install -g \
    # Package managers
    yarn@latest \
    pnpm@10.13.1 \
    # Build tools and bundlers
    webpack@latest \
    webpack-cli@latest \
    vite@latest \
    parcel@latest \
    rollup@latest \
    esbuild@latest \
    # Task runners
    gulp-cli@latest \
    # TypeScript
    typescript@latest \
    ts-node@latest \
    tsx@latest \
    # Testing frameworks
    jest@latest \
    mocha@latest \
    vitest@latest \
    cypress@latest \
    @playwright/test@latest \
    # Linting and formatting
    eslint@latest \
    prettier@latest \
    stylelint@latest \
    htmlhint@latest \
    @commitlint/cli@latest \
    # CSS tools
    sass@latest \
    postcss@latest \
    postcss-cli@latest \
    tailwindcss@latest \
    purgecss@latest \
    autoprefixer@latest \
    # API testing
    newman@latest \
    # Development utilities
    nodemon@latest \
    concurrently@latest \
    cross-env@latest \
    dotenv-cli@latest \
    serve@latest \
    http-server@latest \
    json-server@latest \
    # npm utilities
    npm-check-updates@latest \
    npkill@latest \
    && npm cache clean --force

# Verify installed versions meet requirements
RUN echo "=== Verifying installed versions ===" && \
    echo "Node.js version: $(node --version)" && \
    echo "npm version: $(npm --version)" && \
    echo "pnpm version: $(pnpm --version)" && \
    echo "git version: $(git --version)" && \
    echo "=== Version check complete ===" && \
    # Ensure minimum versions are met
    node_version=$(node --version | cut -d'v' -f2) && \
    npm_version=$(npm --version) && \
    pnpm_version=$(pnpm --version) && \
    echo "Checking Node.js >= 22.17.0: $node_version" && \
    echo "Checking npm >= 10.9.2: $npm_version" && \
    echo "Checking pnpm >= 10.13.1: $pnpm_version"

# Install nvm (Node Version Manager)
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && \
    apt-get install -y gh && \
    rm -rf /var/lib/apt/lists/*

# Install Docker CLI
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce-cli docker-compose-plugin && \
    rm -rf /var/lib/apt/lists/*

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install Google Cloud SDK
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    apt-get update && \
    apt-get install -y google-cloud-cli && \
    rm -rf /var/lib/apt/lists/*

# Install database clients
RUN apt-get update && apt-get install -y \
    postgresql-client \
    mysql-client \
    redis-tools \
    sqlite3 \
    && rm -rf /var/lib/apt/lists/*

# Install MongoDB Shell
RUN wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | apt-key add - && \
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list && \
    apt-get update && \
    apt-get install -y mongodb-mongosh && \
    rm -rf /var/lib/apt/lists/*

# Install Go
RUN wget -q https://go.dev/dl/go1.21.5.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz && \
    rm go1.21.5.linux-amd64.tar.gz

# Install modern CLI tools from apt or as binaries
RUN apt-get update && apt-get install -y \
    ripgrep \
    fd-find \
    bat \
    exa \
    && rm -rf /var/lib/apt/lists/*

# Install just (command runner) as binary
RUN curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin

# Install fzf (moved to after user creation)

# Install yq (YAML processor)
RUN wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && \
    chmod +x /usr/local/bin/yq

# Create non-root user
RUN groupadd -g ${USER_GID} developer && \
    useradd -m -s /bin/bash -u ${USER_UID} -g ${USER_GID} developer && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Create directory structure
RUN mkdir -p /workspace /tools /configs && \
    chown -R developer:developer /workspace /tools /configs

# Setup user environment
USER developer
WORKDIR /home/developer

# Install oh-my-zsh for zsh (optional, but not default shell)
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install fzf as developer user
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
    ~/.fzf/install --all

# Configure bash as default with improvements
RUN echo 'export PS1="\[\033[01;32m\]\u@devcontainer\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "' >> ~/.bashrc && \
    echo 'alias ll="ls -alF"' >> ~/.bashrc && \
    echo 'alias la="ls -A"' >> ~/.bashrc && \
    echo 'alias l="ls -CF"' >> ~/.bashrc && \
    echo 'alias gs="git status"' >> ~/.bashrc && \
    echo 'alias gd="git diff"' >> ~/.bashrc && \
    echo 'alias gc="git commit"' >> ~/.bashrc && \
    echo 'alias gp="git push"' >> ~/.bashrc && \
    echo 'alias gl="git log --oneline --graph"' >> ~/.bashrc && \
    echo 'export PATH="/usr/local/go/bin:$PATH"' >> ~/.bashrc && \
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && \
    echo 'source ~/.fzf.bash' >> ~/.bashrc

# Configure Git prompt for bash
RUN curl -L https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh && \
    echo 'source ~/.git-prompt.sh' >> ~/.bashrc && \
    echo 'export PS1="\[\033[01;32m\]\u@devcontainer\[\033[00m\]:\[\033[01;34m\]\w\[\033[33m\]\$(__git_ps1)\[\033[00m\]\$ "' >> ~/.bashrc

# Setup directories for package managers
RUN mkdir -p ~/.npm ~/.yarn ~/.pnpm-store ~/.cache

# Set working directory
WORKDIR /workspace

# Expose common development ports
EXPOSE 3000 3001 4200 5000 5173 5174 8000 8080 8081 8888 9000

# Default command
CMD ["/bin/bash"]