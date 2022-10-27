# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "The home page" do
  it "is a custom page that introduces the project" do
    get "/"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include 'Placeholder text'
  end
end
