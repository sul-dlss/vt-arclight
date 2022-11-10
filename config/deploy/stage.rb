# frozen_string_literal: true

server 'vt-stage-a.stanford.edu', user: 'vt', roles: %w[web db app indexer]
server 'vt-stage-b.stanford.edu', user: 'vt', roles: %w[web app]

Capistrano::OneTimeKey.generate_one_time_key!
set :rails_env, 'production'
