get '/user' do 
  erb :'user/index'
end


#Get a form to request a match when the '+' is pressed while selecting opponent(s).
get '/user/match_request/new' do
  redirect '/users/login' unless current_user
  @users = User.all
  erb :'match_request/new'
end

#Submits form for requesting a match.
post '/user/match_request' do
  type = params[:type]         #Singles or doubles
  message = params[:message]   #Trash talk some shit.

  player2 = {
    id: params[:user2_id],
    team: params[:user2_team]
  }

  player3 = {
    id: params[:user3_id],
    team: params[:user3_team]
  }

  player4 = {
    id: params[:user4_id],
    team: params[:user4_team]
  }

  player_array = [player2, player3, player4]

  current_user.issue_request(player_array, type, message)

  redirect '/'
end


####################


#Gets a list of invites sent to the user.
get '/user/match_invites' do
  redirect '/users/login' unless current_user

  invites = current_user.match_invites.where(accept: nil).order(match_request_id: :desc)
  @invite_hash_array = []
  
  invites.each do |invite|
    request = MatchRequest.find_by(invite.match_request_id)
    @invite_hash_array << {id: invite.id, username: request.user.username, category: request.category, message: request.message}
  end
  @invite_hash_array

  erb :'user/match_invites/index'
end

# #Gets a notification to accept or decline a specific invite in the invites list.
get '/user/match_invites/:match_invite_id' do
  redirect '/users/login' unless current_user
end

#Submits a form for accepting or declining a specific invite in the invites list.
put '/user/match_invites/:match_invite_id' do
  @match_invite = MatchInvite.find params[:match_invite_id]
  
  @match_invite.update!(accept: params[:choice])

  redirect '/'
end


####################


#Show user's pending matches.
get '/user/pending_matches' do
  redirect '/users/login' unless current_user

  matches = current_user.match_results.where(result: nil)

  @match_hash_array = []
  
  matches.each do |match|
    team = match.team
    total_players = MatchResult.where(match_id: match.match_id).count
    total_players == 2 ? type = "singles" : type = "doubles"

    @match_hash_array << {match_id: match.match_id, type: type, team: team}
  end

  @match_hash_array

  erb :'user/pending_matches/index'
end

# #Shows a form to let user's end a match either from cancelling or selecting a winner.
# get '/user/pending_matches/:match_id/edit' do


# end

#Submits a form for accepting or declining a specific invite in the invites list.
put '/user/pending_matches/:match_id' do
  redirect '/users/login' unless current_user

  @match = Match.find params[:match_id]

  choice = params[:choice]  #"cancelled"

  if choice == "cancelled"
    @match.match_cancelled
  else
    redirect "/user/pending_matches/#{params[:match_id]}/choose_winner"
    #@match.match_over(choice)
  end

  redirect '/'
end

get '/user/pending_matches/:match_id/choose_winner' do
  redirect '/users/login' unless current_user

  @match = Match.find params[:match_id]
  @team_left = MatchResult.find_by(match_id: @match.id ,user_id: current_user.id)
  @team_right = MatchResult.where.not(team: @team_left).find_by(match_id: @match.id)

  erb :'user/pending_matches/choose_winner'
end


put '/user/pending_matches/:match_id/choose_winner/edit' do
  @match = Match.find params[:match_id]
  @match.match_over(params[:team])
  redirect '/'
end