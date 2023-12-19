# frozen_string_literal: true

# Methods that are mixed into the view context.
module ApplicationHelper
  def render_item_extent(document:, **_kwargs)
    # Prior to ArcLight 1.1 extents were stored separately
    # (e.g. ['1 item(s)', '0:14:01']). They are now concatenated
    # in the index (e.g. ['1 item(s) 0:14:01']). Selecting the last value
    # maintains compatibility with the existing ArcLight 1.0 index.
    extent = document['extent_ssm'].last.gsub('1 item(s)', '').strip

    # add duration label for time-based media
    case document["media_type_ssi"]
    when 'Moving Images', 'Audio'
      "#{extent} duration"
    else
      extent
    end
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
      "Moving image"
    else
      value
    end
  end

  def component_media_type_label(value:, **_kwargs)
    media_type_label(value.first)
  end

  def item_level(document)
    return unless document["level_ssim"]

    document["level_ssim"]&.first&.match?("Item")
  end

  # Generate a single HTML string with links to facet by an item's dates.
  # Ensure the link only covers the date portion of the text with `pattern`.
  # Join multiple distinct values with `sep`.
  def render_date_facet_links(value:, pattern: /(\d{4}(?:-\d{2}-\d{2})?)/, sep: ', ', **_kwargs)
    dates = value.map do |date|
      parts = date.split(pattern).map do |part|
        part.match(pattern) ? link_to(part, search_action_path(search_state.filter('date').add(part))) : part
      end
      safe_join parts
    end
    safe_join dates, sep
  end

  # Override Arclight's default icon mapping because our levels are named differently
  # See: https://github.com/projectblacklight/arclight/blob/main/app/helpers/arclight_helper.rb#L81
  def document_or_parent_icon(document)
    case document.level&.downcase
    when 'collection'
      'collection'
    when 'series', 'subseries', 'record group'
      'folder'
    when 'item'
      'file'
    else
      super
    end
  end

  # Disables display of icons from Dashlane password manager
  # See https://github.com/sul-dlss/vt-arclight/issues/495
  def dashlane_ignore
    { 'form-type' => 'other' }
  end
end
