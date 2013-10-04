class Player < ActiveRecord::Base
  attr_accessible :isDead, :lat, :lng, :alignment, :user_id, :nickname


  validates :isDead, :presence => true
  validates :user_id, :presence => true
end
