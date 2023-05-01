# frozen_string_literal: true

require "rails_helper"

RSpec.describe VirtualTribunals::HeaderComponent, type: :component do
  let(:blacklight_config) { vc_test_controller.blacklight_config }

  before do
    allow(vc_test_controller).to receive(:current_user).and_return(nil)
    render_inline(described_class.new(blacklight_config:))
  end

  it "renders something useful" do
    expect(page).to have_text "Virtual Tribunals at Stanford"
  end
end
