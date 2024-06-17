# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FullTextResultComponent, type: :component do
  let(:view_context) { vc_test_controller.view_context }
  let(:field_config) { Blacklight::Configuration::Field.new(key: 'ftkey', field: 'fulltext', label: 'Full Text') }
  let(:document) { SolrDocument.new(id: 123, fulltext: ['my text']) }
  let(:field) { Blacklight::FieldPresenter.new(view_context, document, field_config) }
  let(:params) { {} }

  before do
    allow(view_context).to receive(:search_state).and_return(Blacklight::SearchState.new(params, nil))
    render_inline(described_class.new(field:))
  end

  it 'renders the full text content' do
    expect(page).to have_css '#ftkey-123', text: 'my text'
  end

  it 'renders a button to expand the full text preview' do
    expect(page).to have_button 'expand'
  end

  context 'with a search active' do
    let(:params) { { q: 'mytext' } }

    it 'renders a link to search within the document' do
      expect(page).to have_link 'Search for "mytext" in document text', href: '/catalog/123?q=mytext'
    end
  end
end
