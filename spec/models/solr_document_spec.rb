# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SolrDocument do
  let(:doc) { described_class.new(attrs) }

  describe '#extent' do
    subject { doc.extent }

    context 'with 1' do
      let(:attrs) { { extent_ssm: '1 item(s)' } }

      it { is_expected.to be_nil }
    end

    context 'with more than 1' do
      let(:attrs) { { extent_ssm: '2 item(s)' } }

      it { is_expected.to eq '2 item(s)' }
    end
  end
end
