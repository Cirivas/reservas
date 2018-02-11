Rails.application.routes.draw do
  devise_for :admins
  devise_for :users
  
  namespace :admin do
    resources :members
    resources :aeroplanes
  end

  resources :reservations

  get :load_aeroplanes, controller: :reservations

end
