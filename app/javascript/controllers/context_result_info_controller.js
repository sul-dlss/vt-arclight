import { Controller } from "@hotwired/stimulus"

// Reveal the element if they haven't permanently dismissed it.
export default class extends Controller {
  connect() {
    this.element.hidden = !this.#isSearch || localStorage.getItem('hide-context-result-info')
  }

  disable() {
    localStorage.setItem('hide-context-result-info', true)
  }

  get #isSearch() {
    const urlParams = new URLSearchParams(window.location.search)
    return Boolean(urlParams.get("q"))
  }
}
