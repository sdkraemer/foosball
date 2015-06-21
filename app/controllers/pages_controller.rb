class PagesController < ApplicationController
layout "pages"
  def home
  	@players = Player.order("firstname")
  end
end
