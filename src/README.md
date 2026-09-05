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

`air` expands each standalone `;; @include src/path.wat` line in the root
before assembly, at any nesting depth; every include path is relative to the
directory holding `mail.wat`. Fragments are ordered text inside that same
`(module ...)` and must not open a module themselves. Change the smallest
owning fragment, update the matching document, then run `air check` and
`air run`.

Display text lives in a named data segment, so no fragment restates a byte
count. `src/views/inbox.wat` declares `(data $inbox (i32.const 0x1000) ...)`
and reads `$inbox.ptr` / `$inbox.len`, which `air` derives from the
segment; editing the text is enough.

Separate Core WASM modules are providers with explicit manifest ABIs, not a way
to split this application's source files.
