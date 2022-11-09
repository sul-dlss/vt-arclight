# frozen_string_literal: true

# Draws the correct header, either for the virtual tribunals or the Nuremberg Archives
class HeaderComponent < Arclight::HeaderComponent
  def call
    if controller_name == 'virtual_tribunals'
      render VirtualTribunals::HeaderComponent.new(blacklight_config:)
    else
      render Arclight::HeaderComponent.new(blacklight_config:)
    end
  end
end
