#!/usr/bin/env ruby

require 'rubygems'
require 'json'
require 'scissors/client'
require 'sinatra'
require 'haml'

ENV["PORT"] ||= "9001"
ENV["APP_NAME"] ||= "Test App"
ENV["SECRET"] ||= "My Secret"
ENV["AUTH_URI"] ||= "http://127.0.0.1:9002/"

set :port, ENV["PORT"]
enable :sessions

CLIENT = Scissors::Client.new(ENV["APP_NAME"], ENV["SECRET"], ENV["AUTH_URI"])

get '/' do

  if session[:user]
    "Welcome, logged in user #{session[:user].inspect}"
  else
    session[:back_to] = request.url
    redirect '/loginform'
  end

end

get '/login' do
  signed_token = CLIENT.extract_url_param(params[:signed_body], params[:signed_token])
  if signed_token
    signed_token = JSON.parse(signed_token)
    session[:user] = signed_token['user']
    if signed_token['appdata']
      redirect signed_token['appdata'].to_s
    else
      redirect '/'
    end
  else
    redirect '/loginform?login=failed'
  end
end

get '/loginform' do
  if session[:user]
    redirect '/'
  else
    target = CLIENT.authentication_url( {:source => session[:back_to]}.to_json )
    failed_login = params['login'] == 'failed'
    haml <<-HAML.gsub(/^ {6}/, ''), :locals => {:target => target, :failed => failed_login}
      %h1
        Log In
      - if failed
        %h2
          Login failed: Incorrect username or password.
      %form{:action => target, :method => :post}
        %input{:name => 'identity', :placeholder => 'username'}
        %input{:name => 'password', :type => 'password', :placeholder => 'password'}
        %input{:name => 'submit', :value => 'Log in', :type => 'submit'}
    HAML
  end

end
