class GamesController < ApplicationController

 	def index
 	end

 	def create
 		#todo: Need to whitelist parameters. Did this to get it working initially
 		@game = Game.new(game_params)
 		if @game.save
 			redirect_to edit_game_path(@game)
 		else
 			render :new
 		end
 	end

 	def new
 		#all of this will be moved to a service object or in the model. Refactored soon
 		@game = Game.new_game(params)
 		@player = Player.all.order(:firstname)
 	end

 	def edit
 		#@game = Game.includes(teams: [positions: [:goals]]).order("teams.color, positions.position_type desc").find(params[:id])

 		@game = Game.includes(teams: [positions: [:goals]]).find(params[:id])
 		@goals = @game.goals.order("created_at")
 		@redteam = @game.teams.red.first
 		@blueteam = @game.teams.blue.first
 		@positions = Position.position_types
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
 		#need to whitelist params
 		@game = Game.new_rematch_game(params)

 		@player = Player.all.order(:firstname)

 		#redirect_to new_game_path(@game)
 		render :action => :new
 	end

 	def player_dropdown
 		#selected_players = Player.find(player_params[id])
 		#available_players = Player.not(selected_players)
 		render partial: "games/player_dropdown", locals: {selected_players: []}
 	end

 	private
	  def game_params
	    params.require(:game).permit( :id, :teams_attributes => [:id, :color, :positions_attributes => [:id, :player_id, :position_type]])
	  end

	  def undo_params
	  	params.permit(:id)
	  end

	  def player_params
	  	params.require(:player).permit(:id)
	  end
end
