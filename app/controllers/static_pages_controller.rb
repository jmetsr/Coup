class StaticPagesController < ApplicationController
  def root
  end
  def you_lose
  	render :you_lose
  end
  def you_win
  	render :you_win
  end
end