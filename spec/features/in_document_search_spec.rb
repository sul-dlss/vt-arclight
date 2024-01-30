# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Highlighted search terms in viewer", js: true do
  let(:blacklight_config) { CatalogController.blacklight_config }
  let(:solr_conn) { blacklight_config.repository_class.new(blacklight_config).connection }
  let(:id) { 'mt839rq8746aspace_b2d40ef7acf229edec643750a8240999' }

  before do
    solr_conn.add({
                    ead_ssi: "ead123",
                    id: "mt839rq8746aspace_81456f71f2a1634dd150095dfd2c495b",
                    ref_ssi: "aspace_81456f71f2a1634dd150095dfd2c495b",
                    component_level_isim: [1],
                    unitid_ssm: ["H-0668"],
                    has_online_content_ssim: ["true"],
                    text: ["H-0668"],
                    full_text_tesimv: ["justice"],
                    level_ssm: ["Item"],
                    level_ssim: ["Item"],
                    digital_objects_ssm: ["{\"label\":\"Hermann GOERING - No. 1\",\"href\":\"https://purl.stanford.edu/kh535qr4415\"}"]
                  })
    solr_conn.commit
  end

  it "opens the viewer with highlighted search terms", js: true do
    # search results page
    visit "/nuremberg?search_field=all_fields&q=justice"

    within first('article') do
      click_link 'Search for "justice" in document text'
    end

    # iframe containing sul-embed/mirador viewer
    within_frame do
      # buttons are present
      expect(page.find('h3')).to have_text 'Search'
      expect(page.find('h3')).to have_text 'clear'

      # sidebar is open
      page.find('.mirador-companion-area-left')

      # input is populated with the search term
      page.find('input[value="justice"]')
    end
  end
end
