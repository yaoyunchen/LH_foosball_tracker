class User < ActiveRecord::Base
  has_many :requests
  has_many :match_invites
  has_many :match_players
  

  validates :username, presence: true
  validates :email, presence: true
  validates :password, presence: true
end