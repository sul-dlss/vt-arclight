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
end
