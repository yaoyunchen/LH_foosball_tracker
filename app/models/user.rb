class User < ActiveRecord::Base
  
  has_many :matches
  has_many :match_invites
  has_many :singles_results
  
  validates :username, 
    presence: true,
    uniqueness: {message: 'Username already taken.'},
    format: {with: /\A[a-zA-Z0-9\_]+\z/, message: "Usernames can only include letters, numbers, and '_'"}

  validates :email, 
    presence: true,
    uniqueness: true,
    format: {with: Devise.email_regexp}
    
  validates :password, 
    presence: true

  #Creates a match request when a user challenges player(s).
  def issue_match(players, message = nil)
    type = players.count == 1 ? "singles" : "doubles"

    match = self.matches.create!(
      category: type,
      message: message
    )
    
    send_invites(players, match.id)
  end
  
  #Sends invite to player(s) challenged.
  def send_invites(players, match_id)
    begin
      #Register the current user in the MatchInvite table.
      self_invite = self.match_invites.new(
        match_id: match_id, 
        user_id: self.id,
        side: "1",
        accept: true
      )

      #Register each player invited in the MatchInvite table.
      player_invites = []
      players.each do |player|
        player_invites << MatchInvite.new(
          match_id: match_id, 
          user_id: player[:user_id],
          side: player[:side]
        )
      end

      #If any of the invites fail, then dont send any invite at all.
      MatchInvite.transaction do
        self_invite.save!
        player_invites.each {|invite| invite.save!}
      end
    rescue ActiveRecord::RecordInvalid
      #Change the match request to show that the invites failed.
      Match.find_by(id: match_id).update!(status: "cancelled")
    end  
  end

  #Lets the user accept match invites.
  def accept_invite(match_id)
    @invite = MatchInvite.find_by(match_id: match_id, user_id: self.id, accept: nil)
    @invite.update!(accept: true)
  end

  #Lets the user decline match invites.  Once an invite is declined, all other related invites in the request will be set to false.
  def decline_invite(match_id)
    MatchInvite.where(match_id: match_id).update_all(accept: false)
    Match.find_by(id: match_id).update!(status: "cancelled")
  end


  #Calculates user's singles wins.
  def singles_wins
    singles_results.sum(:win)
  end

  #Calculates user's singles losses.
  def singles_losses
    singles_results.sum(:loss)
  end

  #Calculate's user's total singles games played.
  def singles_total_plays
    singles_results.count
  end

  #Calculate's user's ratio.
  def singles_ratio
    if singles_results.any? 
      (100 * (singles_wins/singles_total_plays.to_f)).round(2)
    else
      "0.0"
    end
  end

  #Returns an array of all the user's teams.
  def get_teams
    Team.where("members LIKE (?) OR members LIKE (?)", "#{self.id},%", "%,#{self.id}")
  end

  #Calculates user's doubles wins.
  def doubles_wins
    total_wins = 0
    get_teams.each{ |team| total_wins += team.doubles_results.sum(:win)}
    total_wins
  end

  #Calculate's user's doubles losses.
  def doubles_losses
    total_wins = 0
    get_teams.each {|team| total_wins += team.doubles_results.sum(:loss)}
    total_wins
  end


  #Calculate's user's doubles plays.
  def doubles_total_plays
    total_plays = 0
    get_teams.each {|team| total_plays += team.doubles_results.count}
    total_plays
  end

  #Calculate's user's doubles ratio.
  def doubles_ratio
    if doubles_total_plays > 0
      (100 * (doubles_wins/doubles_total_plays.to_f)).round(2)
    else
      "0.0"
    end
  end
end
