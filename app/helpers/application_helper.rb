# frozen_string_literal: true

# Methods that are mixed into the view context.
module ApplicationHelper
  include Blacklight::LocalePicker::LocaleHelper

  def additional_locale_routing_scopes
    [blacklight, arclight_engine]
  end

  def render_parent_link(document:, **_kwargs)
    parent = document.parents.last
    return unless parent

    link_to parent.label, search_action_path(search_state.filter('parent_ssi').add(parent.id))
  end

  # rubocop:disable Rails/HelperInstanceVariable
  def parent_label(parent_id)
    return unless @response&.documents&.any?

    @response.documents.first.parents.find { |x| x.id == parent_id }&.label
  end
  # rubocop:enable Rails/HelperInstanceVariable
end
