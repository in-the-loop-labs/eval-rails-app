# Contributing to TaskFlow

Thank you for your interest in contributing! Please follow these guidelines to
keep the codebase consistent and maintainable.

## Getting Started

1. Fork the repository and create a feature branch from `main`.
2. Install dependencies with `bundle install`.
3. Set up the database: `bin/rails db:create db:migrate`.
4. Run the test suite to make sure everything passes: `bundle exec rspec`.

## Code Conventions

### Architecture

- **Service objects** for business logic. Place them in `app/services/`. Controllers
  should stay thin and delegate to services.
- **Pundit** for authorization. Every controller action that accesses a resource
  must call `authorize`. Policies live in `app/policies/`.
- **Serializers** for API responses. Place them in `app/serializers/`. Never
  render raw Active Record objects as JSON.

### Style

- Snake_case everywhere (variables, methods, file names).
- Two-space indentation for Ruby.
- Run `bundle exec rubocop` before submitting a PR. All offenses must be resolved.

### Database & Queries

- Use Active Record scopes and query methods exclusively. No raw SQL.
- Add database indexes for foreign keys and frequently queried columns.

### Testing

- All new models and controllers must have test coverage.
- Use RSpec and FactoryBot.
- Unit tests go in `spec/models/`, request tests in `spec/requests/`.
- Factories go in `spec/factories/`.

## Pull Request Process

1. Ensure all tests pass and rubocop reports no offenses.
2. Write a clear PR description explaining what changed and why.
3. Keep PRs focused — one feature or fix per PR.
4. Request a review from a maintainer.

## License

By contributing, you agree that your contributions will be licensed under the
MIT License.
