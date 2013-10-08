class Game < ActiveRecord::Base

  require 'rubygems'
  require 'rufus/scheduler'


  attr_accessible  :dayNightFreq, :game_state
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
      @scheduler.every(Rufus.to_time_string (@cur_game.dayNightFreq*120))do
        if @cur_game.game_state != "ended"
          poll_votes
        else
          @scheduler.shutdown
        end
      end



    end




    def create_players
      User.all.each do |user|
        puts "making player"
        @new_p = Player.new(:isDead => "false", :alignment => "townsperson", :user_id => user.id, :lat => rand(10), :lng => rand(10), :nickname => user.email.split('@')[0])
        @new_p.save
      end
    end

    def poll_votes
      @high_votes = Player.first
      Player.each do |player|
        if player.votes_for > @high_votes.votes_for
          @high_votes = player
        end
      @high_votes.isDead == "true"
      @high_votes.save
      end
      check_game
      Player.each do |player|
        player.votes_for = 0
        player.save
      end
      
    end

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
