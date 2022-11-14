# frozen_string_literal: true

# Draws the tools at the top right of the page
class UserUtilLinksComponent < ViewComponent::Base
  delegate :main_page?, to: :controller
end
