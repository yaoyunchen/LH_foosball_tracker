get '/user' do 
  erb :'user/index'
end


#Get a form to request a match when the '+' is pressed while selecting opponent(s).
get '/user/match/singles/new' do
  redirect '/users/login' unless current_user
  
  users = User.where.not(id: current_user.id)
  @players_array = []

  users.each do |user|
    @players_array << {
      id: user.id,
      username: user.username,
      img_path: user.img_path,
      wins: user.singles_wins,
      losses: user.singles_losses,
      ratio: user.singles_ratio 
    }
  end

  @players_arrays

  erb :'/match/singles/new'
end

#Submits form for requesting a match.
post '/user/match/singles/new' do
  type = "singles"
  
  message = params[:message]   #Trash talk some shit.

  player_array = [{user_id: params[:user2], side: 1}]
  
  current_user.issue_match(player_array, message)

  redirect '/user/pending_invites'
end


get '/user/match/doubles/new' do
  redirect '/users/login' unless current_user
  
  users = User.where.not(id: current_user.id)
  @players_array = []

  users.each do |user|
    @players_array << {
      id: user.id,
      username: user.username,
      img_path: user.img_path,
      wins: user.doubles_wins,
      losses: user.doubles_losses,
      ratio: user.doubles_ratio 
    }
  end

  @players_arrays

  erb :'match/doubles/new'
end


#Submits form for requesting a match.
post '/user/match/doubles/new' do 
  message = params[:message]   #Trash talk some shit.

  player_array = []

  player_array << {user_id: params[:user2], side: 2} 

  player_array << {user_id: params[:user3], side: 2} 
  
  player_array << {user_id: params[:user4], side: 2} 

  player_array.each do |ele|
    ele[:side] = 1 if ele[:user_id] == params[:teammate]
  end

  current_user.issue_match(player_array, message)

  redirect '/user/pending_invites'
end



####################



#Gets a list of invites sent to the user.
get '/user/match_invites' do
  redirect '/users/login' unless current_user
  
  invites = current_user.match_invites.where(accept: nil).order(match_id: :desc)
  
  @invite_array = []

  invites.each do |invite|
    id = invite.id
    side = invite.side
    issuer = ""
    category = ""
    message = ""
    sent = ((Time.now - invite.created_at)/86400).to_i

    match = Match.find_by(id: invite.match_id)
    
    issuer = match.user.username
    img_path = match.user.img_path
    category = match.category
    message << match.message if match.message 

    @invite_array << {
      id: id,
      side: side,
      issuer: issuer,
      img_path: img_path,
      category: category,
      message: message, 
      sent: sent
    }
  end
  @invite_array

  erb :'/user/match_invites/index'
end


#Submits a form for accepting or declining a specific invite in the invites list.
put '/user/match_invites' do
  p params
  @match_invite = MatchInvite.find(params[:match_invite_id].to_i)
  match_id = @match_invite.match_id

  p params
  if params[:accept] == "true"
    current_user.accept_invite(match_id)
  else
    current_user.decline_invite(match_id)
  end

  redirect '/user/match_invites'
end


####################


get '/user/pending_invites' do
  redirect '/users/login' unless current_user

  own_invites = current_user.matches.where(status: nil).order(created_at: :desc)
  
  @invites_array = []

  own_invites.each do |invite|
    
    sent = ((Time.now - invite.created_at)/86400).to_i

    invitee_array = []
    invitees = MatchInvite.where(match_id: invite.id).where.not(user_id: current_user.id)
    invitees.each do |user|
      invitee_array << {
        username: User.find_by(id: user.user_id).username,
        img_path: User.find_by(id: user.user_id).img_path
      }
    end
    invitee_array

    @invites_array << {
      id: MatchInvite.find_by(match_id: invite.id, user_id: current_user.id).id,
      category: invite.category,
      sent: sent,
      invitees: invitee_array
    }
  end

  @invites_array
  erb :'/user/pending_invites/index'
end


put '/user/pending_invites' do
  @match_invite = MatchInvite.find(params[:match_invite_id].to_i)
  match_id = @match_invite.match_id
  Match.find_by(id: match_id).match_cancelled

  redirect '/user/pending_invites'
end

####################



#Show user's pending matches.
get '/user/pending_matches' do
  redirect '/users/login' unless current_user

  all_set_matches = Match.where(status: "set").order(:updated_at)

  
  your_matches = []
  
  all_set_matches.each do |match|
    invites = MatchInvite.where(match_id: match.id)
    
    invites.each do |invite|
      if invite.user_id == current_user.id
        matches = Match.find_by(id: invite.match_id)
        your_matches << matches
      end
    end
  end
  your_matches

  @match_hash_array = []
  
  your_matches.each do |match|
    category = match.category
    time = match.updated_at

    your_side = MatchInvite.where(match_id: match.id).where(user_id: current_user.id)[0].side

    players = MatchInvite.where(match_id: match.id).where.not(user_id: current_user.id)
    player_array = []

    players.each do |player|
      player_array << {
        username: User.find_by(id: player.user_id).username,
        img_path: User.find_by(id: player.user_id).img_path,
        side: player.side
      }
    end
    player_array

    @match_hash_array << {
      your_side: your_side,
      match_id: match.id,
      time: time,
      category: category, 
      players: player_array
    }
  end

  @match_hash_array

  erb :'/user/pending_matches/index'
end

#Submits a form for accepting or declining a specific invite in the invites list.
put '/user/pending_matches' do
  redirect '/users/login' unless current_user
  @match = Match.find_by(id: params[:match_id].to_i)
  p params
  if params[:status] == "cancelled"
    @match.match_cancelled
    redirect '/'
  else
    redirect '/user/pending_matches/choose_winner'
  end
end

get '/user/pending_matches/choose_winner' do
  redirect '/users/login' unless current_user

  #match = Match.find params[:match_id]
  match = Match.find(1)

  team_left = []
  team_right = []

  if match.category == "singles"
    left_player = SinglesResult.find_by(match_id: match.id,user_id: current_user.id)
    team_left << {
      username: User.find_by(id: left_player.user_id).username,
      img_path: User.find_by(id: left_player.user_id).img_path,
      side: left_player.side
    }
    right_player = SinglesResult.where(match_id: match.id).where.not(user_id: current_user.id)
    team_right << {
      username: User.find_by(id: right_player[0].user_id).username,
      img_path: User.find_by(id: right_player[0].user_id).img_path,
      side: right_player[0].side
    }
  else


  end

  team_left
  team_right
  # team_left = MatchResult.where(match_id: match.id ,user_id: current_user.id)
  # players_left = []
  # team_left.each do |member|
  #   player = User.find_by(id: member.user_id)
  #   players_left << {username: player.username, img_path: player.img_path, team: member.team}
  # end

  # team_right = MatchResult.where.not(team: team_left[0].team).where(match_id: match.id)
  # players_right = []
  # team_right.each do |member|
  #   player = User.find_by(id: member.user_id)
  #   players_right << {username: player.username, img_path: player.img_path, team: member.team}
  # end

  @result = {
    left: team_left, 
    right: team_right, 
    id: match.id
  }

  erb :'/user/pending_matches/choose_winner'
end


put '/user/pending_matches/choose_winner' do
  #@match = Match.find params[:match_id]
  #@match.match_over(params[:team])
  #redirect '/'
end