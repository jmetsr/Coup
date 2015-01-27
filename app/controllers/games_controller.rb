class GamesController < ApplicationController
	def propose
	  Pusher['test_channel'].trigger('my_event', {
          message: params.to_json
      })
      render :json => params
	end
end