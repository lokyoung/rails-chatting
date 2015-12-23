Rails.application.routes.draw do
  get 'sessions/new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'

  root 'rooms#index'
  get 'sign_up' => 'users#new'
  get 'sign_in' => 'sessions#new'
  post 'sign_in' => 'sessions#create'
  delete 'log_out' => 'sessions#destroy'

  resources :users

  resources :rooms do
    resources :messages
  end
end
