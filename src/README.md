# Mail WAT Source Layout

`../mail.wat` is the single Core module root. It declares shared imports,
memory, and helpers, then includes fragments in a deliberate order.

```text
src/
  state.wat             mailbox/view state and transition helpers
  input.wat             key/input validation when interactive TUI exists
  domain/               mailbox, compose, search, and outbox policy
  views/                one rendering fragment per screen
  providers/            thin WAT adapters for declared provider calls
  strings.wat           stable shared data blocks when needed
```

`host-rs` expands each standalone `;; @include src/path.wat` line in the root
before assembly. Fragments are ordered text inside that same `(module ...)` and
must not open a module themselves. Change the smallest owning fragment, update
the matching document, then run `host-rs check` and `host-rs run`.

Separate Core WASM modules are providers with explicit manifest ABIs, not a way
to split this application's source files.
