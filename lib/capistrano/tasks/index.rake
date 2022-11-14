# frozen_string_literal: true

task index: 'deploy:set_rails_env' do
  on roles(:indexer) do
    within release_path do
      with rails_env: fetch(:rails_env) do
        rake 'vt:index'
      end
    end
  end
end
