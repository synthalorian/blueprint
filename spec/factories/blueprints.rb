FactoryBot.define do
  factory :blueprint do
    name { "Test Blueprint" }
    description { "A blueprint for testing" }
    yaml_content do
      <<~YAML
        name: "Test Blueprint"
        description: "A blueprint for testing"
        packages: []
        dotfiles: []
        environment: {}
        services: []
      YAML
    end
    slug { "test-blueprint" }
    public { true }
    user

    trait :private do
      public { false }
    end

    trait :with_packages do
      after(:create) do |blueprint|
        create_list(:package, 3, blueprint: blueprint)
      end
    end

    trait :with_dotfiles do
      after(:create) do |blueprint|
        create_list(:dotfile, 2, blueprint: blueprint)
      end
    end
  end
end
