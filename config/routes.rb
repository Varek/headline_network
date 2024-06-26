# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  resources :members do
    match "search" => 'members/search#index', as: 'search', via: [:get, :post]
  end
  resources :friendships, only: [:new, :create, :destroy]
  match "/" => 'search#index', as: 'search', via: [:get, :post]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root "search#index"

end
