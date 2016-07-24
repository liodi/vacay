Rails.application.routes.draw do
    root 'main#index'

    #users
    get 'users', :to => 'users#index'
    get 'users/new', :to => 'users#new', :as => 'signup'
    post 'users', :to => 'users#create'

    #sessions
    get 'sessions/new', :to => 'sessions#new', :as => 'login'
    post 'sessions/create', :to => 'sessions#create'
    get 'sessions/destroy', :to => 'sessions#destroy', :as => 'logout'

    #main
    get 'main', :to => 'main#index', :as => 'home'
    get 'who', :to => 'main#who'
    get 'what', :to => 'main#what'
    get 'when', :to => 'main#when'
    get 'where', :to => 'main#where'
    get 'why', :to => 'main#why'
    get 'how', :to => 'main#how'
end
