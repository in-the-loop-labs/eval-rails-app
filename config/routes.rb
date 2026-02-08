# SPDX-License-Identifier: MIT
# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  # Projects
  get "projects/archived", to: "projects#archived", as: :archived_projects
  resources :projects do
    resources :tasks
  end

  # API endpoints
  namespace :api do
    namespace :v1 do
      resources :projects, only: [] do
        resources :tasks
      end
    end
  end

  # Health check endpoint for uptime monitoring
  get "up" => "rails/health#show", as: :rails_health_check

  # Root route
  root "pages#home"
end
