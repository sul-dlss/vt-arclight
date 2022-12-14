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
      "Moving image"
    else
      value
    end
  end

  def component_media_type_label(value:, **_kwargs)
    media_type_label(value.first)
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

  def search_for_doc_text_link(document)
    return '' unless params[:q] && document[:druid]

    link_to(
      "Search for \"#{params[:q]}\" in document text",
      solr_document_path(document[:druid], search: params[:q]),
      class: 'prepared-search-link'
    )
  end

  def render_fulltext_highlight(document:, **_args)
    highlights = document.full_text_highlights
    link = search_for_doc_text_link(document)

    safe_join(highlights.take(3).map do |val|
      content_tag('p') do
        sanitize(val, tags: %w(em))
      end
    end.prepend(link), '')
  end
end
