// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import bootstrap from "bootstrap"
window.bootstrap = bootstrap // Required for Blacklight 7 so it can manage the modals
import "blacklight"
  import $ from "jquery"
  window.$ = $ // required by arclight
  window.jQuery = $ // required by arclight/responsive_truncator.js
  import "arclight"
import dialogPolyfill from "dialog-polyfill"
Blacklight.onLoad(() => {
  var dialog = document.querySelector('dialog');
  dialogPolyfill.registerDialog(dialog);
})
