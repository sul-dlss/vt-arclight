# frozen_string_literal: true

module Header
  # Draws the tools at the top right of the page
  class UserUtilLinksComponent < ViewComponent::Base
    def initialize(mode: :default)
      @mode = mode
      super()
    end
  end
end
