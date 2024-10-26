Rails.application.routes.draw do
  # Test connection route
  get 'test_connection', to: 'application#test_connection' # Added test connection route

  
  # Client-side routes
  namespace :clients do
    root 'home#index'

    # Products routes (including mens and womens wear)
    resources :products, only: [:index, :show] do
      collection do
        get 'mens_wear', to: 'products#men', as: :mens_wear  # Define mens_wear_path here
        get 'womens_wear', to: 'products#women', as: :womens_wear # Define womens_wear_path here
      end
    end

    resources :complaints, only: [:new, :create] do
      get 'success', on: :collection, as: 'success'
    end

    resource :cart, only: [:show] do
      post 'add_item/:product_id', to: 'carts#add_item', as: 'add_item_to_cart'
      delete 'remove_item/:id', to: 'carts#remove_item', as: 'remove_item'
      patch 'update_quantity/:id', to: 'carts#update_quantity', as: 'update_quantity' 
      post 'confirm', to: 'carts#confirm', as: 'confirm'
    end

    resources :orders, only: [:new, :create, :show]
    resources :users, only: [:new, :create, :edit, :update, :show]
  end

  # Admin namespace routes
  namespace :admin do
    devise_for :admins, controllers: {
      sessions: 'admin/sessions'
    }

    resources :products do
      member do
        delete :remove_image
      end
    end

    resources :complaints, only: [:index] # For admin to view complaints
    resources :orders
    resources :users
  end

  # General product routes
  resources :products, only: [:index, :show, :create, :update, :destroy]

  # Devise routes for client users with custom controllers
  devise_for :users, path: 'users', controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # Root route set to client-side home index
  root "clients/home#index"

  #Root route set to admin-side home index
  #root "admin/products#index"
end
