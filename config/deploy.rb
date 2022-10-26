# frozen_string_literal: true

set :application, "nta-arclight"
set :repo_url, "https://github.com/sul-dlss/nta-arclight.git"

# Default branch is :master so we need to update to main
if ENV['DEPLOY']
  set :branch, 'main'
else
  ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
end

# Default deploy_to directory is /var/www/application-name
set :deploy_to, "/opt/app/nta/nta"

# Default value for :linked_files is []
set :linked_files, %w[config/database.yml config/blacklight.yml]

# Default value for linked_dirs is []
set :linked_dirs, %w[log tmp/pids tmp/cache tmp/sockets vendor/bundle config/settings]

# Update shared_configs before restarting app
before 'deploy:restart', 'shared_configs:update'
