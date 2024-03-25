# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

pin "stimulus-use", to: "https://ga.jspm.io/npm:stimulus-use@0.51.3/dist/index.js"
pin "stimulus-dropdown", to: "https://ga.jspm.io/npm:stimulus-dropdown@2.1.0/dist/stimulus-dropdown.mjs"
pin "hotkeys-js", to: "https://ga.jspm.io/npm:hotkeys-js@3.10.2/dist/hotkeys.esm.js"

pin_all_from "app/javascript/controllers", under: "controllers"
