Rails.application.routes.draw do
  root to: 'static_pages#root'
  namespace :api, defaults: {format: :json} do
    resources :users, only: [:create, :index, :show]
    resources :listings, only: [:show, :index]
    resources :reviews, only: [:index]
    resources :bookings, only: [:index, :show, :create, :destroy, :update]
    resources :wish_lists, only: [:create]
    resource :session, only: [:create, :destroy]
  end
end
