source "https://rubygems.org"

ruby ">= 3.2"

gem "rails", "~> 8.1.3"
gem "propshaft"
gem "pg", "~> 1.1"
gem "puma", ">= 8.0.2"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Database-backed adapters for cache, jobs, cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false
gem "image_processing", "~> 2.0"

# Authentication
gem "devise", "~> 5.0"

# Slugs
gem "friendly_id", "~> 5.5"

# Pagination
gem "kaminari", "~> 1.2"

# YAML parsing / validation
gem "safe_yaml", "~> 1.0"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "bundler-audit", require: false
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "rspec-rails", "~> 7.0"
  gem "factory_bot_rails", "~> 6.4"
  gem "shoulda-matchers", "~> 6.0"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara", "~> 3.39"
  gem "selenium-webdriver"
end
