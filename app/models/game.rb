class Game < ActiveRecord::Base

  require 'rubygems'
  require 'rufus/scheduler'


  attr_accessible :createdDate, :dayNightFreq
  validates :dayNightFreq, presence: true


  after_create :set_roles



  protected
    def set_roles
      @cur_game = Game.last
      scheduler = Rufus::Scheduler.start_new
      scheduler.every(Rufus.to_time_string (@cur_game.dayNightFreq*60))do
        puts @cur_game.day_state
        puts "switched"
        if @cur_game.day_state == "day"
          @cur_game.day_state = "night"
        else
          @cur_game.day_state = "day"
        end
        puts @cur_game.day_state
        @cur_game.save
      end
      @players = Player.all

      for player in @players do
        player.alignment = "townsperson"
        player.save
      end

      size = Player.count
      puts size
      num_wolves = (size*3)/10
      i = 0
      while i < num_wolves do

        @cur_player = Player.offset(rand(Player.count)).first
        @cur_player.alignment = "werewolf"
        @cur_player.save
        i+=1
      end
       

    end



end
