# frozen_string_literal: true

require "rails_helper"

RSpec.describe EmbedComponent, type: :component do
  let(:presenter) { instance_double(Arclight::ShowPresenter) }
  let(:document) { instance_double(SolrDocument, media_type:, digital_objects:) }
  let(:digital_objects) do
    [instance_double(Arclight::DigitalObject, href: '#', label: 'hi')]
  end

  before do
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
end
