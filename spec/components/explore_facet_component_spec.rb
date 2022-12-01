# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExploreFacetComponent, type: :component do
  let(:blacklight_config) { CatalogController.blacklight_config }

  before do
    render_inline(described_class.new(facet: blacklight_config.facet_fields['media_format'],
                                      image: 'explore-facet-media-format.png',
                                      values: ['Graphic Materials', 'Audio', 'Text',
                                               'Moving Images']))
  end

  # Labels will be modified from those above by the :media_format_label helper
  it "renders the Media format facet labels and link" do
    expect(page).to have_link "Image"
    expect(page).to have_link "Audio"
    expect(page).to have_link "Text"
    expect(page).to have_link "Moving images"
  end
end
