# frozen_string_literal: true

require 'rails_helper'
require 'traject/atomic_solr_writer'

RSpec.describe Traject::AtomicSolrWriter do
  subject(:writer) { described_class.new(settings) }

  let(:settings) { { 'batch_size' => 3, 'solr.url' => 'http://example.com', 'solr_json_writer.http_client' => stub_solr_client } }
  let(:stub_solr_client) { instance_double(HTTPClient) }
  let(:traject_output) do
    {
      'id' => ['collection'],
      'sort_isi' => [0],
      'components' => [
        { 'id' => ['1'], 'sort_isi' => [1], 'parent_id_ssi' => ['collection'], 'components' => [
          { 'id' => ['1.1'], 'sort_isi' => [2], 'parent_id_ssi' => ['1'] }
        ] },
        { 'id' => ['2'], 'sort_isi' => [3], 'parent_id_ssi' => ['collection'] },
        { 'id' => ['3'], 'sort_isi' => [4], 'parent_id_ssi' => ['collection'] },
        { 'id' => ['4'], 'sort_isi' => [5], 'parent_id_ssi' => ['collection'], 'components' => [
          { 'id' => ['4.1'], 'sort_isi' => [6], 'parent_id_ssi' => ['4'] },
          { 'id' => ['4.2'], 'sort_isi' => [7], 'parent_id_ssi' => ['4'], 'components' => [
            { 'id' => ['4.2.1'], 'sort_isi' => [8], 'parent_id_ssi' => ['4.2'] },
            { 'id' => ['4.2.2'], 'sort_isi' => [9], 'parent_id_ssi' => ['4.2'] }
          ] }
        ] },
        { 'id' => ['5'], 'sort_isi' => [10], 'parent_id_ssi' => ['collection'] }
      ]
    }
  end

  describe '#send_batch' do
    # rubocop:disable RSpec/ExampleLength
    it 'chunks the graph into manageable sized pieces' do
      bodies = []

      allow(stub_solr_client).to receive(:post) do |_url, body, _headers|
        bodies << body

        instance_double(HTTP::Message, status: 200)
      end

      writer.send_batch([Traject::Indexer::Context.new.tap { |context| context.output_hash = traject_output }])

      expect(stub_solr_client).to have_received(:post).exactly(4).times

      json = bodies.map { |b| JSON.parse(b) }

      # the first chunk is the collection with as many components as we can fit
      expect(json[0]).to match_array(hash_including('id' => ['collection']))

      # the second chunk picks up where the first left off, and has to do an
      # atomic update to the collection to add the next few children
      expect(json[1]).to match_array(hash_including('id' => ['collection'],
                                                    'components' => { 'add' => [
                                                      hash_including('id' => ['2']),
                                                      hash_including('id' => ['3']),
                                                      hash_including('id' => ['4'])
                                                    ] }))

      # the third chunk adds components to a child of the collection
      expect(json[2]).to match_array(hash_including('id' => ['4'],
                                                    'components' => { 'add' => [hash_including('id' => ['4.1']),
                                                                                hash_including(
                                                                                  'id' => ['4.2'], 'components' => [
                                                                                    hash_including('id' => ['4.2.1'])
                                                                                  ]
                                                                                )] }))

      # and the final chunk adds the remaining nodes
      expect(json[3]).to match_array([
                                       hash_including('id' => ['4.2'],
                                                      'components' => { 'add' => [hash_including('id' => ['4.2.2'])] }),
                                       hash_including('id' => ['collection'],
                                                      'components' => { 'add' => [hash_including('id' => ['5'])] })
                                     ])
    end
    # rubocop:enable RSpec/ExampleLength
  end
end
