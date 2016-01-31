class Team < ActiveRecord::Base
  has_many :doubles_results


  #Calculates team's wins.
  def team_wins
    doubles_results.sum(:win) 
  end

  #Calculates user's singles losses.
  def team_losses
    doubles_results.sum(:loss)
  end

  #Calculate's user's total singles games played.
  def team_total_plays
    doubles_results.count
  end

  #Calculate's user's ratio.
  def team_ratio
    if doubles_results.any? 
      100 * (team_wins.to_f/team_total_plays.to_f).round(2) 
    else
      "0.0"
    end
  end
end