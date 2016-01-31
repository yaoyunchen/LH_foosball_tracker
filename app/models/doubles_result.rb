class DoublesResult < ActiveRecord::Base
  belongs_to :match
  belongs_to :team

  validates :match_id, 
    numericality: {only_integer: true}

  validates :team_id, 
    numericality: {only_integer: true}
end