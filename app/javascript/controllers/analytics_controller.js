import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // We pass an integer ENV value through this meta tag to get it into the controller here
    // In the process the value is transformed into a String
    const debug = document.head.querySelector("meta[name=analytics_debug]").getAttribute("value") === "1"
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());
    // To turn off debug mode, exclude the parameter altogether (cannot just set to false)
    // See https://support.google.com/analytics/answer/7201382?hl=en#zippy=%2Cgoogle-tag-websites
    const args = {}
    if (debug) {
      args["debug_mode"] = debug
    }
    gtag('config', 'G-48Y3Q1L4K0', args)
  }
}
