import OembedController from "arclight/oembed_controller";

// Add support for additional parameters
export default class SulEmbedController extends OembedController {
  static values = {
    hideTitle: Boolean,
    search: String,
    ...OembedController.values,
  };

  // Pass extra parameters to sul-embed
  findOEmbedEndPoint(body) {
    return super.findOEmbedEndPoint(body, this.getExtraParams());
  }

  // For a full list of parameters supported by the viewer, see:
  // https://github.com/sul-dlss/sul-embed/blob/main/lib/embed/request.rb
  getExtraParams() {
    return {
      ...(this.hideTitleValue && { hide_title: this.hideTitleValue }),
      ...(this.searchValue && { search: this.searchValue }),
    };
  }
}
