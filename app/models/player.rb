class Player < ActiveRecord::Base
  attr_accessible :isDead, :lat, :lng, :type, :userID
end
