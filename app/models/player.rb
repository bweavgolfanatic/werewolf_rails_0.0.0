class Player < ActiveRecord::Base
  attr_accessible :isDead, :lat, :lng, :alignment, :user_id, :nickname, :game_ID, :score, :votes_for, :vote_cast, :kill_made


  validates :isDead, :presence => true
  validates :lat, :presence => true
  validates :lng, :presence => true
  validates :alignment, :presence => true
  validates :user_id, :presence => true
  validates :nickname, :presence => true
  validates :game_ID, :presence => true
  validates :score, :presence => true
  validates :votes_for, :presence => true
  validates :vote_cast, :presence => true
  validates :kill_made, :presence => true

end
