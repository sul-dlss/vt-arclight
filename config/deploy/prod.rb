# frozen_string_literal: true

server 'vt-prod-a.stanford.edu', user: 'vt', roles: %w[web db app]
server 'vt-prod-b.stanford.edu', user: 'vt', roles: %w[web app]

Capistrano::OneTimeKey.generate_one_time_key!
set :rails_env, 'production'
