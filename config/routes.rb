Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    concern :paginatable do
      get "(page/:page)", action: :index, on: :collection, as: ""
    end
    root "static_pages#home"

    get "home", to: "static_pages#home"
    get "help", to: "static_pages#help"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"

    resources :users, concerns: :paginatable
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
  end
end
