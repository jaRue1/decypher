Rails.application.routes.draw do
  get "registrations/new"
  get "registrations/create"
  get "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"
  get "dashboard/index"
  resource :session
  resources :passwords, param: :token
  resources :domains, only: [:index, :show], param: :slug do
    member do
      get :setup
      post :complete_setup
    end
  end
  resources :missions do
    member do
      post :commence
      post :abort_mission
    end
    resources :objectives, only: [:create, :update, :destroy] do
      member do
        post :toggle
        post :start
      end
    end
  end
  resources :goals
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "dashboard#index"
end
