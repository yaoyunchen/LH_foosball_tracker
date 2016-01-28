class User < ActiveRecord::Base
  has_many :match_requests
  has_many :match_invites
  has_many :match_participactions
  

  validates :username, presence: true
  validates :email, presence: true
  validates :password, presence: true
end