# frozen_string_literal: true

require 'fileutils'

namespace :vt do
  # "Resource" is the name for top level containers in ArchivesSpace
  desc 'Download EAD for a Resource in ArchivesSpace to the /data directory'
  task :download_resource, %i[repository_id resource_id] => :environment do |_task, args|
    repository_id = args[:repository_id] || ENV.fetch('ASPACE_REPOSITORY_ID', nil)
    resource_id = args[:resource_id] || ENV.fetch('ASPACE_RESOURCE_ID', nil)

    client = AspaceClient.new
    xml = client.resource_description(repository_id, resource_id)

    ENV['DIR'] ||= 'public/data'
    print "Saving resource #{resource_id} from #{client.url} into #{ENV.fetch('DIR', nil)}...\n"

    # Save the EAD XML to file at public/data/<ASPACE_RESOURCE_ID>.xml
    FileUtils.mkdir_p ENV.fetch('DIR', nil)
    File.open(File.join(ENV.fetch('DIR', nil), "#{resource_id}.xml"), 'wb') do |f|
      # format the XML
      ead = Nokogiri::XML(xml, &:noblanks)
      f.puts ead.to_xml(indent: 2)
    end
  end

  desc 'Index all files in the data directory'
  task index: :environment do
    ENV['DIR'] ||= 'public/data'
    ENV['REPOSITORY_ID'] ||= 'icj'
    Rake::Task['arclight:index_dir'].invoke
  end
end
