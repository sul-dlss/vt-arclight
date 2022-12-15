# frozen_string_literal: true

module Nuremberg
  # Overrides the default Arclight::MastheadComponent with our
  # own design and html-safe'd heading
  class MastheadComponent < Arclight::MastheadComponent
    def heading
      sanitize super
    end
  end
end
