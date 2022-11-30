# frozen_string_literal: true

require 'arclight'
require_relative './atomic_solr_writer'

settings do
  provide 'writer_class_name', 'Traject::AtomicSolrWriter'
  provide 'component_traject_config', File.join(__dir__, 'vt_component_config.rb')
  provide 'solr_writer.http_timeout', 1200
end

load_config_file(File.expand_path("#{Arclight::Engine.root}/lib/arclight/traject/ead2_config.rb"))
