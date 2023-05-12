Rails.application.routes.draw do
  get "/products", to: "products#index" 
  get "/products/:id", to: "products#show"
  post "/products/", to: "products#create"
  patch "/products/:id", to: "products#update"
  delete "/products/:id", to: "products#destroy"
  get "/users", to: "users#index"
  get "/users/:id", to: "users#show"
  post "/users/", to: "users#create"
  delete "/users/:id", to: "users#destroy" 
  post '/authentications/login', to: 'authentications#login'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
