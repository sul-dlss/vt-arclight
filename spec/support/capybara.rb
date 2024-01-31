# frozen_string_literal: true

# Capybara.register_driver :selenium_chrome_headless_old do |app|
#   browser_options = Selenium::WebDriver::Chrome::Options.new
#   browser_options.add_argument('--headless=old')
#   browser_options.add_argument('--disable-site-isolation-trials')
#   Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
# end

# Capybara.javascript_driver = :selenium_chrome_headless_old
Capybara.javascript_driver = :selenium_chrome_headless
Capybara.default_max_wait_time = ENV['CI'] ? 60 : 10
puts "Capybara.default_max_wait_time = #{Capybara.default_max_wait_time}"
