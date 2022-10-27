# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AspaceClient do
  describe '#initialize' do
    it 'fails without the url arg' do
      expect { described_class.new(url: nil, user: 'user', password: 'password') }.to raise_error(ArgumentError)
    end

    it 'fails without the user arg' do
      expect do
        described_class.new(url: 'http://example.com:8089', user: nil, password: 'password')
      end.to raise_error(ArgumentError)
    end

    it 'fails without the password arg' do
      expect do
        described_class.new(url: 'http://example.com:8089', user: 'user', password: nil)
      end.to raise_error(ArgumentError)
    end
  end

  describe '#resource_description' do
    let(:url) { 'http://example.com:8089' }
    let(:user) { 'aspace_user' }
    let(:password) { 'aspace_password' }
    let(:client) { described_class.new(url:, user:, password:) }

    before do
      # Authentication request
      stub_request(:post,
                   "#{url}/users/#{user}/login?password=#{password}").to_return(body: { session: 'token1' }.to_json)

      # Find resource internal location by ID request
      id_param = CGI.escape(%(["321"]))
      stub_request(:get, "#{url}/repositories/2/find_by_id/resources?identifier[]=#{id_param}").to_return(body: {
        resources: [{ ref: "repositories/2/resources/10208" }]
      }.to_json)
    end

    it 'fails if you do not pass repository id' do
      expect { client.resource_description(nil, '123') }.to raise_error(ArgumentError)
    end

    it 'fails if you do not pass resource id' do
      expect { client.resource_description('abc', nil) }.to raise_error(ArgumentError)
    end

    it 'sends an authenticated request with correct auth header to the resource_desriptions address' do
      # Get resource_description request
      stub_request(:get, "#{url}/repositories/2/resource_descriptions/10208.xml?include_daos=true")
      client.resource_description('2', '321')
      expect(WebMock).to have_requested(:get,
                                        "#{url}/repositories/2/resource_descriptions/10208.xml?include_daos=true").with(headers: { 'X-ArchivesSpace-Session' => 'token1' }).once # rubocop:disable Layout/LineLength
    end

    it 'returns an error' do
      # Get resource_description request that returns an error
      stub_request(:get,
                   "#{url}/repositories/2/resource_descriptions/10208.xml?include_daos=true").to_raise(Net::HTTPBadResponse) # rubocop:disable Layout/LineLength
      expect { client.resource_description('2', '321') }.to raise_error(StandardError)
    end
  end
end
