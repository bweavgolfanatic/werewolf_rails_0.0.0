class User < ActiveRecord::Base
  attr_accessible :hashedpwd, :username
end
