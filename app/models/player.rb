class Player < ActiveRecord::Base
  attr_accessible :isDead, :lat, :lng, :alignment, :userID
end
