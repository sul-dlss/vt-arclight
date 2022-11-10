# frozen_string_literal: true

require "rails_helper"

RSpec.describe NullComponent, type: :component do
  it "renders nothing" do
    expect(
      render_inline(described_class.new).to_html
    ).to eq ''
  end
end
