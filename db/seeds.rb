# Blueprint sample data

synth = User.create!(
  name: "synth",
  email: "synth@blueprint.dev",
  password: "password123",
  password_confirmation: "password123",
  confirmed_at: Time.current
)

alice = User.create!(
  name: "Alice",
  email: "alice@blueprint.dev",
  password: "password123",
  password_confirmation: "password123",
  confirmed_at: Time.current
)

arch_bp = Blueprint.create!(
  name: "Arch Linux Hyprland Desktop",
  description: "Full Arch Linux setup with Hyprland, Waybar, Kitty, and dev tools. The Omarchy-inspired configuration.",
  slug: "arch-hyprland",
  public: true,
  user: synth,
  yaml_content: <<~YAML
    name: "Arch Linux Hyprland Desktop"
    description: "Full Arch Linux setup with Hyprland, Waybar, Kitty, and dev tools"
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
  YAML
)

%w[hyprland waybar kitty neovim fuzzel github-cli].each do |pkg|
  arch_bp.packages.create!(name: pkg, category: "pacman")
end
arch_bp.packages.create!(name: "mise", category: "aur")

arch_bp.dotfiles.create!(
  name: "Hyprland Config",
  content: "monitor=,preferred,auto,1\n$terminal = kitty\n$menu = fuzzel\n",
  target_path: "/home/synth/.config/hypr/hyprland.conf"
)

{ "EDITOR" => "nvim", "BROWSER" => "firefox", "TERMINAL" => "kitty" }.each do |k, v|
  arch_bp.environment_variables.create!(key: k, value: v)
end

arch_bp.services.create!(name: "docker", enabled: true)

mac_bp = Blueprint.create!(
  name: "macOS Dev Workstation",
  description: "macOS development setup with Homebrew, Neovim, and essential CLI tools.",
  slug: "macos-dev",
  public: true,
  user: alice,
  yaml_content: <<~YAML
    name: "macOS Dev Workstation"
    description: "macOS development setup with Homebrew and essential CLI tools"
    packages:
      - name: neovim
        category: brew
      - name: tmux
        category: brew
      - name: ripgrep
        category: brew
      - name: fd
        category: brew
      - name: starship
        category: brew
    dotfiles:
      - name: Neovim Config
        target_path: ~/.config/nvim/init.lua
        content: |
          vim.opt.number = true
          vim.opt.relativenumber = true
    environment:
      EDITOR: nvim
    services: []
  YAML
)

%w[neovim tmux ripgrep fd starship].each do |pkg|
  mac_bp.packages.create!(name: pkg, category: "brew")
end

mac_bp.dotfiles.create!(
  name: "Neovim Config",
  content: "vim.opt.number = true\nvim.opt.relativenumber = true\n",
  target_path: "/home/alice/.config/nvim/init.lua"
)

mac_bp.environment_variables.create!(key: "EDITOR", value: "nvim")

ubuntu_bp = Blueprint.create!(
  name: "Ubuntu Server Baseline",
  description: "Minimal Ubuntu server setup with Docker, Nginx, and monitoring tools. Perfect for VPS bootstrapping.",
  slug: "ubuntu-server",
  public: true,
  user: synth,
  yaml_content: <<~YAML
    name: "Ubuntu Server Baseline"
    description: "Minimal Ubuntu server setup with Docker, Nginx, and monitoring"
    packages:
      - name: nginx
        category: custom
      - name: htop
        category: custom
      - name: tmux
        category: custom
      - name: ufw
        category: custom
    dotfiles: []
    environment:
      NODE_ENV: production
      RAILS_ENV: production
    services:
      - name: nginx
        enabled: true
      - name: docker
        enabled: true
      - name: ufw
        enabled: true
  YAML
)

%w[nginx htop tmux ufw].each do |pkg|
  ubuntu_bp.packages.create!(name: pkg, category: "custom")
end

{ "NODE_ENV" => "production", "RAILS_ENV" => "production" }.each do |k, v|
  ubuntu_bp.environment_variables.create!(key: k, value: v)
end

%w[nginx docker ufw].each do |svc|
  ubuntu_bp.services.create!(name: svc, enabled: true)
end

puts "Seeded #{User.count} users and #{Blueprint.count} blueprints."
