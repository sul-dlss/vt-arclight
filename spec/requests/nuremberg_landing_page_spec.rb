# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "The Nuremberg landing page" do
  let(:page) do
    Capybara::Node::Simple.new(response.body)
  end

  it "is a custom page that introduces the project" do
    get "/nuremberg"
    expect(response).to have_http_status(:ok)

    # Header
    expect(page).to have_link 'Stanford Libraries', href: 'https://library.stanford.edu/'
    expect(page).to have_link "Bookmarks"
    expect(page).to have_link "History"

    # Masthead
    expect(page).to have_text "Taube Archive of the International Military Tribunal (IMT) at Nuremberg, 1945-46"

    # Main
    expect(page).to have_text 'items in this collection are searchable and viewable in digital form'
  end
end
