# frozen_string_literal: true

require 'arclight'

settings do
  provide 'component_traject_config', File.join(__dir__, 'vt_component_config.rb')
  provide 'solr_writer.http_timeout', 1200
end

load_config_file(File.expand_path("#{Arclight::Engine.root}/lib/arclight/traject/ead2_config.rb"))

each_record do |_record, context|
  # Store a hashed version of the id for blacklight dynamic sitemaps
  context.output_hash['hashed_id_ssi'] = [Digest::MD5.hexdigest(context.output_hash['id'].first)]
end
