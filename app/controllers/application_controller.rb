# frozen_string_literal: true

# The base controller for sharing behaviors common to all other controllers
class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller

  include BotChallengePage::Controller
  include BotChallengePage::GuardAction

  class_attribute :bot_challenge_config, default: ::BotChallengePage.config

  layout :determine_layout if respond_to? :layout

  # This helps decide whether some nav actions appear
  def main_page?
    controller_name == 'virtual_tribunals'
  end
end
