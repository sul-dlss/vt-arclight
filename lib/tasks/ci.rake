# frozen_string_literal: true

def with_solr(&)
  SolrWrapper.wrap do |solr|
    solr.with_collection(&)
  end
end

desc "Run test suite"
task ci: :environment do
  with_solr do
    Rake::Task['vt:seed'].invoke
    Rake::Task['spec'].invoke
  end
end
