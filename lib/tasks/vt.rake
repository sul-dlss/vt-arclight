# frozen_string_literal: true

require 'fileutils'

# rubocop:disable Metrics/BlockLength
namespace :vt do
  # "Resource" is the name for top level containers in ArchivesSpace
  desc 'Download EAD for a Resource in ArchivesSpace to the /data directory'
  task :download_resource, %i[repository_id resource_id] => :environment do |_task, args|
    repository_id = args[:repository_id] || ENV.fetch('ASPACE_REPOSITORY_ID', nil)
    resource_id = args[:resource_id] || ENV.fetch('ASPACE_RESOURCE_ID', nil)

    client = AspaceClient.new
    xml = client.resource_description(repository_id, resource_id)
    directory = ENV.fetch('DIR', 'public/data')

    print "Saving resource #{resource_id} from #{client.url} into #{directory}...\n"

    # Save the EAD XML to file at public/data/<ASPACE_RESOURCE_ID>.xml
    FileUtils.mkdir_p directory
    File.open(File.join(directory, "#{resource_id}.xml"), 'wb') do |f|
      # format the XML
      ead = Nokogiri::XML(xml, &:noblanks)
      f.puts ead.to_xml(indent: 2)
    end
  end
  # rubocop:enable Metrics/BlockLength

  desc 'Index a the collection EAD file'
  task index: :environment do
    file = ENV.fetch('FILE', 'public/data/mt839rq8746.xml')
    fulltext_data_dir = File.expand_path("#{__dir__}/../../data/fulltext")
    index(file, fulltext_data_dir)
  end

  desc 'Index a sample EAD file and its associated fulltext transcripts'
  task seed: :environment do
    # Use the data from fixtures to seed the index
    file = ENV.fetch('FILE', 'spec/fixtures/ead/seed.xml')
    fulltext_data_dir = File.expand_path("#{__dir__}/../../spec/fixtures/fulltext")
    index(file, fulltext_data_dir)
  end

  def index(file, fulltext_data_dir)
    solr_url = ENV.fetch('SOLR_URL', Blacklight.default_index.connection.base_uri)
    sh "bin/traject -u #{solr_url} -i xml -c lib/traject/vt_config.rb -s repository=icj -s fulltext_data_dir=#{fulltext_data_dir} #{file}" # rubocop:disable Layout/LineLength
  end
end
