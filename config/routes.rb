Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#index'

  resources :templates, only: [:index, :new, :create, :show] do
    post 'execute', on: :member
    resources :data_transfers, only: [:index, :destroy]
    resources :origin_files, only: [:new, :create, :edit, :update] do
      resources :data_transfers, only: [:new, :create]
    end
  end

  get 'contact' => 'contact_comments#new'
  post 'contact' => 'contact_comments#create'
end
