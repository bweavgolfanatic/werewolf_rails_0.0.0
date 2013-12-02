class GamesController < ApplicationController
    http_basic_authenticate_with :name => "admin", :password => "password"
  # GET /games
  # GET /games.json
  def index
    @games = Game.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @games }
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @game = Game.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/new
  # GET /games/new.json
  def new
    @game = Game.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @game }
    end
  end

#  # GET /games/1/edit
#  def edit
#    @game = Game.find(params[:id])
#  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(params[:game])
    @game.game_state = "started"

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render json: @game, status: :created, location: @game }
      else
        format.html { render action: "new" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

#  # PUT /games/1
#  # PUT /games/1.json
#  def update
#    @game = Game.find(params[:id])
#
#    respond_to do |format|
#      if @game.update_attributes(params[:game])
#        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
#        format.json { head :no_content }
#      else
#        format.html { render action: "edit" }
#        format.json { render json: @game.errors, status: :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game = Game.find(params[:id])
    @game.destroy


    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end

  def restart_game
    @curgame = Game.find(Player.first.game_ID)
    @dayNightFreq = @curgame.dayNightFreq
    @kill_radius = @curgame.kill_radius
    @scent_radius = @curgame.scent_radius
    @curgame.game_state = "ended"
    @curgame.save
    @newGame = Game.create(:kill_radius => @kill_radius, :dayNightFreq => @dayNightFreq, :game_state => "started", :scent_radius => @scent_radius)
    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { render json: "{'message':'game restarted'}"}
    end

  end

  def playing_game
    if !Game.last.nil? and Game.last.game_state != "ended"
      respond_to do |format|
      format.json { render json: "{'message':'game active'}"}
      end
    else
      respond_to do |format|
      format.json { render json: "{'message':'no game active'}"}
      end
    end
  end

  def start_game
    @new_game = Game.new(:scent_radius => params[:scent_radius], :dayNightFreq => params[:dayNightFreq], :game_state => "started", :kill_radius => params[:kill_radius])
    if @new_game.save
      respond_to do |format|
        format.json {render json: "{'message':'game started'}"}
      end
    else
      respond_to do |format|
        format.json {render json: "{'message':'error--game not started'}"}
      end
    end
  end

  def night_or_day
    if (((Time.now - Game.find(@player.game_ID).created_at) % (120*Game.find(@player.game_ID).dayNightFreq)) < (Game.find(@player.game_ID).dayNightFreq*60))
      respond_to do |format|
        format.json {render json: "{'message':'day'}"}
      end
    else
      respond_to do |format|
        format.json {render json: "{'message':'night'}"}
      end
    end
  end

  def current_game
    if !Game.last.nil?
      if (Game.last.game_state == "started") and (Player.count != 0)
        respond_to do |format|
          format.json {render json: "{'message':'game'}"}
        end
      else
        respond_to do |format|
          format.json {render json: "{'message':'no game'}"}
        end
      end
     else
        respond_to do |format|
          format.json {render json: "{'message':'no game'}"}
        end
    end
  end
end
