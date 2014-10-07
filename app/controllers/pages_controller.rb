class PagesController < ApplicationController
  def home
  	@players = Player.includes(:goals).order("firstname")
  end
end
