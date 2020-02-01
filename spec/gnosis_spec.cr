require "spec"
require "../src/gnosis"


Gnosis.use_marks = true
Gnosis.log "Hello World."
Gnosis.warn "Hello World;"
Gnosis.error "Hello World!"

begin
  raise Exception.new("HELLO, WORLD")
rescue ex
  Gnosis.exception(ex, "Hello. World.")
end

r = Gnosis.info "Word"

Gnosis.debug "Return? #{r.class}"

Gnosis.mark "R R R R R R"