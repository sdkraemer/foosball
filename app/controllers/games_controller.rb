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
 		#all of this will be moved to a service object or in the model. Refactored soon
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

 		@player = Player.all.order(:firstname)
 	end

 	def edit
 		#@game = Game.includes(teams: [positions: [:goals]]).order("teams.color, positions.position_type desc").find(params[:id])

 		@game = Game.includes(teams: [positions: [:goals]]).find(params[:id])
 		@redteam = @game.teams.where(color: 1).first
 		@blueteam = @game.teams.where(color: 0).first
 	end

 	def show
 	end

 	def update
 	end

 	def destroy
 	end

 	def undo
 		game = Game.find_by_id(undo_params[:id])
 		game.undo_last_goal
 		redirect_to edit_game_path(game)
 	end

 	def recent_games
 		@games = Game.includes(:teams).order("created_at desc").first(10)
 	end

 	def rematch
 		#all of this will be moved to a service object or in the model. Refactored soon

 		lastgame = Game.includes(teams: [:positions]).order("positions.position_type desc").find_by_id(params[:id])
 		lastredteam = lastgame.teams.where(color: 1).first
 		lastblueteam = lastgame.teams.where(color: 0).first

 		@game = Game.new

 		#create the blue team
 		blueteam = @game.teams.build
 		blueteam.color = "blue"
 		4.times do |i|
 			position = blueteam.positions.build
 			position.position_type = i

 			#shift players from goalie to striker. look at last game played
 			current_player_id = lastredteam.positions[i].player_id
 			l = (i-1)%4
 			#puts "i:#{i} l:#{l} current_player_id:#{current_player_id}"
 			while l != i
 				puts "loop #{l}"
 				if current_player_id != lastredteam.positions[l].player_id
 					#puts "found different player id #{lastredteam.positions[l].player_id}"
 					position.player_id = lastredteam.positions[l].player_id
 					break
 				end
 				l = (l-1)%4
 			end
 		end

 		blueteam.positions.each do |position| 
 			puts "position_type: #{position.position_type} player_id: #{position.player_id}"
 		end

 		#create the red team
 		redteam = @game.teams.build
 		redteam.color = "red"

 		4.times do |i|
 			position = redteam.positions.build
 			position.position_type = i

 			#shift players from goalie to striker. look at last game played
 			current_player_id = lastblueteam.positions[i].player_id
 			l = (i-1)%4
 			#puts "i:#{i} l:#{l} current_player_id:#{current_player_id}"
 			while l != i
 				puts "loop #{l}"
 				if current_player_id != lastblueteam.positions[l].player_id
 					#puts "found different player id #{lastblueteam.positions[l].player_id}"
 					position.player_id = lastblueteam.positions[l].player_id
 					break
 				end
 				l = (l-1)%4
 			end
 		end

 		@player = Player.all.order(:firstname)

 		#redirect_to new_game_path(@game)
 		render :action => :new
 	end

 	private
	  def game_params
	    params.require(:game).permit( :id, :teams_attributes => [:id, :color, :positions_attributes => [:id, :player_id, :position_type]])
	  end

	  def undo_params
	  	params.permit(:id)
	  end
end
