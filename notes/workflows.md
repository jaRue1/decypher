 Rails Development Workflow

  ## Incremental Approach (Learning)

  Build each piece to understand it:

  1. Model + Migration   → rails generate model Name field:type
  2. Migrate             → rails db:migrate
  3. Route               → add to config/routes.rb
  4. Controller          → rails generate controller Name action
  5. Update controller   → add logic, set instance variables
  6. View                → create/edit .html.erb files

  ## Scaffold Approach (Speed)

  Generate everything at once:

  ```bash
  rails generate scaffold Post title:string body:text published:boolean
  rails db:migrate

  Creates: model, migration, controller (all 7 actions), views, routes, tests.

  Then customize the generated code.

  When to Use Each
  ┌─────────────┬─────────────────────────────────────────────┐
  │  Approach   │                  Use When                   │
  ├─────────────┼─────────────────────────────────────────────┤
  │ Incremental │ Learning, complex/custom features           │
  ├─────────────┼─────────────────────────────────────────────┤
  │ Scaffold    │ Standard CRUD, prototyping, tight deadlines │
  └─────────────┴─────────────────────────────────────────────┘
  The Pattern to Remember

  Request flow:
  URL → Route → Controller → Model (optional) → View → Response

  Building flow:
  Data first (model) → Access point (route) → Logic (controller) → Display (view)

  Common Gotchas

  - Forgot to run rails db:migrate after generating model
  - Controller sets @variable, view uses @variable - names must match
  - Route must point to correct controller#action
  - Use bin/dev not rails server when working with Tailwind