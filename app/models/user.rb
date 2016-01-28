class User < ActiveRecord::Base
  has_many :match_requests
  has_many :match_invites
  has_many :match_participactions
  
  validates :username, 
    presence: true,
    uniqueness: {message: 'Username already taken.'}

  validates :email, 
    presence: true,
    uniqueness: true,
    format: {with: Devise.email_regexp}
    
  validates :password, 
    presence: true


  def issue_request(players, type = "single")
    
    match_request = self.match_requests.create!(
      category: type
    )

    send_invites(players, match_request.id)
  end

  def send_invites(players, request_id)
    begin

      self_invite = self.match_invites.new(
        match_request_id: request_id, 
        user_id: self.id,
        team: "1",
        accept: true
      )

      player_invites = []
      players.each do |player|
        player_invites << MatchInvite.new(
          match_request_id: request_id, 
          user_id: player[:user_id],
          team: player[:team]
        )
      end

      self_invite.save!
      player_invites.each do |invite|
        invite.save!
      end
    rescue
      MatchRequest.find_by(id: request_id).update!(status: "Failed")
    end
  end  

end
