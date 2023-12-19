# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SolrDocument do
  let(:doc) { described_class.new(attrs) }

  describe '#extent' do
    subject { doc.extent }

    context 'with 1 item and a separate pages value (ArcLight 1.0 index)' do
      let(:attrs) { { extent_ssm: ['1 item(s)', '24 pages'] } }

      it { is_expected.to be_empty }
    end

    context 'with 1 item and a concatenated pages value (ArcLight 1.1 index)' do
      let(:attrs) { { extent_ssm: ['1 item(s) 24 pages'] } }

      it { is_expected.to be_empty }
    end

    context 'with more than 1 item' do
      let(:attrs) { { extent_ssm: ['2 item(s)'] } }

      it { is_expected.to include '2 item(s)' }
    end
  end
end
