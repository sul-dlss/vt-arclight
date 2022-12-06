# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "The search result page" do
  let(:page) do
    Capybara::Node::Simple.new(response.body)
  end

  context 'when a facet is selected' do
    it "has a single start over link" do
      get "/nuremberg?f[date][]=1945&q=&search_field=all_fields"

      expect(response).to have_http_status(:ok)
      expect(page).to have_link 'Start Over', count: 1
    end
  end

  context 'when searching for a year' do
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
                      date_hierarchy_ssim: %w[1938 1938-10 1938-10-12 1938-10-13 1938-10-14],
                      ead_ssi: 'abc123',
                      repository_ssm: 'my repository',
                      scopecontent_ssm: ["<p>The collection in the Virtual Tribunal platform contains...</p>",
                                         "<p>The official archives of the International Military Tribunal...</p>"]
                    })
      solr_conn.commit
    end

    it "returns a result" do
      get "/nuremberg?q=1938&search_field=all_fields"

      expect(response).to have_http_status(:ok)
      expect(page).to have_link 'Document books'
    end
  end
end
