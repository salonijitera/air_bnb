Rails.application.routes.draw do
  root to: 'static_pages#root'
  namespace :api, defaults: {format: :json} do
    resources :users, only: [:create, :index, :show] do
      post 'create_profile', on: :member
      put 'profile', to: 'users#update_profile', on: :member
    end
    # other routes...
  end
end
