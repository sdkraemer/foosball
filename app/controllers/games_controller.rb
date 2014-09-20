class GamesController < ApplicationController

 	def index
 	end

 	def create
 	end

 	def new
 		@game = Game.new()
 		2.times{ @game.teams.build }
 		@player = Player.all
 	end

 	def edit
 	end

 	def show
 	end

 	def update
 	end

 	def destroy
 	end
end
