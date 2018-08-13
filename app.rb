#app.rb
require "sinatra"
require "sinatra/flash"
require "sinatra/activerecord"

enable :sessions

set :database, {adapter: 'postgresql', database: 'travelblog'}

get "/" do
    if session[:user_id]
      erb :signed_in_homepage
    else
      erb :signed_out_homepage
    end
  end

  # displays sign in form
get "/sign-in" do
    erb :sign_in
  end