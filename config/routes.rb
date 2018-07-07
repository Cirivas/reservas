Rails.application.routes.draw do

  root 'reservations#index'

  devise_for :admins
  devise_for :users
  
  namespace :admin do
    resources :members
    resources :aeroplanes

    resources :files, only: [:index, :create] do
      collection do
        post :materials
      end
    end
  end

  resources :reservations
  resources :accounts, only: [:index, :create, :destroy]

  get :load_aeroplanes, controller: :reservations

end
