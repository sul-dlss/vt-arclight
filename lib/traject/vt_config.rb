# frozen_string_literal: true

require 'arclight'

settings do
  provide 'component_traject_config', File.join(__dir__, 'vt_component_config.rb')
  provide 'solr_writer.http_timeout', 1200
end

load_config_file(File.expand_path("#{Arclight::Engine.root}/lib/arclight/traject/ead2_config.rb"))
