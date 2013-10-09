class Game < ActiveRecord::Base

  require 'rubygems'
  require 'rufus/scheduler'


  attr_accessible  :dayNightFreq, :game_state, :kill_radius
  validates :dayNightFreq, presence: true



  after_create :set_roles



  protected
    def set_roles
      @cur_game = Game.last


      create_players

      size = Player.count

      num_wolves = (size*3)/10
      i = 0
      while i < num_wolves do

        @cur_player = Player.offset(rand(Player.count)).first
        @cur_player.alignment = "werewolf"
        @cur_player.save
        i+=1
      end
      @scheduler = Rufus::Scheduler.start_new
      @scheduler.in (Rufus.to_time_string (@cur_game.dayNightFreq)) do
        main_timer_1
      end



    end


    def main_timer_1
      if Game.last.game_state != "ended"
        @scheduler2 = Rufus::Scheduler.start_new
        @scheduler2.every (Rufus.to_time_string (@cur_game.dayNightFreq*2)) do
          if Game.last.game_state != "ended"
            poll_votes
          else
            @scheduler2.shutdown
          end

        end
      end
    end

    def create_players
      User.all.each do |user|
        puts "making player"
        @new_p = Player.new(:isDead => "false", :alignment => "townsperson", :user_id => user.id, :score => 0, :lat => rand(10), :lng => rand(10), :nickname => user.email.split('@')[0])
        @new_p.save
      end
    end

    def poll_votes #TODO add points for surviving rounds
      @high_votes = Player.first
      Player.each do |player|
        if player.votes_for > @high_votes.votes_for
          @high_votes = player
        end
      @high_votes.isDead == "true"
      @high_votes.save
      end
      
      Player.each do |player|
        player.votes_for = 0
        player.vote_cast = "false"
        player.save
      end
      check_game
      
    end

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
