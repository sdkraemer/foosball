class GamesController < ApplicationController

 	def index
 	end

 	def create
 		#todo: Need to whitelist parameters. Did this to get it working initially
 		@game = Game.new(game_params)
 		if @game.save
 			#Rails.logger.debug("My object: #{params[:game][:teams]}")
 			#params[:game][:teams].each do |teams_attributes|
 			#	Rails.logger.debug("My object: #{teams_attributes}")
 			#	@game.teams.build(teams_attributes)
 			#end

 			redirect_to edit_game_path(@game)
 		else
 			render :new
 		end
 	end

 	def new
 		@game = Game.new
 		blueteam = @game.teams.build
 		blueteam.color = "blue"
 		redteam = @game.teams.build
 		redteam.color = "red"
 		#@game.teams.build
 		#@game.teams.build
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

 	private
  def game_params
    params.require(:game).permit( :id, :teams_attributes => [:id, :color])
  end
end
