# Mail Client Architecture

## Product Boundary

This is a terminal mail client, not a mail protocol or database reimplementation.
The WAT application owns visible behavior. Reusable providers own difficult,
security-sensitive implementation work.

| Layer | Responsibility |
|---|---|
| `mail.wat` + `src/` | Root module plus modular navigation, compose/reply, search, and presentation policy |
| `mail-store` | SQLite database, schema, migrations, local cache, transactions |
| `mail-sync` | IMAP or JMAP synchronization, TLS, protocol parsing, retries |
| `mail-submit` | SMTP submission, TLS, delivery/rejection errors |
| `tui` | Terminal dimensions, key input, layout, rendering, cleanup |
| Secret provider | OS keychain/OAuth token lifecycle; secrets never enter project files |

## Account Configuration

Application configuration should contain account names and provider references,
not secrets. A future local ignored configuration may name an account:

```toml
[accounts.personal]
address = "me@example.test"
store = "mail-store"
sync = "mail-sync"
submit = "mail-submit"
```

Authentication belongs to a provider-managed keychain or OAuth flow. The app
receives success/failure states, never unrestricted credential material.

## Source Structure

`mail.wat` declares the one Core WASM module, shared memory/imports, and ordered
`;; @include src/path.wat` lines. Product-owned WAT lives by responsibility in
`src/`: state transitions, input validation, domain policy, views, shared
strings, and thin provider adapters. The include fragments are textual parts of
one module. A separate Core module is reserved for a declared provider ABI, not
used merely to organize application source.

## Offline-First State

The store is authoritative for the displayed mailbox. Sync updates it in a
transaction; composing queues an outbox message locally; submission marks it
sent only after provider confirmation. This makes navigation usable offline and
turns transient network failures into visible retryable state rather than lost
mail.
