class CardsController < ApplicationController

	def build_deck

		add_card_type("Captin")
		add_card_type("Duke")
		add_card_type("Contessa")
		add_card_type("Assassin")
		add_card_type("Ambassador")
		
		redirect_to(deal_cards_url(params[:id]))
	end

	private
	def add_card_type(string)
		3.times do
			card = Card.new(game_id: params[:id], is_in_deck: true, card_type: string)
			card.save
		end
	end
end