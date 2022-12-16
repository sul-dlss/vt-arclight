import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const debug = Boolean(document.head.querySelector("meta[name=analytics_debug]").getAttribute("value"))
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());
    gtag('config', 'G-48Y3Q1L4K0', {'debug_mode': debug});
  }
}
