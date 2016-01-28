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

  class FailInviteError < StandardError; end


  def issue_request(players, message = nil, type = "singles")
    
    #Creates a match request when a user challenges player(s).
    match_request = self.match_requests.create!(
      category: type,
      message: message
    )
    
    #Sends invite to player(s) challenged.
    send_invites(players, match_request.id)
  end

  def send_invites(players, request_id)
    begin
      #Register the current user in the MatchInvite table.
      self_invite = self.match_invites.new(
        match_request_id: request_id, 
        user_id: self.id,
        team: "1",
        accept: true
      )

      #Register each player invited in the MatchInvite table.
      player_invites = []
      players.each do |player|
        player_invites << MatchInvite.new(
          match_request_id: request_id, 
          user_id: player[:user_id],
          team: player[:team]
        )
      end

      #If any of the invites fail, then dont send any invite at all.
      MatchInvite.transaction do
        player_invites.each do |invite|
          invite.save!
        end
        self_invite.save!
      end
    rescue ActiveRecord::RecordInvalid
      #Change the match request to show that the invites failed.
      MatchRequest.find_by(id: request_id).update!(status: "failed")
    end  
  end

  def accept_invite


  end


  def decline_invite


  end
end
