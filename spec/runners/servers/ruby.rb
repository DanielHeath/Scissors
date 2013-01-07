#!/usr/bin/env rackup
require 'rubygems'
require 'rack/session/cookie'
require 'scissors/server'

ENV["PORT"] ||= "9002"
ENV["CLIENT_NAME"] ||= "Test App"
ENV["SECRET"] ||= "My Secret"
ENV["CLIENT_LOGIN_URI"] ||= "http://127.0.0.1:9001/login"
ENV["CLIENT_LOGOUT_URI"] ||= "http://127.0.0.1:9001/logout"
ENV["CLIENT_LOGIN_FORM_URI"] ||= "http://127.0.0.1:9001/loginform"
COOKIE_SECRET = 'foo bar baz'

class TestAuthenticableUser
  VALID_USER = "John".freeze
  VALID_PASSWORD = 'Smith'.freeze

  def self.find_by_identity(ident)
    ident == VALID_USER ? self.new : nil
  end

  def authenticate(password)
    password == VALID_PASSWORD
  end

  def identity
    VALID_USER
  end

  def serialize_for_app(app)
    {:ident => identity, :random_other => 'property'}
  end

end

server = Scissors::Server.new do |app|
  app.authenticable_model = TestAuthenticableUser
  app.authenticates_for(ENV["CLIENT_NAME"],
    :shared_key => ENV["SECRET"],
    :login_url => ENV["CLIENT_LOGIN_URI"],
    :logoff_url => ENV["CLIENT_LOGOUT_URI"],
    :login_form_url => ENV["CLIENT_LOGIN_FORM_URI"]
  )
end

twenty_years = Time.now.to_i + 600000000

server_with_cookies = Rack::Session::Cookie.new(server,
  :key => 'scissors.auth_session',
  :domain => "localhost:#{ENV["PORT"]}",
  :path => '/',
  :expire_after => twenty_years,
  :secret => COOKIE_SECRET
)

Rack::Handler::Thin.run server_with_cookies, :Port => ENV["PORT"]
