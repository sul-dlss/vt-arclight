# frozen_string_literal: true

Capybara.default_max_wait_time = ENV['CI'] ? 30 : 5
Capybara.javascript_driver = :selenium_chrome_headless
