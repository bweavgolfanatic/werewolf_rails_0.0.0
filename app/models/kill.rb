class Kill < ActiveRecord::Base
  attr_accessible :killerID, :lat, :lng, :victimID

  validates :killerID, :presence => true
  validates :victimID, :presence => true
  validates :lat, :presence => true
  validates :lng, :presence => true

  after_save :check_game



    def check_game
      @wolves = Player.where(:alignment => "werewolf",:isDead => "false")
      @townies = Player.where(:alignment => "townsperson", :isDead => "false")
      #puts @wolves
      #puts @townies
       if (@wolves.length > @townies.length) or (@wolves.length == 0)
         @cur_game = Game.find(Player.last.game_ID)
         @cur_game.game_state = "ended"
         @cur_game.save

         @new_report = Report.new
         if @wolves.length > @townies.length
           @new_report.winners = "Wolves"
           Player.all.each do |player|
             if player.alignment == "werewolf" and player.isDead == "false"
               player.score += 500
               player.save
             end
           end
         else
           @new_report.winners = "Townspeople"
           Player.all.each do |player|
             if player.alignment == "townsperson" and player.isDead == "false"
               player.score += 500
               player.save
             end
           end
         end
         @new_report.game_ID = @cur_game.id
         @high_score = Player.first
         Player.all.each do |player|
          if player.score > @high_score.score
            @high_score = player
          end
         end
         @new_report.high_score = @high_score.nickname + " : " + @high_score.score.to_s
         @new_report.save

        Player.all.each do |player|
          User.find(player.user_id).total_score += player.score
          if player.score > User.find(player.user_id).high_score
            User.find(player.user_id).high_score = player.score
          end
          User.save
        end

        Player.delete_all
    end
    end
end
