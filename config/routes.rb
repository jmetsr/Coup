Rails.application.routes.draw do
  
  root to: 'static_pages#root'

  get 'static_pages/you_lose' => 'static_pages#you_lose', :as => 'you_lose'
  get 'static_pages/you_win' => 'static_pages#you_win', :as => 'you_win'
  resources :users, defaults: {format: :json}

  post 'games/propose', :to => 'games#propose'
  get 'games/accept' => 'games#accept', :as => 'accept'
  get 'games/reject' => 'games#reject', :as => 'reject'
  post 'games/chat/:id' => 'games#chat', :as => 'chat'
  
  resources :games, :except => :show, defaults: {format: :json}
  resources :games, :only => :show

  get 'cards/build_deck/:id' => 'cards#build_deck', :as => 'build_deck' 

  get 'turn_logics/end_turn/:id' => 'turn_logics#end_turn', :as => 'end_turn'
  get 'turn_logics/take_income/:id' => 'turn_logics#take_income', :as => 'take_income'
  get 'turn_logics/take_foreign_aid/:id' => 'turn_logics#take_foreign_aid', :as => 'take_foreign_aid'
  get 'turn_logics/tax/:id' => 'turn_logics#tax', :as => 'tax'
  post 'turn_logics/steal/:id' => 'turn_logics#steal', :as => 'steal'
  
  #even though this adds data to data base it's a get, not a post                               
  #because there is no data that we have to send - as it always adds
  #the same stuff to the database each time its called
  get 'turn_logics/deal_cards/:id' => 'turn_logics#deal_cards', :as => 'deal_cards'
  post 'turn_logics/coup/:id' => 'turn_logics#coup', :as => 'coup'
  post 'turn_logics/assassin/:id' => 'turn_logics#assassin', :as => 'assassin'
  post 'turn_logics/block_action/:id' => 'turn_logics#block', :as => 'block'
  get 'turn_logics/resolve_theft/:id' => 'turn_logics#resolve_theft', :as => 'resolve_theft'
  get 'turn_logics/resolve_foreign_aid/:id' => 'turn_logics#resolve_foreign_aid', :as => 'resolve_foreign_aid'
  post 'turn_logics/challenge/:id' =>'turn_logics#challenge', :as => 'challenge' 
  post 'turn_logics/kill/:id' => 'turn_logics#kill', :as => 'kill'

  get 'turn_logics/exchange/:id' => 'turn_logics#exchange', :as => 'exchange'
  get 'turn_logics/resolve_exchange/:id' => 'turn_logics#resolve_exchange', :as => 'resolve_exchange'

  get 'turn_logics/resolve_block/:id' => 'turn_logics#resolve_block', :as => 'resolve_block'

  get 'turn_logics/resolve_tax/:id' => 'turn_logics#resolve_tax', :as => 'resolve_tax'



end
