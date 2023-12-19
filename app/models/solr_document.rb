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
  # Continue to use parent_ssim field from arclight versions prior to v1.1.0
  # TODO: This must be removed if we re-index the collection and remove the
  # Arclight::Parent override.
  attribute :parent_ids, Blacklight::Types::Array, 'parent_ssim'

  # Suppress the display of extent badge when there is only one item
  def extent
    results = Blacklight::Types::Array.coerce(self['extent_ssm'])
    results.any? { |v| v.include?('1 item(s)') } ? [] : results
  end
end
