# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.0/dist/umd/popper.min.js"
pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.1.3/dist/js/bootstrap.js"
pin "blacklight", to: "blacklight/blacklight.js"
pin "dialog-polyfill", to: "https://ga.jspm.io/npm:dialog-polyfill@0.5.6/dist/dialog-polyfill.js"

pin "arclight", to: "arclight/arclight.js"
pin "arclight/oembed_viewer", to: "arclight/oembed_viewer.js"
pin "arclight/truncator", to: "arclight/truncator.js"
