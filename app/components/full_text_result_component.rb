# frozen_string_literal: true

# Render the fulltext results
class FullTextResultComponent < Blacklight::MetadataFieldComponent
  attr_reader :query_param

  def initialize(field:, **)
    super

    # Save the search so we can pass it to the show page for searching the document
    @query_param = field.view_context.search_state.query_param
  end

  def key
    "#{@field.key}-#{@field.document.id}"
  end
end
