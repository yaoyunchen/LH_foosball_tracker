class SinglesResult < ActiveRecord::Base
  belongs_to :match
  belongs_to :user

  validates :match_id,
    numericality: {only_integer: true}

  validates :user_id,
    numericality: {only_integer: true}
end