# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "The collection page" do
  let(:page) do
    Capybara::Node::Simple.new(response.body)
  end

  let(:search_service) { instance_double(Blacklight::SearchService, fetch: doc) }
  let(:doc) do
    SolrDocument.new(id: 'mt839rq8746',
                     timestamp: 2.days.ago.iso8601,
                     level_ssm: ['collection'],
                     repository_ssm: ['International Court of Justice'],
                     ead_ssi: "mt839rq8746",
                     '_root_' => 'mt839rq8746')
  end

  before do
    allow(Blacklight::SearchService).to receive(:new).and_return(search_service)
  end

  it "is a custom page that introduces the project" do
    get "/catalog/mt839rq8746"
    expect(response).to have_http_status(:ok)

    expect(page).to have_text 'Contact'
    expect(page).to have_link 'library@icj-cij.org'

    expect(page).to have_text 'Digital collection stewarded by'
    expect(page).to have_link 'Center for Human Rights and International Justice'
    expect(page).to have_link 'Stanford University Libraries'
  end
end
