# frozen_string_literal: true

module Nuremberg
  # Override the Arclight header to use a local masthead component
  class HeaderComponent < Arclight::HeaderComponent
    def masthead
      render Nuremberg::MastheadComponent.new
    end
  end
end
