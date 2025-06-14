Rails.application.routes.draw do
  resources :companies, only: [] do
    resources :users, only: [:index]
  end

  resources :tweets, only: [:index]

  resources :users, param: :username, only: [:index, :show] do
    resources :tweets, only: [:index]
  end

  get  '/signup', to: 'users#new', as: 'signup'
  post '/signup', to: 'users#create'

  get  '/confirm_email', to: 'users#confirm', as: 'confirm_users'
  get '/confirmation_success', to: 'users#confirmation_success', as: :confirmation_success

  root "users#new"
end
