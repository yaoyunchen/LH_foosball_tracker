class Match < ActiveRecord::Base
  has_one :match_request
  has_many :match_participactions
end