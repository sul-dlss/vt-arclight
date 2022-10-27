# frozen_string_literal: true

require 'uri'
require 'net/http'

# Client for querying the ArchivesSpace API
class AspaceClient
  attr_reader :url

  def initialize(url: ENV.fetch('ASPACE_URL', nil), user: ENV.fetch('ASPACE_USER', nil),
                 password: ENV.fetch('ASPACE_PASSWORD', nil))
    unless url && user && password
      raise ArgumentError,
            'Please provide the url, user, and password for ArchivesSpace'
    end

    @url = url
    @user = user
    @password = password
  end

  # request Resource EAD from ASpace; returns XML
  # "Resource" is the name for top level containers in ArchivesSpace
  def resource_description(repository_id, resource_id)
    unless repository_id && resource_id
      raise ArgumentError,
            'Please provide the ArchivesSpace Repository ID and Resource ID'
    end

    uri = resource_uri_by_id(repository_id, resource_id)
    # edit the uri to give us resource_descriptions
    uri["resources"] = "resource_descriptions"
    authenticated_get("#{uri}.xml?include_daos=true")
  end

  private

  # get a session token
  def session_token
    @session_token ||= begin
      uri = URI.parse("#{@url}/users/#{@user}/login?password=#{@password}")
      res = Net::HTTP.post_form(uri, {})
      raise StandardError, "Unexpected response code #{res.code}: #{res.read_body}" unless res.is_a?(Net::HTTPOK)

      JSON.parse(res.body)['session']
    end
  end

  # send an authenticated GET request to Aspace
  def authenticated_get(path)
    uri = URI.parse("#{@url}/#{path}")
    req = Net::HTTP::Get.new(uri)
    req['X-ArchivesSpace-Session'] = session_token
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    raise StandardError, "Unexpected response code #{res.code}: #{res.read_body}" unless res.is_a?(Net::HTTPOK)

    # don't parse JSON here; we might get XML or JSON back.
    res.body
  end

  # Get ASpace URI by the resources's ID
  # Returns string in the form of "repositories/<repo_id>/resources/<internal_id>"
  def resource_uri_by_id(repository_id, resource_id)
    # see https://archivesspace.github.io/archivesspace/api/#find-digital-objects-by-digital_object_id
    id_param = CGI.escape(%(["#{resource_id}"]))
    res = authenticated_get("repositories/#{repository_id}/find_by_id/resources?identifier[]=#{id_param}")
    JSON.parse(res).dig("resources", 0, "ref")
  end
end
