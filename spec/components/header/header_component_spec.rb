# frozen_string_literal: true

require "rails_helper"

RSpec.describe Header::HeaderComponent, type: :component do
  context 'when on the Virtual Tribunals landing page' do
    let(:blacklight_config) { vc_test_controller.blacklight_config }

    before do
      allow(vc_test_controller).to receive_messages(current_user: nil, main_page?: true)
      render_inline(described_class.new(blacklight_config:))
    end

    it "renders something useful" do
      expect(page).to have_text "Virtual Tribunals at Stanford"
    end
  end
end
