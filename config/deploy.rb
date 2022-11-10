# frozen_string_literal: true

set :application, "vt-arclight"
set :repo_url, "https://github.com/sul-dlss/vt-arclight.git"

# Default branch is :master so we need to update to main
if ENV['DEPLOY']
  set :branch, 'main'
else
  ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
end

# Default deploy_to directory is /var/www/application-name
set :deploy_to, "/opt/app/vt/vt"

# Default value for :linked_files is []
set :linked_files, %w[config/database.yml config/blacklight.yml]

# Default value for linked_dirs is []
set :linked_dirs, %w[log tmp/pids tmp/cache tmp/sockets vendor/bundle config/settings data/fulltext]

# Reindex
before 'deploy:restart', 'index'

# Update shared_configs before restarting app
before 'deploy:restart', 'shared_configs:update'
