# frozen_string_literal: true

# Represent a single document returned from Solr
class SolrDocument
  include Blacklight::Solr::Document
  include Arclight::SolrDocument

  # self.unique_key = 'id'

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  attribute :media_type, Blacklight::Types::String, 'media_type_ssi'

  # Suppress the display of extent badge when there is only one item
  def extent
    result = Blacklight::Types::String.coerce(self['extent_ssm'])
    return result if result != '1 item(s)'
  end
end
