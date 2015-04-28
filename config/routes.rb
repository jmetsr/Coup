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
end
