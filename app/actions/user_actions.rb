# get '/users' do 
#   erb :'users/index'
# end


#Get a form to request a match when the '+' is pressed while selecting opponent(s).
get '/user/match_request/new' do
  erb :'match_request/new'
end

#Submits form for requesting a match.
post '/user/match_request' do
  user_id = params[:user_id]
  team = params[:team]
  type = params[:type]         #Singles or doubles
  message = params[:message]   #Trash talk some shit.

  current_user.issue_request([{user_id: user_id, team: team}], type, message)
  redirect '/user/match_request/new'
end


####################


#Gets a list of invites sent to the user.
get '/user/match_invites' do
  invites = current_user.match_invites.where(accept: nil).order(match_request_id: :desc)
  @invite_hash_array = []
  
  invites.each do |invite|
    request = MatchRequest.find_by(invite.match_request_id)
    @invite_hash_array << {username: request.user.username,category: request.category, message: request.message}
  end
  @invite_hash_array
  
  erb :'user/match_invites/index'
end

#Gets a form to accept or decline a specific invite in the invites list.
get '/user/match_invites/:match_invite_id/edit' do

end

#Submits a form for accepting or declining a specific invite in the invites list.
puts '/user/match_invites/:match_invite_id' do


end


####################


#Show user's pending matches.
get '/user/matches' do

end

#Shows a form to let user's end a match either from cancelling or selecting a winner.
get '/user/matches/:match_id/edit' do


end

#Submits a form for accepting or declining a specific invite in the invites list.
puts '/user/matches/:match_id' do


end



