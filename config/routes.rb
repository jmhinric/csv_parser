Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#index'

  resources :users, only: :show do
    resources :tasks, only: :show do
      post 'execute', on: :member
    end
  end
end
