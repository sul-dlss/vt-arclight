# frozen_string_literal: true

# Draws the search result and show page for a SolrDocument
class DocumentComponent < Arclight::DocumentComponent
  # Override Arclight to remove the online filter
  def online_filter
    ''
  end
end
