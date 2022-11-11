# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "The home page" do
  let(:page) do
    Capybara::Node::Simple.new(response.body)
  end

  it "is a custom page that introduces the project" do
    get "/"
    expect(response).to have_http_status(:ok)
    expect(page).to have_text "Virtual Tribunals at Stanford"
    expect(page).to have_text 'Content goes here'
  end
end
