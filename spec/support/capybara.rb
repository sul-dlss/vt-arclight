# frozen_string_literal: true

Capybara.javascript_driver = :selenium_chrome_headless

# The new headless chrome needs more default time.
Capybara.default_max_wait_time = ENV['CI'] ? 30 : 10
