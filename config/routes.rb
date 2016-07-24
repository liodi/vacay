Rails.application.routes.draw do
    root 'sessions#new'

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
    get 'main/who', :to => 'main#who'
    get 'main/what', :to => 'main#what'
    get 'main/when', :to => 'main#when'
    get 'main/where', :to => 'main#where'
    get 'main/why', :to => 'main#why'
    get 'main/how', :to => 'main#how'
end
