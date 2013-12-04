class KillsController < ApplicationController

  def daily_report
    kills_hash = Hash.new
    if Game.all.length != 0
      if (((Time.now - Game.last.created_at) % (120*Game.last.dayNightFreq)) < (Game.last.dayNightFreq*60))
        @kills = Kill.all
        i = 0
        while i < @kills.length
          if Time.now - @kills[i].created_at < 120*Game.last.dayNightFreq
            kills_hash[i] = Player.find_by_user_id(kill.victimID).nickname + @kills[i].created_at.to_s + ": " + @kills[i].lat.to_s + ",  " + @kills[i].lng.to_s
          end
          i += 1
        end
      end
    end
    respond_to do |format|
      format.json {render json: kills_hash}
    end
  end



end