# frozen_string_literal: true

module Header
  # Header component; differentiates between VT landing page and other pages
  class HeaderComponent < Blacklight::HeaderComponent
    def call
      content_tag(:header) do
        safe_join(components.map { |c| render c })
      end
    end

    private

    def components
      vt_landing_page? ? landing_components : default_components
    end

    def landing_components
      [
        TopBarComponent.new(mode: :vt),
        MastheadComponent.new(mode: :vt)
      ]
    end

    def default_components
      [
        TopBarComponent.new(mode: :default),
        MastheadComponent.new(mode: :default),
        SearchNavbarComponent.new(blacklight_config: blacklight_config)
      ]
    end

    def vt_landing_page?
      controller.main_page?
    end
  end
end
