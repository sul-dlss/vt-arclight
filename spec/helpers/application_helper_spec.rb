# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Layout/LineLength
RSpec.describe ApplicationHelper do
  describe '#render_date_facet_links' do
    it 'is html safe' do
      expect(helper.render_date_facet_links(value: ['anything'])).to be_html_safe
    end

    context 'when the value is a single day' do
      let(:value) { ['2019-01-01'] }

      it 'returns a facet link for that day' do
        expect(helper.render_date_facet_links(value:)).to eq(
          '<a href="/nuremberg?f%5Bdate%5D%5B%5D=2019-01-01">2019-01-01</a>'
        )
      end
    end

    context 'when the value is a date range as a single string' do
      let(:value) { ['2019-01-01 to 2019-01-31'] }

      it 'returns separate facet links for each day' do
        expect(helper.render_date_facet_links(value:)).to eq(
          '<a href="/nuremberg?f%5Bdate%5D%5B%5D=2019-01-01">2019-01-01</a> to <a href="/nuremberg?f%5Bdate%5D%5B%5D=2019-01-31">2019-01-31</a>'
        )
      end
    end

    context 'when the value is two separate days' do
      let(:value) { %w[2019-01-01 2019-01-31] }

      it 'returns separate facet links for each day' do
        expect(helper.render_date_facet_links(value:)).to eq(
          '<a href="/nuremberg?f%5Bdate%5D%5B%5D=2019-01-01">2019-01-01</a>, <a href="/nuremberg?f%5Bdate%5D%5B%5D=2019-01-31">2019-01-31</a>'
        )
      end
    end

    context 'when the value is a single year' do
      let(:value) { ['2019'] }

      it 'returns a facet link for that year' do
        expect(helper.render_date_facet_links(value:)).to eq(
          '<a href="/nuremberg?f%5Bdate%5D%5B%5D=2019">2019</a>'
        )
      end
    end

    context 'when the value has a timestamp' do
      let(:value) { ['2019-01-01 from 11:35 - 11:47'] }

      it 'returns a facet link that only covers the date portion' do
        expect(helper.render_date_facet_links(value:)).to eq(
          '<a href="/nuremberg?f%5Bdate%5D%5B%5D=2019-01-01">2019-01-01</a> from 11:35 - 11:47'
        )
      end
    end
  end
end
# rubocop:enable Layout/LineLength
