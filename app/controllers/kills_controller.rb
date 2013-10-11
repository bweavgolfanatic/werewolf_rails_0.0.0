class KillsController < ApplicationController

  def daily_report
    kills_hash = Hash.new
    if (((Time.now - Game.last.created_at) % (120*Game.last.dayNightFreq)) < (Game.last.dayNightFreq*60))
      Kill.all.each do |kill|
        if Time.now - kill.created_at < 120*Game.last.dayNightFreq
          kills_hash[kill.victimID] = kill.created_at + ": " + kill.lat + ",  " + kill.lng
        end
      end
    end
    respond_to do |format|
      format.json {render json: kills_hash}
    end
  end



end