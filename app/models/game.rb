class Game < ActiveRecord::Base

  require 'rubygems'
  require 'rufus/scheduler'


  attr_accessible  :dayNightFreq, :game_state, :kill_radius, :scent_radius
  validates :dayNightFreq, presence: true
  validates :game_state, presence: true
  validates :kill_radius, presence: true
  validates :scent_radius, presence: true



  after_create :set_roles



  protected
    def set_roles
      @cur_game = Game.last


      create_players(@cur_game.id)

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
      @scheduler.in (Rufus.to_time_string (@cur_game.dayNightFreq*60)) do
        main_timer_1(@cur_game.id)
      end



    end


    def main_timer_1(game_id)
      if Game.find(game_id).game_state != "ended"
        @scheduler2 = Rufus::Scheduler.start_new
        @scheduler2.every (Rufus.to_time_string (@cur_game.dayNightFreq*120)) do
          if Game.find(game_id).game_state != "ended"
            poll_votes(game_id)
          else
            @scheduler2.stop
            puts "stopped scheduler"
          end

        end
      end
    end

    def create_players(game_id)
      Player.delete_all
      User.all.each do |user|
        puts "making player"
        @new_p = Player.new(:kill_made => "false",:vote_cast => "false", :votes_for => 0, :game_ID => game_id, :isDead => "false", :alignment => "townsperson", :user_id => user.id, :score => 0, :lat => rand(10), :lng => rand(10), :nickname => user.email.split('@')[0])
        @new_p.save
      end
    end

    def poll_votes(game_id)
      puts "***************************"
      puts "POLLING VOTES"
      puts Time.now
      puts "***************************"

      @players = Player.where(:isDead => 'false')
      @high_votes = @players[0]
      i = 0
      while i < @players.length
        if @players[i].votes_for > @high_votes.votes_for
          @high_votes = @players[i]
        end
        i += 1
      end




      puts @high_votes.nickname
      if @high_votes.votes_for != 0
        @high_votes.isDead = "true"
      end
      @high_votes.save
      
      Player.all.each do |player|
        if player.isDead == "false"
          player.score += 50
        end
        player.kill_made = "false"
        player.votes_for = 0
        player.vote_cast = "false"
        player.save
      end
      check_game(game_id)
      
    end

    def check_game(game_id)
      @wolves = Player.where(:alignment => "werewolf",:isDead => "false")
      @townies = Player.where(:alignment => "townsperson", :isDead => "false")
      #puts @wolves
      #puts @townies
       if (@wolves.length > @townies.length) or (@wolves.length == 0)
         @cur_game = Game.find(game_id)
         @cur_game.game_state = "ended"
         @cur_game.save

         @new_report = Report.new
         if @wolves.length > @townies.length
           @new_report.winners = "Wolves"
           Player.all.each do |player|
             if player.alignment == "werewolf" and player.isDead == "false"
               player.score += 125
               player.save
             end
           end
         else
           @new_report.winners = "Townspeople"
           Player.all.each do |player|
             if player.alignment == "townsperson" and player.isDead == "false"
               player.score += 125
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
          @userr = User.find(player.user_id)
          @userr.total_score += player.score
          if player.score > @userr.high_score
            @userr.high_score = player.score
          end
          @userr.level = @userr.total_score / 500
          @userr.save
        end

        Player.delete_all
    end
    end


  end
