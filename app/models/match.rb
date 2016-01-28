class Match < ActiveRecord::Base
  has_one :request
  has_many :match_players
end