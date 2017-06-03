Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#index'

  resources :templates, only: [:index, :new, :create, :show] do
    post 'execute', on: :member
  end

  scope 'templates/:id' do
    resources :data_transfers, only: :index
    resources :origin_files, only: :show do
      resources :data_transfers, only: [:new, :create]
    end
  end

  resources :origin_files do
    resources :data_transfers, only: []
  end

  get 'contact' => 'contact_comments#new'
  post 'contact' => 'contact_comments#create'
end
