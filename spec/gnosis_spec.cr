require "spec"
require "../src/gnosis"


Gnosis.use_marks = true
Gnosis.log "Hello World!"

Gnosis.mark "R R R R R R"

r = Gnosis.info "Word"

Gnosis.debug "Return? #{r.class}"