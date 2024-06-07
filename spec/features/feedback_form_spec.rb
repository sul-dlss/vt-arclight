# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Feedback form', :js do
  it 'is visible only after clicking the feedback link' do
    visit root_path

    feedback = page.find_by_id('feedback', visible: false)
    expect(feedback.native.style('visibility')).to eq('hidden')

    click_link 'Feedback'
    expect(page).to have_css('#feedback form')
  end
end
