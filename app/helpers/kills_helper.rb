module KillsHelper
    def check_game_state
      puts "checking game state"

      @wolves = Player.find(:all, :conditions => ['alignment = ?', 'werewolf'])
      @townies = Player.find(:all, :conditions => ['alignment = ?', 'townsperson'])
      if (@wolves.length > @townies.length) or (@wolves.length == 0)
        @scheduler.stop
        @scheduler2.stop
        puts "create record, give points, end game, delete players"
      end

    end

end
