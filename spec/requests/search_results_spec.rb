# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "The search result page" do
  let(:page) do
    Capybara::Node::Simple.new(response.body)
  end

  context 'when a facet is selected' do
    it "has a single start over link" do
      get "/?f[date_range_sim][]=1945&q=&search_field=all_fields"

      expect(response).to have_http_status(:ok)
      expect(page).to have_link 'Start Over', count: 1
    end
  end
end
