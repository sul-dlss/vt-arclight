# frozen_string_literal: true

# Overrides Arclight to removes the title header and add a content warning
class EmbedComponent < Arclight::EmbedComponent
  VIDEO_TYPE = 'Moving Images'
  IMAGE_TYPE = 'Graphic Materials'

  attr_reader :query_param

  def initialize(document:, presenter:, **)
    super

    # Save the search so we can pass it to the viewer for highlighting
    @query_param = presenter.view_context.search_state.query_param
  end

  def content_warning
    return unless video? || image?

    tag.div t('.content_warning_html'), class: "alert warning"
  end

  def video?
    media_type == VIDEO_TYPE
  end

  def image?
    media_type == IMAGE_TYPE
  end

  delegate :media_type, to: :@document
end
