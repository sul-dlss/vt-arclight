// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import bootstrap from "bootstrap"
window.bootstrap = bootstrap // Required for Blacklight 7 so it can manage the modals
import "blacklight"
import "arclight"

import dialogPolyfill from "dialog-polyfill"
Blacklight.onLoad(() => {
  var dialog = document.querySelector('dialog');
  dialogPolyfill.registerDialog(dialog);

  // Initialize Bootstrap tooltips
  const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
  const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl))
})
