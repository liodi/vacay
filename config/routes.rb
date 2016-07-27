Rails.application.routes.draw do
    root 'sessions#new'

    #users
    get  'users/new', :to => 'users#new', :as => 'signup'
    get  'users',     :to => 'users#index'
    post 'users',     :to => 'users#create'

    #sessions
    get  'sessions/new',     :to => 'sessions#new',     :as => 'login'
    get  'sessions/destroy', :to => 'sessions#destroy', :as => 'logout'
    post 'sessions/create',  :to => 'sessions#create'

    #main
    get 'main',       :to => 'main#index', :as => 'home'
    get 'main/who',   :to => 'main#who',   :as => 'who'
    get 'main/what',  :to => 'main#what',  :as => 'what'
    get 'main/when',  :to => 'main#when',  :as => 'when'
    get 'main/where', :to => 'main#where', :as => 'where'
    get 'main/why',   :to => 'main#why',   :as => 'why'
    get 'main/how',   :to => 'main#how',   :as => 'how'

    post 'main/when', :to => 'main#when_postback'
end
