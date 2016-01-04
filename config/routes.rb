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
    member do
      post 'add_member/:user_id', to: 'rooms#add_member', as: :add_member
      delete 'remove_member/:user_id', to: 'rooms#remove_member', as: :remove_member
    end
  end

  # notification options
  resources :notifications
  post 'join_room_request/:id', to: 'notifications#join_room_request', as: :join_room_request
  get 'accpet_request/:id', to: 'notifications#accept_request', as: :accept_request
  get 'reject_request/:id', to: 'notifications#reject_request', as: :reject_request
end
