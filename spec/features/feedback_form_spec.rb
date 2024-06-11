# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Feedback form', :js do
  it 'is visible only after clicking the feedback link' do
    visit root_path

    expect(page).to have_no_css('#feedback')

    click_link 'Feedback'
    expect(page).to have_css('#feedback form')
  end
end
