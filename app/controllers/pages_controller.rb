class PagesController < ApplicationController
  def home
  	@players = Player.includes(:goals)
  end
end
