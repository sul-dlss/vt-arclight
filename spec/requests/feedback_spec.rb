# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Sending Feedback" do
  it 'sends the mail' do
    expect do
      post '/feedback', params: { message: "one", name: "Carolyn R. Bertozzi", email: "bert@stanford.edu" }
    end.to change { ActionMailer::Base.deliveries.count }.by(1)

    follow_redirect!
    expect(response.body).to include('Feedback submitted.')
  end
end
