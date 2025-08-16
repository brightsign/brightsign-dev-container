# Development Container for HTML5 & Node.js

A highly optimized Docker container providing a comprehensive CLI environment for HTML5 web application and Node.js development. Works consistently across Windows, macOS, and Linux.

## Quick Start

```bash
# Build the container
docker build -t devcontainer .

# Run with current directory mounted
docker run -it -v $(pwd):/workspace devcontainer

# Run with persistent home directory
docker run -it -v $(pwd):/workspace -v devhome:/home/developer devcontainer
```

## Features

### Core Technologies
- **Node.js 20.x LTS** with npm, yarn, and pnpm
- **TypeScript** with ts-node and tsx
- **Git** with GitHub CLI and GitLab CLI

### Build Tools
- Modern bundlers: Vite, Webpack, Parcel, Rollup, esbuild, SWC
- Task runners: Make, Just, Gulp
- CSS tools: Sass, PostCSS, Tailwind CSS, PurgeCSS

### Testing & Quality
- Test frameworks: Jest, Mocha, Cypress, Playwright, Vitest
- Linters: ESLint, Prettier, Stylelint, HTMLHint
- Commit tools: Commitlint, Husky support

### Development Tools
- Editors: Vim, Neovim, Nano
- Shell: Zsh with oh-my-zsh (default), Bash, Fish
- Utilities: tmux, fzf, ripgrep, bat, htop
- API tools: curl, httpie, jq, Postman CLI

### Database Clients
- PostgreSQL, MySQL, MongoDB, Redis, SQLite3

### Cloud & Container Tools
- Docker CLI & Docker Compose
- Kubernetes (kubectl)
- AWS CLI, Azure CLI, Google Cloud SDK

## Key Benefits

✅ **Cross-platform**: Identical environment on Windows, macOS, and Linux  
✅ **Pre-configured**: All tools installed and ready to use  
✅ **Optimized**: Fast startup, minimal resource usage  
✅ **Extensible**: Easy to add project-specific tools  
✅ **Secure**: Non-root user, minimal attack surface  

## System Requirements

- Docker Desktop or Docker Engine
- 4GB RAM minimum (8GB recommended)
- 10GB free disk space
- x86_64 or ARM64 processor

## Documentation

See [docs/design.md](docs/design.md) for detailed design documentation including:
- Complete tool list and versions
- Architecture decisions
- Configuration details
- Optimization strategies
- Security considerations
- Extensibility options

## Usage Examples

### Basic Development
```bash
docker run -it -v $(pwd):/workspace devcontainer
```

### With Docker Socket (for Docker-in-Docker)
```bash
docker run -it \
  -v $(pwd):/workspace \
  -v /var/run/docker.sock:/var/run/docker.sock \
  devcontainer
```

### As Persistent Development Environment
```bash
# Start container in background
docker run -d --name dev \
  -v $(pwd):/workspace \
  -v devhome:/home/developer \
  devcontainer sleep infinity

# Connect to it
docker exec -it dev zsh
```

### With Port Forwarding
```bash
docker run -it \
  -v $(pwd):/workspace \
  -p 3000:3000 \
  -p 8080:8080 \
  devcontainer
```

## Container Structure

```
/workspace          # Your mounted project directory
/tools              # Custom tools and scripts
/configs            # Shared configurations
/home/developer     # User home directory
```

## Environment Variables

- `NODE_ENV=development`
- `EDITOR=vim`
- `TERM=xterm-256color`
- `LANG=en_US.UTF-8`

## Customization

### Adding Tools
Create a custom Dockerfile:
```dockerfile
FROM devcontainer
RUN npm install -g your-tool
```

### Project-Specific Configuration
Add a `.devcontainer/devcontainer.json`:
```json
{
  "image": "devcontainer",
  "postCreateCommand": "npm install",
  "forwardPorts": [3000, 8080]
}
```

## Performance

- **Image size**: ~2GB compressed
- **Startup time**: <5 seconds
- **Memory usage**: <512MB idle
- **Build time**: <10 minutes

## Support

- Report issues: [GitHub Issues](https://github.com/your-org/devcontainer/issues)
- Documentation: [docs/](docs/)
- Updates: Weekly security patches, monthly tool updates

## License

MIT License - See [LICENSE](LICENSE) file for details