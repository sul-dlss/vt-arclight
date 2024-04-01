# frozen_string_literal: true

require "rails_helper"

RSpec.describe BreadcrumbHierarchyComponent, type: :component do
  let(:presenter) { instance_double(Arclight::ShowPresenter, document:, heading: "doc title") }
  let(:document) { instance_double(SolrDocument, parents:) }
  let(:parents) do
    [instance_double(Arclight::Parent, collection?: true, label: 'parent collection', id: 'nnn')]
  end

  it "renders breadcrumbs" do
    render_inline(described_class.new(presenter:))

    expect(page).to have_css 'ol.breadcrumb'
    expect(page).to have_link 'parent collection'
    expect(page).to have_css '.al-collection-content-icon svg'
    expect(page).to have_text 'doc title'
  end
end
