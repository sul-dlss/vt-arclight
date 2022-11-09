# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "The Nuremberg landing page" do
  let(:page) do
    Capybara::Node::Simple.new(response.body)
  end

  it "is a custom page that introduces the project" do
    get "/nuremberg"
    expect(response).to have_http_status(:ok)
    expect(page).to have_text "Taube Archive of the International Military Tribunal (IMT) at Nuremberg, 1945-46"
    expect(page).to have_text 'Placeholder text'
    expect(page).to have_link "Bookmarks"
    expect(page).to have_link "History"
  end
end
