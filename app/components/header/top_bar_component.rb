# frozen_string_literal: true

module Header
  # Displays the navigation at the top of the page
  class TopBarComponent < Blacklight::TopNavbarComponent
    def initialize(mode: :default)
      @mode = mode
      super(blacklight_config: blacklight_config)
    end
  end
end
