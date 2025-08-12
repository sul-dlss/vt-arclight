# frozen_string_literal: true

# Draw the card on the homepage for a particular facet
class ExploreFacetComponent < ViewComponent::Base
  def initialize(facet:, image:, values:, more: false)
    @facet = facet
    @image = image
    @values = values
    @more = more
    super()
  end

  attr_reader :facet, :image, :values

  def title
    helpers.facet_field_label(facet.key)
  end

  def more?
    @more
  end

  def modal_path
    helpers.search_facet_path(id: facet.key)
  end

  def item_presenters
    values.map do |value|
      facet.item_presenter.new(value, facet, helpers, facet.name)
    end
  end
end
