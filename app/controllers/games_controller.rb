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

 		#create the blue team
 		blueteam = @game.teams.build
 		blueteam.color = "blue"
 		4.times{ blueteam.positions.build }

 		blueteam.positions[0].type = :goalie
 		blueteam.positions[1].type = :defense
 		blueteam.positions[2].type = :midfield
 		blueteam.positions[3].type = :striker

 		#create the red team
 		redteam = @game.teams.build
 		redteam.color = "red"
 		4.times{ redteam.positions.build}

 		redteam.positions[0].type = :goalie
 		redteam.positions[1].type = :defense
 		redteam.positions[2].type = :midfield
 		redteam.positions[3].type = :striker

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
