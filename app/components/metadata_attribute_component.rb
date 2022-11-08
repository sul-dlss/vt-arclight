# frozen_string_literal: true

# Render a simple metadata field (e.g. without labels) in a .row div
class MetadataAttributeComponent < Blacklight::MetadataFieldComponent
  def initialize(field:, classes: ['attribute'], **kwargs)
    super(field:, **kwargs)

    @classes = classes + ["al-document-#{@field.key.dasherize}"]
  end
end
