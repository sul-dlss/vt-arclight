# frozen_string_literal: true

server 'nta-prod-a.stanford.edu', user: 'nta', roles: %w[web db app]
server 'nta-prod-b.stanford.edu', user: 'nta', roles: %w[web app]

Capistrano::OneTimeKey.generate_one_time_key!
set :rails_env, 'production'
