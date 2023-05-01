# frozen_string_literal: true

require "rails_helper"

RSpec.describe EmbedComponent, type: :component do
  let(:view_context) { vc_test_controller.view_context }
  let(:presenter) { Arclight::ShowPresenter.new(document, view_context) }
  let(:document) { instance_double(SolrDocument, media_type:, digital_objects:) }
  let(:params) { {} }
  let(:digital_objects) do
    [instance_double(Arclight::DigitalObject, href: '#', label: 'hi')]
  end

  before do
    allow(view_context).to receive(:search_state).and_return(Blacklight::SearchState.new(params, nil))
    render_inline(described_class.new(presenter:, document:))
  end

  context 'with media format text' do
    let(:media_type) do
      'Text'
    end

    it "shows no warning" do
      expect(page).not_to have_text 'Content warning'
    end
  end

  context 'with media format Graphic Materials' do
    let(:media_type) do
      'Graphic Materials'
    end

    it "shows a warning" do
      expect(page).to have_text 'Content warning'
    end
  end

  context 'with media format Moving Images' do
    let(:media_type) do
      'Moving Images'
    end

    it "shows a warning" do
      expect(page).to have_text 'Content warning'
    end
  end

  context 'with an active search' do
    let(:media_type) { 'Text' }
    let(:params) { { q: 'foo' } }

    it 'stores the search for passing to the viewer' do
      expect(described_class.new(presenter:, document:).query_param).to eq 'foo'
    end
  end
end
