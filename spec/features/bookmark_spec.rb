# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Bookmark item", js: true do
  let(:blacklight_config) { CatalogController.blacklight_config }
  let(:solr_conn) { blacklight_config.repository_class.new(blacklight_config).connection }
  let(:id) { 'mt839rq8746aspace_b2d40ef7acf229edec643750a8240999' }

  before do
    solr_conn.add({
                    id:,
                    normalized_title_ssm: ['Document books'],
                    level_ssm: ['Series'],
                    collection_sim: ['some collection'],
                    parent_ssim: %w[def ghi],
                    # parent_unittitles_ssm: %w[DEF GHI],
                    ead_ssi: 'abc123',
                    repository_ssm: 'my repository',
                    scopecontent_ssm: ["<p>The collection in the Virtual Tribunal platform contains...</p>",
                                       "<p>The official archives of the International Military Tribunal...</p>"]
                  })
    solr_conn.commit
  end

  it "bookmark an item" do
    visit "/catalog/#{id}"

    check 'Bookmark'

    # This selector keeps trying until the javascript has finished updating the label
    expect(page).to have_xpath('.//label/span/span[contains(text(), "In Bookmarks")]', wait: 10)

    click_link 'Bookmarks'

    expect(page).to have_link 'Document books'
  end
end
