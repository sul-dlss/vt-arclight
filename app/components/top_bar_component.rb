# frozen_string_literal: true

# Displays the navigation at the top of the page
# TODO: This can be refactored after https://github.com/projectblacklight/blacklight/pull/2889 is merged
class TopBarComponent < Blacklight::TopNavbarComponent
  def initialize(blacklight_config:, logo_link_text: nil) # rubocop:disable Lint/UnusedMethodArgument
    super(blacklight_config:)
  end

  def logo_link
    link_to t('.link_text'), blacklight_config.logo_link, class: 'mb-0 navbar-brand navbar-logo'
  end
end
