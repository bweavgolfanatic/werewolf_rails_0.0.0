class Player < ActiveRecord::Base
  attr_accessible :isDead, :lat, :lng, :alignment
  belongs_to :user
end
