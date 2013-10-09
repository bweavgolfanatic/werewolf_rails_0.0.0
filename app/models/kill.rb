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
       if (@wolves.length > @townies.length) or (@wolves.length == 0)
         @cur_game = Game.last
         @cur_game.game_state = "ended"
         @cur_game.save
         puts "create record, give points, end game, delete players, delete game" #TODO
       end
    end
end
