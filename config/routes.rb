Rails.application.routes.draw do
  root :to => "reviews#index"
  resources :reviews do
    collection do
      get 'login'
      get 'register'
      post 'newuser'
      post 'validate'
      post 'search'
      post 'comment'
    end
  end
end
