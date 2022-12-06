# frozen_string_literal: true

module VirtualTribunals
  ##
  # A utility class to normalize titles
  # As opposed to Arclight Core, we do not include the date
  class NormalizedTitle
    # Arclight indexer may pass a date or other params in addition to the title, but we won't use them
    # @param [String] `title` from the `unittitle`
    def initialize(title, *_args)
      @title = title.gsub(/\s*,\s*$/, '').strip if title.present?
    end

    # This is the method called by Arclight's indexer
    # @return [String] the normalized title
    def to_s
      normalize
    end

    private

    attr_reader :title

    def normalize
      raise Arclight::Exceptions::TitleNotFound if title.blank?

      title
    end
  end
end
