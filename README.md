```
 ____  _     _   _ _   _ __  __ ____  __  __ ___ _  _
|  _ \| |   | | | | \ | |  \/  / ___||  \/  |_ _| \ | |
| |_) | |   | | | |  \| | |\/| \___ \| |\/| || ||  \| |
|  __/| |___| |_| | |\  | |  | |___) | |  | || || |\  |
|_|   |_____|\___/|_| \_|_|  |_|____/|_|  |_|___|_| \_|

Dev Environment Configuration as Code
```

# Blueprint

Define your development environment as a YAML manifest. Packages, dotfiles, services, environment variables — all in one file. Share it via URL. Reproduce it anywhere.

**[blueprint.dev](https://blueprint.dev)** — *coming soon*

---

## What It Does

Every time you set up a new machine, you rebuild from scratch. Install packages. Configure dotfiles. Set environment variables. Enable services. It takes hours and you always forget something.

Blueprint makes this declarative:

1. **Define** — Write a YAML manifest declaring your packages, dotfiles, env vars, and services
2. **Share** — Every blueprint gets a unique URL (`blueprint.dev/@synth/arch-hyprland`)
3. **Bootstrap** — Use the CLI to pull down a blueprint and set up a new machine in minutes

Think "dotfiles as a service" with a web interface and an API for automation.

## Sample Blueprint YAML

```yaml
name: "Arch Linux Hyprland Desktop"
description: "Full Arch Linux setup with Hyprland, Waybar, and dev tools"

packages:
  - name: hyprland
    category: pacman
  - name: waybar
    category: pacman
  - name: kitty
    category: pacman
  - name: neovim
    category: pacman
  - name: fuzzel
    category: pacman
  - name: mise
    category: aur
  - name: github-cli
    category: pacman

dotfiles:
  - name: Hyprland Config
    target_path: ~/.config/hypr/hyprland.conf
    content: |
      monitor=,preferred,auto,1
      $terminal = kitty
      $menu = fuzzel

environment:
  EDITOR: nvim
  BROWSER: firefox
  TERMINAL: kitty

services:
  - name: docker
    enabled: true
  - name: bluetooth
    enabled: true
```

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                      blueprint.dev                       │
│                                                          │
│  ┌──────────┐   ┌──────────────┐   ┌────────────────┐  │
│  │  Web UI  │   │  REST API    │   │  Share URLs    │  │
│  │  (ERB)   │   │  (/api/v1/*) │   │  (/@user/slug) │  │
│  └────┬─────┘   └──────┬───────┘   └───────┬────────┘  │
│       │                │                    │           │
│       └────────────────┼────────────────────┘           │
│                        │                                │
│              ┌─────────▼──────────┐                     │
│              │   Rails 8.1 App    │                     │
│              │                    │                     │
│              │  Blueprint         │                     │
│              │  ├─ Package        │                     │
│              │  ├─ Dotfile        │                     │
│              │  ├─ EnvVariable    │                     │
│              │  └─ Service        │                     │
│              │                    │                     │
│              │  User (Devise)     │                     │
│              └─────────┬──────────┘                     │
│                        │                                │
│              ┌─────────▼──────────┐                     │
│              │    PostgreSQL      │                     │
│              └────────────────────┘                     │
│                                                          │
└─────────────────────────────────────────────────────────┘

        ┌──────────────┐          ┌──────────────┐
        │  Blueprint   │          │    Shell     │
        │     CLI      │──────────▶   Script    │
        │  (gem)       │          │   Export    │
        └──────────────┘          └──────────────┘
              │                          │
              │     REST API             │
              └──────────────────────────┘
```

## Features

- **YAML Manifests** — Define your entire dev environment in a single YAML file
- **Web Editor** — Visual interface for creating and editing blueprints
- **Share URLs** — Every blueprint gets a unique, shareable URL
- **Shell Script Export** — Download any blueprint as an executable shell script
- **YAML Export** — Download the raw manifest for version control
- **REST API** — Full JSON API for CLI consumption and automation
- **User Accounts** — Devise authentication with confirmation and password recovery
- **Public/Private** — Blueprints can be public (shareable) or private
- **Slug-based URLs** — Clean URLs with FriendlyId (`/blueprints/arch-hyprland`)
- **Pagination** — Kaminari-powered pagination for blueprint listings
- **Search** — Full-text search across public blueprints

## Tech Stack

| Layer          | Technology           |
|----------------|----------------------|
| Framework      | Ruby on Rails 8.1    |
| Database       | PostgreSQL 16+       |
| Authentication | Devise               |
| Slugs          | FriendlyId           |
| Pagination     | Kaminari             |
| Frontend       | Hotwire (Turbo + Stimulus) |
| Asset Pipeline | Propshaft            |
| Testing        | RSpec + FactoryBot + Shoulda Matchers |
| Linting        | Rubocop (Rails Omakase) |
| CI/CD          | GitHub Actions       |
| Deployment     | Kamal + Docker       |

## Quick Start

### Prerequisites

- Ruby 3.2+
- PostgreSQL 14+
- Bundler

### Installation

```bash
git clone https://github.com/synthclaw/blueprint.git
cd blueprint
bundle install
bin/rails db:create db:migrate db:seed
bin/dev
```

Open [http://localhost:3000](http://localhost:3000).

### Environment Variables

| Variable                    | Default       | Description                      |
|-----------------------------|---------------|----------------------------------|
| `BLUEPRINT_DB_HOST`         | `localhost`   | PostgreSQL host                  |
| `BLUEPRINT_DB_PORT`         | `5432`        | PostgreSQL port                  |
| `BLUEPRINT_DB_USER`         | `blueprint`   | Database username                |
| `BLUEPRINT_DB_PASSWORD`     | _(empty)_     | Database password                |
| `BLUEPRINT_DATABASE_PASSWORD` | _(required)_ | Production DB password          |

Create a PostgreSQL role:

```bash
sudo -u postgres createuser -s blueprint
```

## Usage

### Web Interface

1. **Sign up** at `/users/sign_up`
2. **Create** a blueprint at `/blueprints/new`
3. **Edit** the YAML manifest with your environment definition
4. **Share** the URL with anyone

### API

The REST API is designed for CLI consumption and automation:

```bash
# List public blueprints
curl https://blueprint.dev/api/v1/blueprints

# Get a specific blueprint (JSON)
curl https://blueprint.dev/api/v1/blueprints/arch-hyprland

# Download as a shell script
curl -O https://blueprint.dev/api/v1/blueprints/arch-hyprland/download_script

# Download as YAML
curl -O https://blueprint.dev/api/v1/blueprints/arch-hyprland/download_yaml

# Create a blueprint (authenticated)
curl -X POST https://blueprint.dev/api/v1/blueprints \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"blueprint": {"name": "My Setup", "yaml_content": "..."}}'
```

### CLI (planned)

```bash
gem install blueprint-cli

# Apply a blueprint to the current machine
blueprint apply @synth/arch-hyprland

# Export as a shell script
blueprint export @synth/arch-hyprland --format shell > setup.sh

# Download the raw YAML
blueprint download @synth/arch-hyprland > my-blueprint.yml

# Create a blueprint from your current machine
blueprint init
```

### Shell Script Output

Blueprints can be exported as executable shell scripts:

```bash
#!/usr/bin/env bash
set -euo pipefail

# Blueprint: Arch Linux Hyprland Desktop
# Generated by blueprint.dev

# Packages
sudo pacman -S --noconfirm hyprland
sudo pacman -S --noconfirm waybar
paru -S --noconfirm mise

# Environment Variables
echo 'export EDITOR="nvim"' >> ~/.bashrc
echo 'export BROWSER="firefox"' >> ~/.bashrc

# Dotfiles
mkdir -p $(dirname ~/.config/hypr/hyprland.conf)
cat > ~/.config/hypr/hyprland.conf << 'DOTFILE_EOF'
monitor=,preferred,auto,1
$terminal = kitty
$menu = fuzzel
DOTFILE_EOF

# Services
sudo systemctl enable --now docker
```

## Testing

```bash
bundle exec rspec                    # Full test suite
bundle exec rspec spec/models/       # Model specs only
bundle exec rspec spec/requests/     # Request specs only
```

## Project Structure

```
blueprint/
├── app/
│   ├── controllers/
│   │   ├── application_controller.rb
│   │   ├── blueprints_controller.rb      # CRUD + share + duplicate
│   │   ├── pages_controller.rb           # Home, About
│   │   └── api/v1/
│   │       └── blueprints_controller.rb  # JSON API for CLI
│   ├── models/
│   │   ├── user.rb                       # Devise authentication
│   │   ├── blueprint.rb                  # Core model, YAML manifest
│   │   ├── package.rb                    # Packages (pacman, aur, brew, etc.)
│   │   ├── dotfile.rb                    # Dotfile configs
│   │   ├── environment_variable.rb       # Env vars
│   │   └── service.rb                    # System services
│   └── views/
│       ├── layouts/application.html.erb  # Dark theme layout
│       ├── blueprints/                   # CRUD views
│       └── pages/                        # Home, About
├── config/
│   ├── routes.rb                         # Full routes with API namespace
│   └── database.yml                      # PostgreSQL config
├── db/
│   ├── migrate/                          # All migrations
│   └── seeds.rb                          # 3 sample blueprints
├── spec/                                 # RSpec tests
├── .github/workflows/ci.yml              # GitHub Actions CI
├── CONTRIBUTING.md
├── LICENSE                               # Apache 2.0
└── README.md
```

## API Reference

### Authentication

| Method | Endpoint                | Description          |
|--------|-------------------------|----------------------|
| POST   | `/api/v1/login`         | Authenticate, get token |
| DELETE | `/api/v1/logout`        | Invalidate token     |

### Blueprints

| Method | Endpoint                                    | Description              |
|--------|---------------------------------------------|--------------------------|
| GET    | `/api/v1/blueprints`                        | List public blueprints   |
| GET    | `/api/v1/blueprints/:id`                    | Show blueprint (JSON)    |
| POST   | `/api/v1/blueprints`                        | Create blueprint         |
| PATCH  | `/api/v1/blueprints/:id`                    | Update blueprint         |
| DELETE | `/api/v1/blueprints/:id`                    | Delete blueprint         |
| GET    | `/api/v1/blueprints/:id/download_script`    | Download as shell script |
| GET    | `/api/v1/blueprints/:id/download_yaml`      | Download as YAML         |

## Package Categories

Blueprint supports multiple package managers:

| Category  | Package Manager          |
|-----------|--------------------------|
| `pacman`  | Arch Linux pacman        |
| `aur`     | Arch User Repository     |
| `brew`    | Homebrew (macOS/Linux)   |
| `pip`     | Python pip               |
| `npm`     | Node.js npm              |
| `gem`     | Ruby gems                |
| `cargo`   | Rust cargo               |
| `go`      | Go install               |
| `flatpak` | Flatpak                  |
| `snap`    | Snap                     |
| `custom`  | Custom/manual install    |

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines. PRs welcome.

## License

Apache License 2.0 — see [LICENSE](LICENSE).

---

Built with ♥ by [synthclaw](https://github.com/synthclaw) — *write the future in the present while preserving the past*
