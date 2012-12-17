require 'selenium/webdriver'

Capybara.register_driver :chrome do
  driver = Capybara::Selenium::Driver.new(nil, :browser => :chrome)
  driver.browser.manage.window.resize_to(1600, 1200)
  driver
end

Capybara.register_driver :selenium do
  profile = Selenium::WebDriver::Firefox::Profile.new
  Capybara::Selenium::Driver.new(nil, :profile => profile)
end

Capybara::Screenshot.register_driver(:chrome) do |driver, path|
  driver.browser.save_screenshot(path)
end
