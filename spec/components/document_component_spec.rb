# frozen_string_literal: true

require "rails_helper"

RSpec.describe DocumentComponent, type: :component do
  let(:presenter) do
    Arclight::ShowPresenter.new(document, controller.view_context, CatalogController.blacklight_config)
  end

  before do
    allow(controller).to receive(:current_or_guest_user).and_return(nil)
    render_inline(described_class.new(presenter:))
  end

  context 'with a collection that has online content (overrides Arclight::DocumentComponent)' do
    let(:document) { SolrDocument.new(level_ssm: ['collection'], has_online_content_ssim: ['true']) }

    it "doesn't show the online filter" do
      expect(page).not_to have_text 'Online content'
    end
  end

  context 'with a component with metadata' do
    let(:document) do
      SolrDocument.new(level_ssm: ['Item'],
                       normalized_date_ssm: ['1946'],
                       scopecontent_ssm: ["<p>The collection in the Virtual Tribunal platform contains...</p>",
                                          "<p>The official archives of the International Military Tribunal...</p>"],
                       containers_ssim: ['Box 25'],
                       language_ssim: ['German'],
                       resource_type_ssim: ['Exhibits'],
                       resource_format_ssim: ['Photo albums'],
                       unitid_ssm: ['H-5006'],
                       media_format_ssi: ['Graphic Materials'])
    end

    it "shows the data" do
      expect(page).to have_text 'Scope and content:'
      expect(page).to have_text 'The collection in the Virtual Tribunal'
      expect(page).to have_text 'The official archives of the International'

      expect(page).to have_text 'Container:'
      expect(page).to have_text 'Box 25'

      expect(page).to have_text 'Resource identifier:'
      expect(page).to have_text 'H-5006'

      expect(page).to have_text 'Date:'
      expect(page).to have_text '1946'

      expect(page).to have_text 'Resource format:'
      expect(page).to have_text 'Photo albums'

      expect(page).to have_text 'Resource type:'
      expect(page).to have_text 'Exhibits'

      expect(page).to have_text 'Language:'
      expect(page).to have_text 'German'

      # Label will be modified from the "Graphic Materials" above by the :media_format_label helper
      expect(page).to have_text 'Media format'
      expect(page).to have_text 'Image'
    end
  end
end
