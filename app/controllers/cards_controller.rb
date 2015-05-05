class CardsController < ApplicationController

	def build_deck

		add_card_type("Captin")
		add_card_type("Duke")
		
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