class Report < ActiveRecord::Base
  attr_accessible :game_ID, :high_score, :most_kills, :winners
end
