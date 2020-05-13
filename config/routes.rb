Rails.application.routes.draw do

  resources :sessions, only: [:new, :create, :destroy]

  resources :todo_lists, except: [:index] do
    resources :todo_items, except: [:index]
  end

  get "/login" => "sessions#new", as: "login"
  delete "/logout" => "sessions#destroy", as: "logout"

  root to: "todo_lists#index"
end
