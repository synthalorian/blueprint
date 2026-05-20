FactoryBot.define do
  factory :package do
    name { "neovim" }
    version { "0.9.0" }
    category { "pacman" }
    blueprint
  end
end
