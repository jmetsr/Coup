class GamesController < ApplicationController

   def propose
    Pusher['test_channel'].trigger('my_event', {
          message: params.to_json
    })
    proposer = User.find(params["proposerId"])
    proposed = User.find(params["playerIds"])
    proposed.each do |proposed|
      proposal = GameProposal.new
      proposal.proposer = proposer 
      proposal.proposed = proposed
      proposal.active = true
      proposal.save
    end
      render :json => params
	end

	def accept
    @user = current_user
    @user.update_attributes(:accepted => true)
    @user.save

    all_accepted = current_user.potential_opponents.all? {|user| user.accepted}
    numb_players = current_user.potential_opponents.length
		Pusher['test_channel'].trigger('my_event', {
          message: "accepts #{current_user.id}, number_of_opponents = #{numb_players}, everyone accepted: #{all_accepted}"})
    render :json => params
	end

	def reject
		current_user.reject
		Pusher['test_channel'].trigger('my_event', {
          message: "rejects #{current_user.id}"})
    
    current_user.proposed_games.each do |proposal|
      proposal.active = false #since the propsal was rejected we label it inactive
      proposal.save
    end
    render :json => params
	end
  def create  
    puts 'game create action entered'
    @game = Game.new(number_of_players: params["_json"].to_i)
    @game.chat = ""
    @game.current_player_id = current_user.id
    @game.active_player_id = current_user.id
    @game.is_delt = false
    @game.is_built = true
    @game.log = "---#{@game.current_player.nickname}'s turn---."
    @game.save
    add_card_type("Captin", @game.id)
    add_card_type("Duke", @game.id)
    add_card_type("Contessa", @game.id)
    add_card_type("Assassin", @game.id)
    add_card_type("Ambassador", @game.id)
    @game.save
    puts "we are about to redirect to the deal cards method"

    render :json => @game
  end
  def show
    @game = Game.find(params[:id])
    render :show
  end
  def chat
    @game = Game.find(params[:id])
    info = "#{current_user.nickname}: #{params[:message]}."
    @game.chat += info
    Pusher["game_channel_number_" + @game.id.to_s ].trigger("game_data_for_#{@game.id}", {
      :message => "T: #{info}" })
    @game.save
    render :json => @game
  end

  private
  def add_card_type(string, id)
    3.times do
      card = Card.new(game_id: id, is_in_deck: true, card_type: string, is_dead: false)
      card.save
    end
  end
end