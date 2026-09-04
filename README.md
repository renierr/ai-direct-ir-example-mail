# AI-Direct IR Example: Mail

An experimental terminal mail client authored directly in WebAssembly Text
(WAT). It is an integration-driving example for the AI-Direct IR harness and
provider catalog, not a production mail client yet.

## Current Demo

The runnable starter draws a compact mock inbox using WASI stdout. It proves
the application shape and keeps all view state and behavior in WAT:

```bash
host-rs build
host-rs check
host-rs run
```

The current demo has no network, credentials, persistent storage, or real mail
server access. It must remain runnable without unimplemented providers.

## Intended Application

```text
WAT mail application
  -> ai-direct:mail-store       local SQLite-backed mailbox state
  -> ai-direct:mail-transport   IMAP/JMAP sync and SMTP submission
  -> ai-direct:tui              terminal layout, input, and rendering
  -> WASI                       declared local data/config permissions
```

The app owns mailbox navigation, compose/reply policy, search behavior, local
state transitions, and presentation. Providers own mature protocol, database,
and terminal implementation details. Adding those providers must not require a
mail-specific `host-rs` change.

## Provider Status

The contracts in `providers/` are requirements for the provider catalog, not
installed dependencies. `host.toml` intentionally does not declare them until
they exist as locally vendorable, checked artifacts.

| Need | Proposed provider | Status |
|---|---|---|
| Mailbox and local cache | `ai-direct:mail-store` | Planned; SQLite provider prerequisite |
| IMAP/JMAP synchronization | `ai-direct:mail-sync` | Planned |
| SMTP mail submission | `ai-direct:mail-submit` | Planned |
| Rich interactive terminal widgets | `ai-direct:tui` | Planned; current demo uses WASI stdout |
| Credentials | platform/provider-owned secret store | Planned; never persist plaintext secrets in this repo |

## Security Model

- Mail credentials, OAuth refresh tokens, and private messages are sensitive.
- Never commit a real account, password, token, mailbox database, or copied
  message fixture containing private mail.
- Network endpoints, TLS policy, and writable storage must be explicit provider
  configuration, not hidden host imports.
- The application should use a provider-owned OS keychain/secret integration;
  a WAT module must never receive unrestricted process environment access as a
  shortcut.

## Layout

- `mail.wat` -- application logic and the currently runnable mock inbox.
- `host.toml` -- current harness entry point; provider declarations are added
  only once their artifacts exist.
- `providers/` -- proposed WIT contracts and integration requirements.
- `docs/` -- product behavior, state model, and verification plan.

## Roadmap

1. Prove WIT/Component Model composition with a small provider.
2. Add a SQLite-backed `mail-store` provider and generic writable data mount.
3. Add mail synchronization and submission providers with explicit TLS and
   credential handling.
4. Replace the mock inbox with provider-backed account setup, sync, search,
   compose, reply, send, and offline outbox behavior.
5. Add a real TUI provider or redesign the experimental terminal boundary.

See `AGENTS.md` before changing the application.
