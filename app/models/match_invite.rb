class MatchInvite < ActiveRecord::Base
  belongs_to :match
  belongs_to :user

  validates :user_id,
    numericality: {only_integer: true}

  validates :match_id,
    numericality: {only_integer: true}

  validates :side,
    presence: true

   after_update :check_if_ready

  def relative_time
    a = (Time.now - self.created_at).to_i

    case a
      when 0 then 'just now'
      when 1 then 'a second ago'
      when 2..59 then a.to_s+' seconds ago' 
      when 60..119 then 'a minute ago' #120 = 2 minutes
      when 120..3540 then (a/60).to_i.to_s+' minutes ago'
      when 3541..7100 then 'an hour ago' # 3600 = 1 hour
      when 7101..82800 then ((a+99)/3600).to_i.to_s+' hours ago' 
      when 82801..172000 then 'a day ago' # 86400 = 1 day
      when 172001..518400 then ((a+800)/(60*60*24)).to_i.to_s+' days ago'
      when 518400..1036800 then 'a week ago'
      else ((a+180000)/(60*60*24*7)).to_i.to_s+' weeks ago'
    end
  end 

  private

    def check_if_ready
      all_invites = MatchInvite.where(match_id: self.match_id)

      if all_users_ready?(all_invites)
        #Once all users are ready, create the match.
        Match.find_by(id: self.match_id).update!(
          status: "set"
        )
      end
    end

    #Checks if all users have accepted.
    def all_users_ready?(all_invites)
      ready = true
      all_invites.each do |invite|
        ready = false unless invite.accept
      end
      ready
    end
end