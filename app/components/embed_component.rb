# frozen_string_literal: true

# Overrides Arclight to removes the title header and add a content warning
class EmbedComponent < Arclight::EmbedComponent
  VIDEO_TYPE = 'Moving Images'
  IMAGE_TYPE = 'Graphic Materials'

  def content_warning
    return unless video? || image?

    tag.div t('.content_warning_html'), class: "alert global-warning"
  end

  def video?
    media_format == VIDEO_TYPE
  end

  def image?
    media_format == IMAGE_TYPE
  end

  delegate :media_format, to: :@document
end
