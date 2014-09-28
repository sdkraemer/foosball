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

 			#@game.teams.build(game_params[:teams_attributes][0])

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
 		blueteam.positions[3].position_type = :striker
 		blueteam.positions[2].position_type = :midfield
 		blueteam.positions[1].position_type = :defense
 		blueteam.positions[0].position_type = :goalie

 		#create the red team
 		redteam = @game.teams.build
 		redteam.color = "red"
 		4.times{ redteam.positions.build}

 		redteam.positions[3].position_type = :striker
 		redteam.positions[2].position_type = :midfield
 		redteam.positions[1].position_type = :defense
 		redteam.positions[0].position_type = :goalie

 		@player = Player.all
 	end

 	def edit
 		@game = Game.includes(teams: [:positions]).find(params[:id])
 	end

 	def show
 	end

 	def update
 	end

 	def destroy
 	end

 	private
  def game_params
    params.require(:game).permit( :id, :teams_attributes => [:id, :color, :positions_attributes => [:id, :player_id, :position_type]])
  end
end
