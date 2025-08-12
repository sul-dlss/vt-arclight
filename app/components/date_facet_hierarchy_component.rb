# frozen_string_literal: true

# This require seems to be needed in order for ViewComponent::VERSION
# to be available in CI:
# https://github.com/projectblacklight/blacklight/blob/b1249e0e5947ea146e5dfcc903f70e5647da29e3/lib/blacklight/component.rb#L14
require 'view_component/version'

# Display the date facet in a tree hierarchy
class DateFacetHierarchyComponent < Blacklight::FacetFieldListComponent
  def facet_item_presenters
    facet_item_tree_hierarchy.map do |item|
      facet_item_presenter(item)
    end
  end

  private

  # Mutate the tree items to build out the tree hierarchy
  # for a facet and return the top-level facet items
  #
  # @return [Array<Blacklight::Solr::Response::Facets::FacetItem>]
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def facet_item_tree_hierarchy(delimiter: facet_config.delimiter || '-')
    tree = {}
    top_level = []

    @facet_field.paginator.items.each do |item|
      *parents, _last = item.value.split(delimiter)
      parent = parents.join(delimiter)
      tree[parent] ||= []
      tree[parent] << item
      tree[item.value] ||= []

      item.items = tree[item.value] if tree[item.value]

      top_level << item unless item.value.include?(delimiter)
    end

    top_level
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
