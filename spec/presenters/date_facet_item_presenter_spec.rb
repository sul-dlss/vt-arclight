# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DateFacetItemPresenter do
  subject(:presenter) { described_class.new(facet_item, facet_config, view_context, facet_field) }

  let(:facet_item) { Blacklight::Solr::Response::Facets::FacetItem.new(hits: 10, value:) }

  let(:facet_config) { CatalogController.blacklight_config.facet_fields['date_hierarchy'] }
  let(:view_context) { double(search_state: instance_double(Blacklight::SearchState)) }
  let(:facet_field) { double }

  context 'with year granularity' do
    let(:value) { '2019' }

    describe '#label' do
      it 'shows the year' do
        expect(presenter.label).to eq '2019'
      end
    end

    describe '#constraint_label' do
      it 'shows the year' do
        expect(presenter.constraint_label).to eq '2019'
      end
    end
  end

  context 'with month granularity' do
    let(:value) { '2019-12' }

    describe '#label' do
      it 'shows the month name' do
        expect(presenter.label).to eq 'December'
      end
    end

    describe '#constraint_label' do
      it 'shows the month + year' do
        expect(presenter.constraint_label).to eq 'December 2019'
      end
    end
  end

  context 'with day granularity' do
    let(:value) { '2019-12-31' }

    describe '#label' do
      it 'shows the ordinalized date' do
        expect(presenter.label).to eq '31st'
      end
    end

    describe '#constraint_label' do
      it 'shows the whole date' do
        expect(presenter.constraint_label).to eq 'December 31, 2019'
      end
    end
  end
end
