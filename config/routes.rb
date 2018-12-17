Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :shares, only: [:index, :show] do
    resources :reviews, only: [ :new, :create ] do
      collection do
        post 'new_multiple'
        put 'create_multiple'
        post 'create_multiple'
      end
    end
  end
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
