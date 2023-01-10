# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Full text search', js: true do
  let(:blacklight_config) { CatalogController.blacklight_config }
  let(:solr_conn) { blacklight_config.repository_class.new(blacklight_config).connection }
  let(:id) { 'mt839rq8746aspace_b448325f46df4f13208a3a39ca0377f8' }

  before do
    solr_conn.add({
                    id:,
                    normalized_title_ssm: ['RF Exhibit 352'],
                    level_ssm: ['Item'],
                    parent_ssim: %w[mt839rq8746
                                    aspace_4433c13e043ee40e0858047ed63324a4
                                    aspace_bb4a002a5c12b85a067f7c226f5451cb
                                    aspace_cd582a8f9a0f8e53794a547266abd709],
                    ead_ssi: 'abc123',
                    unitid_ssm: ['H-4528'],
                    full_text_tesimv: ['Some text containing the word rosebud']
                  })
    solr_conn.commit
    visit search_catalog_path q: 'rosebud'
  end

  it 'shows a preview of highlighted hits within document text' do
    click_button 'expand'
    expect(page).to have_content 'Some text containing the word rosebud'
    expect(page).to have_css 'em', text: 'rosebud'
  end

  it 'shows a link to search within the document' do
    expect(page).to have_link 'Search for "rosebud" in document text'
  end
end
