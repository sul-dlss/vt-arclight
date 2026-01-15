# frozen_string_literal: true

module Header
  # Displays the masthead in the header
  class MastheadComponent < ViewComponent::Base
    def initialize(mode:)
      @mode = mode
      super()
    end

    def title
      @title ||=
        if @mode == :vt
          t('virtual_tribunals.header_component.title')
        else
          t('arclight.masthead_heading_html')
        end
    end
  end
end
