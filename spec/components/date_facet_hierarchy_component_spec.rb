# frozen_string_literal: true

require "rails_helper"

RSpec.describe DateFacetHierarchyComponent, type: :component do
  subject(:component) { described_class.new(facet_field:) }

  let(:facet_field) do
    Blacklight::FacetFieldPresenter.new(CatalogController.blacklight_config.facet_fields['date'], display_facet,
                                        controller.view_context, search_state)
  end
  let(:display_facet) { Blacklight::Solr::Response::Facets::FacetField.new('date', items) }
  let(:search_state) { Blacklight::SearchState.new({}, CatalogController.blacklight_config) }
  let(:items) do
    [
      Blacklight::Solr::Response::Facets::FacetItem.new(value: '2009', hits: 1),
      Blacklight::Solr::Response::Facets::FacetItem.new(value: '2009-01', hits: 1),
      Blacklight::Solr::Response::Facets::FacetItem.new(value: '2009-01-10', hits: 1),
      Blacklight::Solr::Response::Facets::FacetItem.new(value: '2009-02', hits: 1),
      Blacklight::Solr::Response::Facets::FacetItem.new(value: '2010', hits: 1),
      Blacklight::Solr::Response::Facets::FacetItem.new(value: '2010-10', hits: 1),
      Blacklight::Solr::Response::Facets::FacetItem.new(value: '2010-10-15', hits: 1)
    ]
  end

  before do
    render_inline(component)
  end

  it "renders the year nodes of the tree" do
    expect(page).to have_selector '.card-body > ul > li[role="treeitem"]', count: 2
    expect(page).to have_selector '.card-body > ul > li[role="treeitem"]', text: '2009'
    expect(page).to have_selector '.card-body > ul > li[role="treeitem"]', text: '2010'
  end

  it 'renders the months' do
    expect(page).to have_link text: 'January'
    expect(page).to have_link text: 'February'
  end

  it 'renders the dayes' do
    expect(page).to have_link text: '10th'
    expect(page).to have_link text: '15th'
  end
end
