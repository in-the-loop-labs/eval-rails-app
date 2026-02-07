# TaskFlow

A team task and project tracker built with Ruby on Rails. TaskFlow helps teams
organize work into projects, assign tasks, and track progress through
customizable workflows.

## Tech Stack

- **Ruby** 3.2
- **Rails** 7.1
- **Database** PostgreSQL
- **Authentication** Devise
- **Authorization** Pundit
- **Background Jobs** Sidekiq
- **Testing** RSpec, FactoryBot

## Setup

### Prerequisites

- Ruby 3.2+
- PostgreSQL 14+
- Redis (for Sidekiq)
- Bundler

### Installation

```bash
git clone <repo-url>
cd taskflow
bundle install
bin/rails db:create db:migrate
bin/rails db:seed  # optional: load sample data
```

### Running the App

```bash
bin/rails server
```

Visit [http://localhost:3000](http://localhost:3000).

### Running Tests

```bash
bundle exec rspec
```

### Linting

```bash
bundle exec rubocop
```

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
