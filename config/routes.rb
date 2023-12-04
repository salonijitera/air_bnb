Rails.application.routes.draw do
  root to: 'static_pages#root'
  namespace :api, defaults: {format: :json} do
    resources :users, only: [:create, :index, :show]
    resources :listings, only: [:show, :index]
    resources :reviews, only: [:index]
    resources :bookings, only: [:index, :show, :create, :destroy, :update]
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
  end
end
