require 'systemu'
require 'capybara/dsl'
require 'capybara/rspec'
require 'capybara-screenshot'
require 'capybara-screenshot/rspec'
require 'rspec/autorun'
require 'pry'
require 'support/selenium_drivers'
# Add self to the load path
$: << File.expand_path('../..', __FILE__)

Capybara.run_server = false
Capybara.default_driver = :selenium

Capybara.ignore_hidden_elements = true
Dir.glob('spec/support/*.rb').sort.each { |f| require f }

RSpec.configure do |config|
  config.include ProcessHelper
end