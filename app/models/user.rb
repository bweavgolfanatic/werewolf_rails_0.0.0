class User < ActiveRecord::Base
  require 'bcrypt'
  attr_accessible :email, :password, :password_confirmation, :total_score, :high_score, :level

  attr_accessor :password
  before_save :encrypt_password


  validates_confirmation_of :password
  validates :password, :presence => true, :on => :create
  validates :email, :presence => true
  validates :total_score, :presence => true
  validates :high_score, :presence => true
  validates :level, :presence => true

  validates_uniqueness_of :email



  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end