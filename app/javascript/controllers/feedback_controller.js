import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['container']

  toggle(e) {
    e.preventDefault()
    this.containerTarget.classList.toggle('open')
  }

  reset(e) {
    this.containerTarget.classList.toggle('open')
  }
}
