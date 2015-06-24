class CardsController < ApplicationController

	def build_deck # we can delete this method now
		@game = Game.find(params[:id])
		puts "we are about to build the deck"
		add_card_type("Captin")
		add_card_type("Duke")
		add_card_type("Contessa")
		add_card_type("Assassin")
		add_card_type("Ambassador")
		puts "we built the deck"
		@game.is_built = true
		@game.save
    
		redirect_to(deal_cards_url(params[:id]))
	end

	private
	def add_card_type(string)
		3.times do
			card = Card.new(game_id: params[:id], is_in_deck: true, card_type: string, is_dead: false)
			card.save
		end
	end
end