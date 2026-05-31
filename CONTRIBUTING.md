# Contributing to Blueprint

First off, thank you for considering contributing to Blueprint. It's people like you that make this tool useful for everyone.

## How to Contribute

### Reporting Bugs

Open a [GitHub Issue](https://github.com/synthshark/blueprint/issues/new) with:

- Clear title and description
- Steps to reproduce
- Expected vs actual behavior
- Your OS and Ruby version

### Suggesting Features

Open a GitHub Issue with the `enhancement` label. Describe the use case and why it would benefit Blueprint users.

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-feature`)
3. Write your changes with tests
4. Ensure all tests pass (`bundle exec rspec`)
5. Run the linter (`bin/rubocop`)
6. Commit with a clear message
7. Push and open a Pull Request

### Development Setup

```bash
git clone https://github.com/synthshark/blueprint.git
cd blueprint
bundle install
bin/rails db:create db:migrate db:seed
bin/dev
```

### Running Tests

```bash
bundle exec rspec                    # Full suite
bundle exec rspec spec/models/       # Models only
bundle exec rspec spec/requests/     # Request specs only
```

### Code Style

We follow the [Rails Omakase](https://github.com/rails/rubocop-rails-omakase) style guide. Run `bin/rubocop` before submitting.

### Commit Messages

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Keep the first line under 72 characters
- Reference issues when applicable ("Fixes #123")

## Project Structure

```
app/
  controllers/         # Web controllers + API namespace
  models/              # ActiveRecord models
  views/               # ERB templates
config/
  routes.rb            # URL routing
  database.yml         # PostgreSQL config
db/
  migrate/             # Schema migrations
  seeds.rb             # Sample data
spec/                  # RSpec tests
```

## License

By contributing, you agree that your contributions will be licensed under the Apache License 2.0.
