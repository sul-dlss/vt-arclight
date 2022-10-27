# frozen_string_literal: true

namespace :nta do
  # "Resource" is the name for top level containers in ArchivesSpace
  desc 'Download EAD for a Resource in ArchivesSpace to the /data directory'
  task :download_resource, %i[repository_id resource_id] => :environment do |_task, args|
    repository_id = args[:repository_id] || ENV.fetch('ASPACE_REPOSITORY_ID', nil)
    resource_id = args[:resource_id] || ENV.fetch('ASPACE_RESOURCE_ID', nil)

    client = AspaceClient.new
    print "Saving resource #{resource_id} from #{client.url} into /data...\n"

    xml = client.resource_description(repository_id, resource_id)

    # Save the EAD XML to file at /data/<ASPACE_RESOURCE_ID>.xml
    File.open(File.join('data', "#{resource_id}.xml"), 'wb') do |f|
      f.puts xml
    end
  end

  desc 'Index all files in the /data directory'
  task index: :environment do
    ENV['DIR'] ||= 'data'
    ENV['REPOSITORY_ID'] ||= 'icj'
    Rake::Task['arclight:index_dir'].invoke
  end
end
