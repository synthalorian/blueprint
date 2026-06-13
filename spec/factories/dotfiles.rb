FactoryBot.define do
  factory :dotfile do
    name { "vimrc" }
    content { "set number\nset tabstop=2\n" }
    target_path { "/home/user/.vimrc" }
    blueprint
  end
end
