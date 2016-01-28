class MatchInvite < ActiveRecord::Base
  belongs_to :match_request
  belongs_to :user

  validates :user_id,
    numericality: {only_integer: true}

  validates :match_request_id,
    numericality: {only_integer: true}

  validates :team,
    presence: true

  after_update :create_match




  private

    def create_match

    end

    def all_users_ready?


    end
end