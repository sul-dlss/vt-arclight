# frozen_string_literal: true

# Customized oEmbed viewer that can pass extra parameters to sul-embed
class OembedViewerComponent < Arclight::OembedViewerComponent
  def initialize(resource:, document:, search:)
    super(resource:, document:)

    @search = search
  end

  # Rendered as data-* attributes on the viewer element for Arclight's JS
  def viewer_attrs
    {
      arclight_oembed: true,
      arclight_oembed_url: @resource.href,
      arclight_oembed_search: @search
    }
  end
end
