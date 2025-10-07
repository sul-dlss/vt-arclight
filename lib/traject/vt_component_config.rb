# frozen_string_literal: true

require 'arclight'
require_relative 'virtual_tribunals/normalized_title'

settings do
  provide 'component_traject_config', __FILE__
  provide 'title_normalizer', 'VirtualTribunals::NormalizedTitle'
  # ArcLight 1.1 introduced a different identifier format. Providing this
  # configuration maintains our current identifier format.
  # See: https://github.com/projectblacklight/arclight/pull/1478
  provide 'component_identifier_format', '%<root_id>s%<ref_id>s'
end

load_config_file(File.expand_path("#{Arclight::Engine.root}/lib/arclight/traject/ead2_component_config.rb"))

# FULL TEXT FIELDS
to_field 'full_text_tesimv' do |resource, accumulator, context|
  # Records in series "Audio recordings of proceedings" do not have associated fulltext files
  parent_series = resource.xpath('ancestor::c[@level="series"]/did/unittitle').text
  next if parent_series == "Audio recordings of proceedings"

  druid = resource.xpath('./did/dao/@href').map(&:value).map do |value|
    value.delete_prefix("https://purl.stanford.edu/")
  end.first
  next unless druid

  # context.settings['root'] allows us to recieve -s settings passed from the command line
  filename = "#{context.settings['root'].settings['fulltext_data_dir']}/#{druid}.txt"
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

  accumulator << resource.xpath('ancestor::c[@level="series"]/did/unittitle').text
end

to_field 'resource_format_ssim', extract_xpath('./did/physdesc/physfacet')
to_field 'media_type_ssi', extract_xpath('./did/container/@label')

to_field 'date_hierarchy_ssim', extract_xpath('./did/unitdate/@normal') do |_record, accumulator|
  next unless accumulator.any?

  date_ranges = accumulator.flat_map do |date|
    start_date, end_date = date.split('/', 2)

    # set the date range to include the entire year for ranges like "1945/1945"
    start_date = "#{start_date}-01-01" if start_date.length == 4
    end_date = "#{end_date}-12-31" if end_date&.length == 4

    begin
      if end_date.nil?
        Date.parse(start_date)..Date.parse(start_date)
      else
        Date.parse(start_date)..Date.parse(end_date)
      end
    rescue Date::Error
      logger.warn("Invalid date range: #{date}")
      next
    end
  end

  facet_data = date_ranges.compact.flat_map do |date_range|
    date_range.flat_map do |date|
      [date.strftime('%Y'), date.strftime('%Y-%m'), date.strftime('%Y-%m-%d')]
    end
  end

  accumulator.replace(facet_data.uniq)
end

each_record do |_record, context|
  # Store a hashed version of the id for blacklight dynamic sitemaps
  context.output_hash['hashed_id_ssi'] = [Digest::MD5.hexdigest(context.output_hash['id'].first)]
end
