Rails.application.routes.draw do
  
  root to: 'static_pages#root'
  resources :users, defaults: {format: :json}
  post 'games/propose', :to => 'games#propose'
  get 'games/accept' => 'games#accept', :as => 'accept'
  get 'games/reject' => 'games#reject', :as => 'reject'
  resources :games, :except => :show, defaults: {format: :json}
  resources :games, :only => :show
  get 'games/end_turn/:id' => 'games#end_turn', :as => 'end_turn'
  get 'games/take_income/:id' => 'games#take_income', :as => 'take_income'
  get 'games/take_foreign_aid/:id' => 'games#take_foreign_aid', :as => 'take_foreign_aid'
  get 'games/tax/:id' => 'games#tax', :as => 'tax'
  post 'games/steal/:id' => 'games#steal', :as => 'steal'
  get 'cards/build_deck/:id' => 'cards#build_deck', :as => 'build_deck' 
  #even though this adds data to data base it's a get, not a post                               
  #because there is no data that we have to send - as it always adds
  #the same stuff to the database each time its called
  get 'games/deal_cards/:id' => 'games#deal_cards', :as => 'deal_cards'
  post 'games/react_to_coup/:id' => 'games#react_to_coup', :as => 'react_to_coup'
  post 'games/coup/:id' => 'games#coup', :as => 'coup'
  post 'games/react_to_assassin/:id' => 'games#react_to_assassin', :as => 'react_to_assassin'
  post 'games/assassin/:id' => 'games#assassin', :as => 'assassin'
  get 'games/claim_contessa/:id' => 'games#claim_contessa', :as => 'claim_contessa'
end
