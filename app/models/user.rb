class User < ActiveRecord::Base
  has_many :match_requests
  has_many :match_invites
  has_many :match_results
  
  validates :username, 
    presence: true,
    uniqueness: {message: 'Username already taken.'}

  validates :email, 
    presence: true,
    uniqueness: true,
    format: {with: Devise.email_regexp}
    
  validates :password, 
    presence: true


  #Creates a match request when a user challenges player(s).
  def issue_request(players, type = "singles", message = nil)
    match_request = self.match_requests.create!(
      category: type,
      message: message
    )
    
    send_invites(players, match_request.id)
  end

  #Sends invite to player(s) challenged.
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
        self_invite.save!
        player_invites.each {|invite| invite.save!}
      end
    rescue ActiveRecord::RecordInvalid
      #Change the match request to show that the invites failed.
      MatchRequest.find_by(id: request_id).update!(status: "failed")
    end  
  end

  #Lets the user accept match invites.
  def accept_invite(match_request_id)
    @invite = MatchInvite.find_by(match_request_id: match_request_id, user_id: self.id, accept: nil)
    @invite.update!(accept: true)
  end

  #Lets the user decline match invites.  Once an invite is declined, all other related invites in the request will be set to false.
  def decline_invite(match_request_id)
    MatchInvite.where(match_request_id: match_request_id).update_all(accept: false)
    MatchRequest.find_by(id: match_request_id).update!(status: "failed")
  end


  #Calculates user's wins
  def calc_wins
    User.find_by(id: self.id).match_results.where(result: 1).select(:result).count
  end


  #Calculates user's losses
  def calc_losses
    User.find_by(id: self.id).match_results.where(result: -1).select(:result).count
  end


  #Calculate's user's W/L ratio
  def calc_ratio
    (calc_wins.to_f/calc_losses.to_f).round(2)
  end


  #Calculate's user's total games played
  def calc_total_plays
    User.find_by(id: self.id).match_results.where.not("result = 0 OR result IS NULL").count
  end
end
