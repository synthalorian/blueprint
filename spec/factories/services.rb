FactoryBot.define do
  factory :service do
    name { "docker" }
    enabled { true }
    blueprint
  end
end
