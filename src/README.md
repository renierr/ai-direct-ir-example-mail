# Mail WAT Source Layout

`../mail.wat` is the root `(component ...)`. It asks for the WASI 0.2
boundary with `;; @wasi`, holds the one `(core module $main ...)` with shared
imports, helpers and the lifted `run` entry, then includes fragments in a
deliberate order.

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
`(core module $main ...)` and must not open a module themselves. Change the smallest
owning fragment, update the matching document, then run `air check` and
`air run`.

Display text lives in a named data segment, so no fragment restates a byte
count *or* an address. The root declares the region once with
`;; @data 0x1000..0x8000`; `src/views/inbox.wat` declares `(data $inbox "...")`
unplaced and reads `$inbox.ptr` / `$inbox.len`, which `air` derives from the
segment. Editing the text is the whole change.

The root owns the boundary and the fragments own behaviour: `$print` and the
cached stdout handle live in `mail.wat`, and a view is an ordinary function
(`$view.inbox`) that `run` calls.

Separate Core WASM modules are providers with explicit manifest ABIs, not a way
to split this application's source files.
