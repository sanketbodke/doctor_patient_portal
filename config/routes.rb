# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_for :users, controllers: {
        registrations: 'api/v1/registrations',
        sessions: 'api/v1/sessions'
      }

      resources :patients
      resources :users

      resources :doctors, only: [] do
        member do
          get :patients, to: 'doctors#show_patients'
        end
      end
    end
  end
end
