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
    expect(page).to have_text 'Virtual Tribunals is a major initiative'
    expect(page).to have_text 'Taube Archive of the International Military Tribunal (IMT) at Nuremberg, 1945-46'
    expect(page).to have_text 'Virtual Tribunals Spotlight exhibit'
  end
end
