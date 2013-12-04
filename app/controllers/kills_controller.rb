class KillsController < ApplicationController

  def daily_report
    kills_hash = Hash.new
    if Game.all.length != 0
      if (((Time.now - Game.last.created_at) % (120*Game.last.dayNightFreq)) < (Game.last.dayNightFreq*60))
        @kills = Kill.all
        puts @kills
        i = 0
        while i < @kills.length
          if Time.now - @kills[i].created_at < 120*Game.last.dayNightFreq
            kills_hash[i] = Player.find_by_user_id(@kills[i].victimID).nickname+" was killed at " + @kills[i].created_at.to_s.split("UTC")[0] + " at position : " + @kills[i].lat.to_s + ",  " + @kills[i].lng.to_s
          end
          i += 1
        end
      end
    end
    puts kills_hash
    respond_to do |format|
      format.json {render json: kills_hash}
    end
  end

  def index
    @kills = Kill.all

    respond_to do |format|
      format.json { render json: @kills }
    end
  end



end