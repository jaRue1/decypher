# Development Commands

  ## Starting the Server

  ### `bin/dev` (recommended for development)
  Runs multiple processes defined in `Procfile.dev`:
  - Rails server
  - Tailwind CSS watcher

  Use this when working on the app - CSS changes will auto-compile.

  ### `rails server`
  Only runs the Rails app. No CSS watcher.
  Use this if you're not changing any styles.

  ## Procfile.dev

  web: bin/rails server
  css: bin/rails tailwindcss:watch

  ## Other Useful Commands

  ```bash
  rails console          # interactive Ruby with app loaded
  rails dbconsole        # connect to database directly
  rails routes           # show all routes
  rails db:migrate       # run pending migrations
  rails db:seed          # run db/seeds.rb
  rails db:reset         # drop, create, migrate, seed

  Generators

  rails generate model Name field:type
  rails generate controller Name action1 action2
  rails generate migration AddFieldToTable field:type
  rails destroy model Name   # undo a generate