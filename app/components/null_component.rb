# frozen_string_literal: true

# Renders nothing
class NullComponent < ViewComponent::Base
  def initialize(**)
    # Accept and ignore any keyword args
    super()
  end

  def render?
    false
  end

  # No-op, but necessary as view_component ensures you have this defined
  def call; end
end
