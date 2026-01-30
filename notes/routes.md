# Rails Routing

  ## How a Request Flows

  Browser visits localhost:3000/
          ↓
  config/routes.rb → finds matching route
          ↓
  controller#action → runs the method
          ↓
  app/views/controller/action.html.erb → renders HTML
          ↓
  Browser sees the page

  ## Route Syntax

  ```ruby
  # Root route (homepage)
  root "dashboard#index"

  # Basic routes
  get "/missions", to: "missions#index"
  get "/missions/:id", to: "missions#show"
  post "/missions", to: "missions#create"

  # RESTful resource (generates all 7 routes)
  resources :missions
  # Equivalent to:
  #   GET    /missions          → missions#index
  #   GET    /missions/new      → missions#new
  #   POST   /missions          → missions#create
  #   GET    /missions/:id      → missions#show
  #   GET    /missions/:id/edit → missions#edit
  #   PATCH  /missions/:id      → missions#update
  #   DELETE /missions/:id      → missions#destroy

  # Nested resources
  resources :missions do
    resources :tasks
  end
  # Creates: /missions/:mission_id/tasks/:id

  Naming Convention
  ┌────────────────────────┬─────────────────────┬────────┬────────────────────────────────┐
  │         Route          │     Controller      │ Action │              View              │
  ├────────────────────────┼─────────────────────┼────────┼────────────────────────────────┤
  │ root "dashboard#index" │ DashboardController │ index  │ views/dashboard/index.html.erb │
  ├────────────────────────┼─────────────────────┼────────┼────────────────────────────────┤
  │ get "/missions/:id"    │ MissionsController  │ show   │ views/missions/show.html.erb   │
  └────────────────────────┴─────────────────────┴────────┴────────────────────────────────┘
  Useful Commands

  rails routes              # show all routes
  rails routes -c missions  # show routes for missions controller only
  rails routes -g user      # grep routes containing "user"