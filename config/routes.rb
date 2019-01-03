Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :shares, only: [:index, :show] do
    resources :reviews, only: [ :new, :create ] do
      collection do
        post 'new_multiple'
        post 'create_multiple'
      end
    end
  end
  resources :companies, only: [:index, :new, :create] do
    resources :share_catalogs, only: [:index, :new, :create] do
    end
  end
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
