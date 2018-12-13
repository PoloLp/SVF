Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :shares, only: [:index, :show] do
    collection do
      post 'edit_individual'
      put 'update_edit_individual'
    end
    resources :reviews, only: [ :new, :create ]
  end
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
