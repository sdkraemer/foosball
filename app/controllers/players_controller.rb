class PlayersController < ApplicationController
  def new
  	@player = Player.new
  end

	def index
		@player = Player.new
		@players = Player.all
	end

  def create
  	@player = Player.new(player_params)
 
  	#if @player.save
		#	format.html { redirect_to edit_player_path(@player), notice: 'Player created successfully.' }
		#	format.json { render json: @player }
		#	format.js { render action: "show", status: :created, location: @player}
		#else
		#	format.html { redirect_to edit_player_path(@player), notice: 'Player created successfully.' }
		#end

		if @player.save
			redirect_to edit_player_path(@player)
		else
			render :new
		end
	end

	def update
		@player = Player.find(params[:id])
		if @player.update(player_params)
			redirect_to edit_player_path(@player)
		else
			render edit_player_path(@player)
		end	
	end

	#need to move this logic into a helper or module to store statistics
  def edit
    @player = Player.find(params[:id])
    @last_ten_games = GameDecorator.decorate_collection( Game.completed.distinct.joins(:teams).joins(:positions).where(:positions => {player_id: @player.id}).order(created_at: :desc).limit(10) )
    last_ten_game_ids = @last_ten_games.map(&:id)

    @loser_ten = Team.distinct.loser.joins(:positions).where(:positions => {player_id: @player.id}, :teams => {game_id: last_ten_game_ids}).count
    @winner_ten = Team.distinct.winner.joins(:positions).where(:positions => {player_id: @player.id}, :teams => {game_id: last_ten_game_ids}).count
  end

  def show
  	@player = Player.find(params[:id])
  end

  private
	  def player_params
	    params.require(:player).permit(:username, :firstname, :lastname)
	  end

  
end
