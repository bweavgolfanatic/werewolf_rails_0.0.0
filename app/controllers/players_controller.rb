class PlayersController < ApplicationController
  # GET /players
  # GET /players.json
 
  def index
    
    @players = Player.all
    puts @players

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @players }
    end
  end

  def 

#  # GET /players/1
#  # GET /players/1.json
#  def show
#    @player = Player.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.json { render json: @player }
#    end
#  end

#  # GET /players/new
#  # GET /players/new.json
#  def new
#    @player = Player.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.json { render json: @player }
#    end
#  end

#  # GET /players/1/edit
#  def edit
#    @player = Player.find(params[:id])
#  end

  # POST /players
  # POST /players.json
#  def create
#    @player = Player.new(params[:player])
#
#    respond_to do |format|
#      if @player.save
#        format.html { redirect_to @player, notice: 'Player was successfully created.' }
#        format.json { render json: @player, status: :created, location: @player }
#      else
#        format.html { render action: "new" }
#        format.json { render json: @player.errors, status: :unprocessable_entity }
#      end
#    end
#  end

#  # PUT /players/1
#  # PUT /players/1.json
#  def update
#    @player = Player.find(params[:id])
#
#    respond_to do |format|
#      if @player.update_attributes(params[:player])
#        format.html { redirect_to @player, notice: 'Player was successfully updated.' }
#        format.json { head :no_content }
#      else
#        format.html { render action: "edit" }
#        format.json { render json: @player.errors, status: :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /players/1
  # DELETE /players/1.json
#  def destroy
#    @player = Player.find(params[:id])
#    @player.destroy
#
#    respond_to do |format|
#      format.html { redirect_to players_url }
#      format.json { head :no_content }
#    end
#  end



  def kill_player
    #puts params[:nickname]
    @player = Player.find_by_user_id( current_user.id)
    @victim = Player.find_by_nickname(params[:nickname])
    if (@player.kill_made == "false") and (@player.alignment == "werewolf") and (((Time.now - Game.find(@player.game_ID).created_at) % (120*Game.find(@player.game_ID).dayNightFreq)) > (Game.find(@player.game_ID).dayNightFreq*60))
      if ((@victim.lat - @player.lat).abs + (@victim.lng - @player.lng).abs < Game.find(@player.game_ID).kill_radius) and (@victim.alignment == "townsperson") and (@victim.id != @player.id) and (@player.isDead == "false") and (@victim.isDead == "false")
        @victim.isDead = "true"
        @victim.save
        @player.score += 100
        @player.made_kill = "true"
        @player.save
        @new_kill = Kill.new(:killerID => @player.user_id, :victimID => @victim.user_id, :lat => @victim.lat, :lng => @victim.lng)
        @new_kill.save
        respond_to do |format|
          format.json { render json: "{'message':'kill successful'}"}
        end
        
      else
        respond_to do |format|
          format.json { render json: "{'message':'kill unsuccessful'}"}
        end
      end
    else
      respond_to do |format|
        format.json { render json: "{'message':'kill unsuccessful'}"}
      end

    end
  end

  def report_position
    @player = Player.find_by_user_id(current_user.id)
    @player.lat = params[:lat]
    @player.lng = params[:lng]
    @player.save
    message = Hash.new
    Player.all.each do |player|
      if @player.alignment != player.alignment
        if (player.user_id != @player.user_id) and ((player.lat - @player.lat).abs + (player.lng - @player.lng).abs < Game.find(@player.game_ID).scent_radius)
          message['message']='someone nearby'
        end
      end
    end
    respond_to do |format|
      format.json {render json: message}
    end
  end

  def vote_for_player
    @player = Player.find_by_user_id(current_user.id)
    @voted = Player.find_by_nickname(params[:nickname])
    puts current_user.id
    puts @player.nickname
    if (@player.isDead == "false") and (@player.vote_cast == "false") and ((Time.now - Game.find(@player.game_ID).created_at) > Game.find(@player.game_ID).dayNightFreq*60) and (((Time.now - Game.find(@player.game_ID).created_at) % (120*Game.find(@player.game_ID).dayNightFreq)) < (Game.find(@player.game_ID).dayNightFreq*60))
      if @voted.isDead == "false"
        @voted.votes_for += 1
        @voted.save
        @player.vote_cast = "true"
#        if @voted.alignment == "werewolf"
#          @player.score+=25
#        end
        @player.save
        respond_to do |format|
          format.json { render json: "{'message':'vote successful'}"}
        end
      else
        respond_to do |format|
          format.json { render json: "{'message':'vote unsuccessful'}"}
        end
      end
    else
      respond_to do |format|
        format.json { render json: "{'message':'vote unsuccessful'}"}
      end
    end
  end

  def players_alive
    alive = Hash.new
    Player.all.each do |player|
      if player.isDead == "false"
        alive[player.nickname] = player.user_id
      end
    end
    respond_to do |format|
      format.json {render json: alive}
    end
  end


  def types_left
    types = Hash.new
    types['townsperson'] = 0
    types['werewolf'] = 0
    Player.all.each do |player|
      if player.isDead == "false"
        puts player.alignment
        types[player.alignment] = types[player.alignment] + 1
      end
    end
    respond_to do |format|
        format.json {render json: types}
    end
  end

  def get_possible_kills
    poss_kills = Hash.new
    @players = Player.all
    @me = Player.find_by_user_id(current_user.id)
    i = 0
    if !@me.nil?
      if (@me.kill_made == "false") and (@me.alignment == "werewolf") and (@me.isDead == "false") and (((Time.now - Game.find(@me.game_ID).created_at) % (120*Game.find(@me.game_ID).dayNightFreq)) > (Game.find(@me.game_ID).dayNightFreq*60))
        while i < @players.length
          if (@players[i].user_id != @me.user_id) and (@players[i].alignment == "townsperson") and (@players[i].isDead == "false")
            if (@players[i].lat - @me.lat).abs + (@players[i].lng - @me.lng).abs < Game.find(@me.game_ID).kill_radius
              poss_kills[i] = @players[i].nickname
            end
          end
        end
      end
    else
      poss_kills[0]="No Current Game"

    end
    respond_to do |format|
        format.json {render json: poss_kills}
    end

  end


  def get_votables
    poss_votes = Hash.new
    @players = Player.all
    @me = Player.find_by_user_id(current_user.id)
    i = 0
    if !@me.nil?
      if (@me.isDead == "false") and (@me.vote_cast == "false") and ((Time.now - Game.find(@me.game_ID).created_at) > Game.find(@me.game_ID).dayNightFreq*60)  and (((Time.now - Game.find(@me.game_ID).created_at) % (120*Game.find(@me.game_ID).dayNightFreq)) < (Game.find(@me.game_ID).dayNightFreq*60))
        if @me.alignment == "townsperson"
          while i < @players.length
            if (@players[i] != @me) and (@players[i].isDead != "true")
              poss_votes[i] = @players[i].nickname
            end
            i+=1
          end
        end
      end
    else
      poss_votes[0] = "No Current Game"
    end
    puts poss_votes
    respond_to do |format|
      format.json {render json: poss_votes}
    end

  end







#  def players_list_vote
#    players = Hash.new
#    Player.all.each do |player|
#      if player.user_id != current_user.id
#        subplayer = Hash.new
#        subplayer["nickname"] = player.nickname
#        subplayer["life"] = player.isDead
#        players[]
#      end
#    end
#  end





end
