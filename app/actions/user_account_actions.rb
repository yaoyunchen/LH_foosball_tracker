get '/users/new' do 
  erb :'users/new'
end

post '/users/new' do
  @user = User.new(
    username: params[:username],
    email: params[:email], 
    password: params[:password],
    bio: params[:bio]
  )

  if @user.save
    session[:user_id] = @user.id
    redirect '/'
  else
    erb :'users/new'
  end
end

get '/users/login' do
  erb :'users/login'
end

post '/users/login' do
  @user = User.find_by(username: params[:username], password: params[:password])
  
  unless @user == nil
    session[:user_id] = @user.id
    redirect '/user/match_request/new'
  else
    erb :'users/login'
  end
end


get '/logout' do
  session.clear
  redirect '/'
end