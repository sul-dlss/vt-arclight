# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@github/auto-complete-element", to: "https://cdn.jsdelivr.net/npm/@github/auto-complete-element@3.8.0/+esm"
pin '@popperjs/core', to: 'https://ga.jspm.io/npm:@popperjs/core@2.11.8/dist/umd/popper.min.js'
pin 'bootstrap', to: 'https://ga.jspm.io/npm:bootstrap@5.3.3/dist/js/bootstrap.js'
pin "blacklight", to: "blacklight/blacklight.js"

pin "arclight", to: "arclight/arclight.js"
pin "arclight/oembed_controller", to: "arclight/oembed_controller.js"
pin "arclight/truncate_controller", to: "arclight/truncate_controller.js"
