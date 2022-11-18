# frozen_string_literal: true

require 'arclight'

settings do
  provide 'component_traject_config', __FILE__
  provide 'fulltext_data_dir', File.expand_path("#{__dir__}/../../data/fulltext")
end

load_config_file(File.expand_path("#{Arclight::Engine.root}/lib/arclight/traject/ead2_component_config.rb"))

# FULL TEXT FIELDS
to_field 'full_text_tesimv' do |resource, accumulator, _context|
  druid = resource.xpath(".//dao/@href").map(&:value).map do |value|
    value.delete_prefix("https://purl.stanford.edu/")
  end.first
  next unless druid

  filename = "#{settings['fulltext_data_dir']}/#{druid}.txt"
  if File.exist?(filename)
    accumulator << File.read(filename)
  else
    logger.warn("Missing fulltext source: #{filename}")
  end
end

to_field 'language_ssim' do |resource, accumulator, _context|
  raw = resource.xpath('./controlaccess/function[@source="lcsh"]')
  raw.map(&:text).map { |elem| elem.delete_suffix(' language') }.each do |val|
    accumulator << val
  end
end

to_field 'resource_type_ssim' do |resource, accumulator, context|
  level = context.output_hash['level_ssm'].first
  next unless level == 'Item'

  accumulator << resource.xpath('../../../did/unittitle').text
end

to_field 'resource_format_ssim', extract_xpath('./did/physdesc/physfacet')
to_field 'media_format_ssi', extract_xpath('./did/container/@label')
