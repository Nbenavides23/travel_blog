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
  @user_id = session[:user_id]
  @profile = User.find(@user_id)
  @users_post = @profile.post
  erb :profile

end

get "/post" do
  @post = Post.all
  redirect '/profile'
end


get "/post/new" do
  erb :new_layout
end


post "/post" do 
 @post = Post.create(
  user_id: session[:user_id],
  title: params[:title],
  text_content: params[:text_content],
  image: params[:image]
 )
 redirect '/post'
end



get "/post/:id/edit" do
  @post = Post.find(params[:id])
  if session[:user_id] == @post.user_id.to_i
  erb :edit
  else
    "Error 404, you can't edit others people post"
    
  end
 
end

put "/post/:id" do
  @post = Post.find(params[:id])
  @post.update(user_id: session[:user_id],
  title: params[:title],
  text_content: params[:text_content],
  image: params[:image])
 
  redirect '/profile'
end

# get "/edit" do
#   if session[:user_id]
#   erb :edit,:layout => :edit
#   else 
#     erb :edit
#   end
# end

get "/new_layout" do
  redirect "/"
end

delete '/posts/:id/delete' do #delete action
  @post = Post.find_by_id(params[:id])
  @post.delete
  redirect to '/profile'
end



get "/" do
    if session[:user_id]
      erb :sign_in_layout
    else 
      erb :sign_in
      
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

# # displays signup form
# #   with fields for relevant user information like:
# #   username, password
get "/sign-up" do
  erb :sign_up
end

# post "/sign-up" do
#   @user = User.create(
#     firstname: params[:firstname],
#     lastname: params[:lastname],
#     username: params[:username],
#     password: params[:password],
#     email:    params[:email],
#     birthday: params[:birthday]
#   )

#   # this line does the signing in
#   session[:user_id] = @user.id

#   # lets the user know they have signed up
#   flash[:info] = "Thank you for signing up"

#   # assuming this page exists
#   redirect "/"
# end

# # when hitting this get path via a link
# #   it would reset the session user_id and redirect
# #   back to the homepage
get "/sign-out" do
  # this is the line that signs a user out
  session[:user_id] = nil

  # lets the user know they have signed out
#   flash[:info] = "You have been signed out"
  
  redirect "/"
end


# # get '/user/:id/edit' do 
# #   if session[:user_id] == params[:id]
# #     #Access thier user profile edit page
# #   else
# #     #Redirect them and tell them they do not have access to edit other peoples profile pages
# #   end
# # end

# get '/signed-out'do
#   erb :signed_out_layout
# end 
