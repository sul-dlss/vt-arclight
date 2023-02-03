# frozen_string_literal: true

# # /status for 'upness', e.g. for load balancer
# # /status/all to show all dependencies
# # /status/<name-of-check> for a specific check (e.g. for nagios warning)
OkComputer.mount_at = 'status'

solr_url = ENV.fetch('SOLR_URL', Blacklight.default_index.connection.base_uri)
OkComputer::Registry.register 'solr', OkComputer::HttpCheck.new("#{solr_url}/admin/ping")

redis_url = ENV.fetch('REDIS_URL', 'redis://localhost:6379/')
OkComputer::Registry.register 'redis', OkComputer::RedisCheck.new(url: redis_url)

#------------------------------------------------------------------------------
# NON-CRUCIAL (Optional) checks, avail at /status/<name-of-check>
#   - at individual endpoint, HTTP response code reflects the actual result
#   - in /status/all, these checks will display their result text, but will not affect HTTP response code

# Stacks service
OkComputer::Registry.register 'stacks', OkComputer::HttpCheck.new('https://stacks.stanford.edu')

# OEmbed service
# This check will fail if purl is down.
resource_url = "https://purl.stanford.edu/pv954fv1448"
OkComputer::Registry.register 'embed',
                              OkComputer::HttpCheck.new("https://embed.stanford.edu/iframe/?url=#{resource_url}")

OkComputer.make_optional %w[stacks embed]
