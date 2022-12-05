# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "The home page" do
  let(:page) do
    Capybara::Node::Simple.new(response.body)
  end

  it "is a custom page that introduces the project" do
    get "/"
    expect(response).to have_http_status(:ok)

    # Header
    expect(page).to have_link 'Stanford Libraries', href: 'https://library.stanford.edu/'

    # Masthead
    expect(page).to have_text "Virtual Tribunals at Stanford"

    # Main
    expect(page).to have_text 'Virtual Tribunals is a collaboration'
    expect(page).to have_text 'Archival Collection'
    expect(page).to have_text 'Virtual Tribunals Online Exhibit'
  end

  it "renders the correct badge labels in the Explore the collection section" do
    within ".explore" do
      expect(page).to have_link "Image"
      expect(page).to have_link "Audio"
      expect(page).to have_link "Text"
      expect(page).to have_link "Moving images"
    end
  end
end
