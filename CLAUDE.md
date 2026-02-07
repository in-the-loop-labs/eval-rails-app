# TaskFlow — Project Conventions

## Architecture

- **Service objects** for business logic (`app/services/`). Controllers should
  delegate to services rather than containing domain logic directly.
- **Pundit** for authorization. Every controller action that accesses a resource
  must authorize it. Policies live in `app/policies/`.
- **Serializers** for API responses (`app/serializers/`). Never render raw
  Active Record objects in JSON responses.

## Code Style

- Snake_case everywhere (variables, methods, file names).
- Two-space indentation for Ruby files.
- Follow the project `.rubocop.yml` configuration.

## Database & Queries

- All queries must use Active Record scopes or query methods. No raw SQL
  (`execute`, `find_by_sql`, or string-interpolated `where` clauses).
- Add database indexes for all foreign keys and commonly queried columns.

## Testing

- Test coverage is required for all new models and controllers.
- Use RSpec and FactoryBot.
- Place unit tests in `spec/models/`, request tests in `spec/requests/`.
- Factories go in `spec/factories/`.

## General

- Keep controllers thin — push logic into models or service objects.
- Prefer explicit over implicit (e.g., name scopes clearly, avoid default_scope).
- Add SPDX license headers (`SPDX-License-Identifier: MIT`) to source files.
