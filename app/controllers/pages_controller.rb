class PagesController < ApplicationController
layout "pages"
  def home
  	@players = Player.includes(:goals).order("firstname")
  end
end
