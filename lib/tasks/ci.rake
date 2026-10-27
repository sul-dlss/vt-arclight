# frozen_string_literal: true

desc "Run test suite"
task ci: :environment do
  with_solr do
    Rake::Task['spec'].invoke
  end
end
