# frozen_string_literal: true

# Methods that are mixed into the view context.
module ApplicationHelper
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

  # Modifying the labels according to: https://github.com/sul-dlss/vt-arclight/issues/286
  # The original values come from SUL ArchivesSpace controlled vocabulary
  def media_type_label(value)
    case value
    when "Graphic Materials"
      "Image"
    when "Moving Images"
      "Moving images"
    else
      value
    end
  end

  def component_media_type_label(value:, **_kwargs)
    media_type_label(value.first)
  end
end
