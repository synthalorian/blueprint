FactoryBot.define do
  factory :environment_variable do
    key { "EDITOR" }
    value { "nvim" }
    blueprint
  end
end
