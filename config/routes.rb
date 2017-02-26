Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#index'

  resources :users, only: :show

  resources :templates, only: [:new, :create, :show] do
    post 'execute', on: :member
  end

  scope 'templates/:id' do
    resources :data_transfers, only: :index
  end

  get 'contact' => 'contact_comments#new'
  post 'contact' => 'contact_comments#create'
end
