# Gnosis

> Uniform colorized logger for decentral systems.

Many processes running together in a mesh need uniformed logs,
especially when posting to `syslogd` through `Docker`.

This shard allows those individual processes to share a log format,
and later it will also receive those messages and handle them
without involving `syslogd`, as a process in the mesh itself.

This shard was extracted from [`Artillery`](https://github.com/abstractive/artillery.cr).

## Installation

Add this to your application's `shard.yml`:

```yaml
mongo:
  github: abstractive/gnosis.cr
  branch: release
```

# Usage

```crystal
require "gnosis"

Gnosis.info "Hello World."  #de Or .log
Gnosis.error "Hello World!"
Gnosis.warn "Hello World?"
Gnosis.debug "Hello World:"
```

# License

`MIT` See [LICENSE](LICENSE) for more details.