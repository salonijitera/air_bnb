Rails.application.routes.draw do
  root to: 'static_pages#root'
  namespace :api, defaults: {format: :json} do
    resources :users, only: [:create, :index, :show] do
      get 'vip_status', on: :member
    end
    resources :listings, only: [:show, :index]
    resources :reviews, only: [:index]
    resources :bookings, only: [:index, :show, :create, :destroy, :update]
    resources :properties, only: [] do
      member do
        post 'book'
      end
    end
    resources :wish_lists, only: [:create] do
      member do
        post 'share'
      end
    end
    resource :session, only: [:create, :destroy]
    resources :notifications, only: [:index] do
      collection do
        get 'get_notifications'
      end
    end
    resources :wish_list_items, only: [] do
      collection do
        post 'add_property'
      end
    end
    post 'wish_lists/:wish_list_id/properties/:property_id', to: 'wish_list_items#add_property'
    resources :local_experiences, only: [:create]
    put '/localExperience/:id', to: 'local_experiences#update'
    post '/listings/premium', to: 'listings#create_premium_listing'
    resources :premium_listings, only: [:create]
    delete '/premium_listing/:id', to: 'premium_listings#destroy'
    post '/api/premium_listings', to: 'premium_listings#create'
  end
end
