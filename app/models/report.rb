class Report < ActiveRecord::Base
  attr_accessible :game_ID, :high_score, :winners
  validates :game_ID, presence: true
  validates :high_score, presence: true
  validates :winners, presence: true
end
