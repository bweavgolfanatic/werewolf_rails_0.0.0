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
      @scheduler.every(Rufus.to_time_string (@cur_game.dayNightFreq*60))do
        if (Time.now + (@cur_game.dayNightFreq / 3.0)) % (@cur_game.dayNightFreq *2) > @cur_game.dayNightFreq
          poll_votes
        else
          report_kills
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
      puts "poll votes here"
    end

    def report_kills
      puts "report kills here"
    end

  end
