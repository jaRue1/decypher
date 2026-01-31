# frozen_string_literal: true

Rails.application.routes.draw do
  get 'registrations/new'
  get 'registrations/create'
  get 'sign_up', to: 'registrations#new'
  post 'sign_up', to: 'registrations#create'
  get 'dashboard/index'
  resource :session
  resources :passwords, param: :token
  resources :domains, only: %i[index show], param: :slug do
    member do
      get :setup
      post :complete_setup
      delete :reset
      # Operator wizard routes
      get :setup_wizard
      post :save_step
      post :generate_plan
      get :preview_plan
      post :confirm_plan
      delete :reset_setup
    end
  end
  resources :missions do
    member do
      post :commence
      post :abort_mission
      post :generate_next
      post :generate_habits
    end
    resources :objectives, only: %i[create edit update destroy] do
      member do
        post :toggle
        post :start
      end
    end
  end
  resources :goals do
    member do
      post :complete
      post :generate_missions
    end
  end
  resources :habits do
    member do
      post :toggle
      post :archive
    end
  end
  resources :daily_entries, param: :date, only: %i[index show update]
  resource :profile, only: [:show, :edit, :update]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root 'dashboard#index'
end
