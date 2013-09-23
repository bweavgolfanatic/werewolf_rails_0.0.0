class Kill < ActiveRecord::Base
  attr_accessible :killerID, :lat, :lng, :timestamp, :victimID
end
