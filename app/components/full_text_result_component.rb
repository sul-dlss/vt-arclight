# frozen_string_literal: true

# Render the fulltext results
class FullTextResultComponent < Blacklight::MetadataFieldComponent
  def key
    "#{@field.key}-#{@field.document.id}"
  end
end
