# frozen_string_literal: true

Capybara.register_driver :selenium_chrome_headless do |app|
  browser_options = Selenium::WebDriver::Chrome::Options.new
  browser_options.add_argument('--window-size=1920,1080')
  browser_options.add_argument('--headless')
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
end

Capybara.javascript_driver = :selenium_chrome_headless

# The new headless chrome needs more default time.
Capybara.default_max_wait_time = ENV['CI'] ? 30 : 10
