require_relative '../../config/environment'
class ApplicationController < Sinatra::Base
  configure do
    set :views, Proc.new { File.join(root, "../views/") }
    enable :sessions unless test?
    set :session_secret, "secret"
  end

  get '/' do
    erb :index
  end

  post '/login' do
    @user = User.find_by(username: params[:username])

    if @user != nil && @user.password == params[:password]  #if conditions are met
      session[:user_id] = @user.id                          #match info from database
      redirect '/account'                                   #redirect to account route
    end 

    erb :error                                              #if not render error page

  end

  get '/account' do
    @current_user = User.find_by_id(session[:user_id])     #find current user set to session id
    if @current_user                                       # if user in session database 
      erb :account                                         # render account page 
    else 
      erb :error                                           # else, render error page
    end 

  end

  get '/logout' do                       #clear session, and redirect back to home
    session.clear 

    redirect '/'
  end
end

