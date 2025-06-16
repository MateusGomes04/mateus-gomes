Rails.application.routes.draw do
  get  '/users/new', to: 'users#new', as: 'new_user'
  post '/users',     to: 'users#create', as: 'create_user'

  resources :companies do
    resources :users, only: [:index]
  end

  resources :tweets, only: [:index]

  resources :users, param: :username, only: [:index, :show] do
    resources :tweets, only: [:index]
  end

  get '/companies/:company_id/users_list', to: 'users#for_company', as: :company_users_list

  get  '/confirm_email', to: 'users#confirm', as: 'confirm_users'
  get '/confirmation_success', to: 'users#confirmation_success', as: :confirmation_success

  root "companies#index"
end
