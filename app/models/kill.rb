class Kill < ActiveRecord::Base
  attr_accessible :killerID, :lat, :lng, :victimID

  validates :killerID, :presence => true
  validates :victimID, :presence => true
  validates :lat, :presence => true
  validates :lng, :presence => true

  after_save :check_game



  def check_game
    @wolves = Player.find(:all, :conditions => ['alignment = ?', 'werewolf'])
    @townies = Player.find(:all, :conditions => ['alignment = ?', 'townsperson'])
      if (@wolves.length > @townies.length) or (@wolves.length == 0)
        @cur_game = Game.last
        @cur_game.game_state = "ended"
        puts "create record, give points, end game, delete players"
      end
  end
end
