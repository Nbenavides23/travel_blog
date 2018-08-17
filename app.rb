#app.rb
require 'sinatra'
require 'sinatra/flash'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require './models/user'
require './models/tags'
require './models/post'
require './models/tags_to_multiple_posts'


enable :sessions



get "/profile" do
  @post = Post.all
  erb :profile, :layout => :profile
end

#Create Post 
# get "/post" do
#   @post = Post.all
#   erb :blog, :layout => :new_layout
# end


get "/post" do
   @user
 @post = Post.all
 @user = User.find(session[:user_id]) 
 @user_id = User.find(session[:user_id])
 erb :blog, :layout => :new_layout
end


post "/post" do 
 @post = Post.create(
  user_id: params[:user_id],
  title: params[:title],
  text_content: params[:text_content],
  image: params[:image]
 )
 redirect '/profile'
end

get "/post/:id" do
  @post = Post.find(params[:id])
  erb :blog, :layout => :profile
  redirect '/profile'
end

get "/post/edit/:id" do
  @post = Post.find(params[:id])
  erb :blog, :layout => :profile
  redirect '/profile'
end

get "/edit" do
  if session[:user_id]
  erb :edit,:layout => :edit
  else 
    erb :edit
  end
end

get "/new_layout" do
  redirect "/"
end


get "/" do
    if session[:user_id]
      erb :sign_in_layout
    else
      erb :signed_out_layout
    end
  end


  # displays sign in form
get "/sign-in" do
    erb :sign_in 
  end
  
  # responds to sign in form
post "/sign-in" do
  @user = User.find_by(username: params[:username])

  # checks to see if the user exists
  #   and also if the user password matches the password in the db
  if @user && @user.password == params[:password]
    # this line signs a user in
    session[:user_id] = @user.id

    # lets the user know that something is wrong
    flash[:info] = "You have been signed in"

    # redirects to the home page
    redirect "/profile"
  else
    # lets the user know that something is wrong
    flash[:warning] = "Your username or password is incorrect"

    # if user does not exist or password does not match then
    #   redirect the user to the sign in page
    redirect "/sign-in"
  end
end

# displays signup form
#   with fields for relevant user information like:
#   username, password
get "/sign-up" do
  erb :sign_up
end

post "/sign-up" do
  @user = User.create(
    firstname: params[:firstname],
    lastname: params[:lastname],
    username: params[:username],
    password: params[:password],
    email:    params[:email],
    birthday: params[:birthday]
  )

  # this line does the signing in
  session[:user_id] = @user.id

  # lets the user know they have signed up
  flash[:info] = "Thank you for signing up"

  # assuming this page exists
  redirect "/"
end

# when hitting this get path via a link
#   it would reset the session user_id and redirect
#   back to the homepage
get "/sign-out" do
  # this is the line that signs a user out
  session[:user_id] = nil

  # lets the user know they have signed out
  flash[:info] = "You have been signed out"
  
  redirect "/"
end


get '/user/:id/edit' do 
  if session[:user_id] == params[:id]
    #Access thier user profile edit page
  else
    #Redirect them and tell them they do not have access to edit other peoples profile pages
  end
end

