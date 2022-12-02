# frozen_string_literal: true

# Draws the correct header, either for the virtual tribunals or the Nuremberg Archives
class HeaderComponent < Arclight::HeaderComponent
  def call
    component = controller_name == 'virtual_tribunals' ? VirtualTribunals::HeaderComponent : Nuremberg::HeaderComponent

    render component.new(blacklight_config:) do |c|
      c.with_top_bar(component: TopBarComponent)
    end
  end
end
