helpers do
  def current_user
    current_user = User.find_by(id: 1)
  end
end


# Homepage (Root path)
get '/' do
  erb :index
end



# # Development

# get '/dev/match' do
#   erb :'/dev/match/index'
# end

# get '/dev/match/pending' do
#   erb :'/dev/match/pending'
# end