Rails.application.routes.draw do

  root 'reservations#index'

  devise_for :admins
  devise_for :users
  
  namespace :admin do
    resources :members
    resources :aeroplanes
  end

  resources :reservations
  resources :accounts, only: [:index, :create]

  get :load_aeroplanes, controller: :reservations

end
