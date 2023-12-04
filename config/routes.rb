Rails.application.routes.draw do
  root to: 'static_pages#root'
  namespace :api, defaults: {format: :json} do
    resources :users, only: [:create, :index, :show]
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
    resources :notifications, only: [] do
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
  end
end
