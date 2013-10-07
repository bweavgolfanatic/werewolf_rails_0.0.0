class PlayersController < ApplicationController
  # GET /players
  # GET /players.json
  def index
    @players = Player.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @players }
    end
  end

  # GET /players/1
  # GET /players/1.json
  def show
    @player = Player.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @player }
    end
  end

  # GET /players/new
  # GET /players/new.json
  def new
    @player = Player.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @player }
    end
  end

  # GET /players/1/edit
  def edit
    @player = Player.find(params[:id])
  end

  # POST /players
  # POST /players.json
  def create
    @player = Player.new(params[:player])

    respond_to do |format|
      if @player.save
        format.html { redirect_to @player, notice: 'Player was successfully created.' }
        format.json { render json: @player, status: :created, location: @player }
      else
        format.html { render action: "new" }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /players/1
  # PUT /players/1.json
  def update
    @player = Player.find(params[:id])

    respond_to do |format|
      if @player.update_attributes(params[:player])
        format.html { redirect_to @player, notice: 'Player was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.json
  def destroy
    @player = Player.find(params[:id])
    @player.destroy

    respond_to do |format|
      format.html { redirect_to players_url }
      format.json { head :no_content }
    end
  end


  def get_possible_kills
    @player = Player.find_by_user_id( current_user.id)
    poss_kills = Hash.new
    if (@player.alignment == "werewolf") and (@player.isDead == "false") and (((Time.now - Game.last.created_at) % (2*Game.last.dayNightFreq)) > Game.last.dayNightFreq)
      Player.all.each do |player|
        if (player.user_id != @player.user_id) and (player.alignment == "townsperson") and (player.isDead == "false")
          if (player.lat - @player.lat).abs + (player.lng - @player.lng).abs < 10 #i have no idea how big distances are this will need to be adjusted
            poss_kills[player.nickname] = player.user_id
          end
        end
      end
    end
    respond_to do |format|
      format.json { render json: poss_kills}
    end

  end

  def kill_player
    puts params[:nickname]
    @player = Player.find_by_user_id( current_user.id)
    @victim = Player.find_by_nickname(params[:nickname])
    if @player.alignment == "werewolf" and (((Time.now - Game.last.created_at) % (2*Game.last.dayNightFreq)) > Game.last.dayNightFreq)
      if ((@victim.lat - @player.lat).abs + (@victim.lng - @player.lng).abs < 5) and (@victim.alignment == "townsperson") and (@victim.id != @player.id) and (@player.isDead == "false") and (@victim.isDead == "false") #i have no idea how big distances are this will need to be adjusted
        @victim.isDead = "true"
        @victim.save
        current_user.total_score += 100
        @player.score += 100
        @new_kill = Kill.new(:killerID => @player.user_id, :victimID => @victim.user_id, :lat => @victim.lat, :lng => @victim.lng)

        respond_to do |format|
          format.json { render json: "kill successful"}
        end
        @new_kill.save
      else
        respond_to do |format|
          format.json { render json: "kill unsuccessful"}
        end
      end
    else
      respond_to do |format|
        format.json { render json: "kill unsuccessful"}
      end

    end
  end

  def delete_all_players
    Player.delete_all
  end

  def vote_for_player
    @player = Player.find_by_user_id(current_user.id)
    if @player.isDead == "false"
      if @voted.isDead == "false"
        @voted = Player.find_by_nickname(params[:nickname])
        @voted.votes_for += 1
        @voted.save
      end
    end
  end

  def get_votables
    @player = Player.find_by_user_id(current_user.id)
    if @player.isDead == "false"
      if @player.alignment == "townsperson"
        poss_votes = Hash.new
        Player.all.each do |player|
          if player.isDead == "false"
            poss_votes[player.nickname] = player.user_id
          end
        end
      end
    end
    respond_to do |format|
      format.json { render json: poss_votes}
    end
  end





end
