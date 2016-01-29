# get '/users' do 
#   erb :'users/index'
# end


#Get a form to request a match when the '+' is pressed while selecting opponent(s).
get '/user/match_request/new' do

end

#Submits form for requesting a match.
post '/user/match_request' do

end


####################


#Gets a list of invites sent to the user.
get 'user/match_invites' do

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



