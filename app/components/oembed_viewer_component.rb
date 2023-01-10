# frozen_string_literal: true

# Customized oEmbed viewer that can pass extra parameters to sul-embed
class OembedViewerComponent < Arclight::OembedViewerComponent
  def viewer_attrs
    {
      arclight_oembed: true,
      arclight_oembed_url: @resource.href,
      arclight_oembed_search: params[:search]
    }
  end
end
