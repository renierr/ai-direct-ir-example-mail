# AI-Direct IR Example: Mail

An experimental terminal mail client authored directly in WebAssembly Text
(WAT). It is an integration-driving example for the AI-Direct IR harness and
provider catalog, not a production mail client yet.

It is intentionally allowed to break while it drives generic improvements in
the sibling `ai-direct-ir` harness and `ai-direct-ir-providers` catalog. A mail
requirement should produce a reusable platform/provider capability, never a
mail-specific harness API.

## Three Repositories

| Repository | What it is for | What we do there |
|---|---|---|
| `ai-direct-ir` | Generic platform | Improve `host-rs` composition, validation, permissions, lifecycle, and packaging when this app exposes a reusable need. |
| `ai-direct-ir-providers` | Reusable providers | Package upstream SQLite, mail protocol, TUI, and other mature implementations as reproducible WASM/WIT providers. |
| `ai-direct-ir-example-mail` | This application | Write the mail client's product behavior and state transitions directly in WAT, then consume declared providers. |

This repository is the consumer and integration test, not the place to solve
generic runtime or library problems. It may intentionally break while sibling
projects replace an experimental interface.

## Environment

### Current Mock Application

The current Core WAT demo needs only `host-rs` on `PATH`:

| Tool | Why it is needed |
|---|---|
| `host-rs` | Builds, checks, runs, and packages this project. |

No Rust, Cargo, Rust WASM target, database, network service, mail account, or
provider compiler is required to run the mock inbox. `host-rs` assembles and
validates `mail.wat` in-process; it does not optimize it. `.env` is deliberately
ignored for future local credentials or configuration; this application does
not currently read it or pass environment variables to WAT.

`host-rs check`, `run`, and `dist` rebuild `mail.wasm` automatically when
`mail.wat` is newer or the artifact is missing. Use `host-rs build` to force a
rebuild.

### Future Component Providers

When this project composes a WIT component root with vendored providers,
`host-rs build` will also require `wasm-tools 1.257.1` on the build machine. It
will use only `validate`, `component wit`, `component targets`, and `compose` to
validate WIT/contracts and produce one composed component. `host-rs check` and
`run` will execute that finished artifact with Wasmtime/WASI 0.2. A distributed
bundle will not contain `wasm-tools` or individual provider build toolchains.

`wasm-tools` is Apache-2.0 and is compatible with the sibling projects'
AGPL-3.0-or-later repository licensing when notices are retained. We do not
bundle it: it is a platform-specific build-time executable, not an application
runtime dependency. SQLite, sync, SMTP, TLS, terminal, and secret-provider
tools remain unnecessary until an approved, vendored provider requires them.

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

- `mail.wat` -- root module, shared imports/memory, and ordered source includes.
- `src/` -- application-owned WAT fragments by state, domain, view, input, and
  provider-adapter responsibility; see `src/README.md`.
- `host.toml` -- current harness entry point; provider declarations are added
  only once their artifacts exist.
- `providers/` -- proposed WIT contracts and integration requirements.
- `docs/` -- product behavior, state model, and verification plan.
- `.agents/skills/ai-direct-ir/SKILL.md` -- generic project-local AI workflow
  for WAT, WASM, WIT, providers, and verification.

The scaffold convention is deliberate: `docs/01-spec.md` records requested
behavior and acceptance criteria, `docs/02-architecture.md` records state,
providers, and trust boundaries, and `docs/03-verification.md` records the
commands and observable behavior that prove the work. This project predates the
generic scaffold docs but follows the same separation with its architecture and
verification documents.

## Roadmap

1. Prove WIT/Component Model composition with a small provider.
2. Present SQLite implementation candidates for explicit approval, then add a
   SQLite-backed `mail-store` provider and generic writable data mount.
3. Add mail synchronization and submission providers with explicit TLS and
   credential handling.
4. Replace the mock inbox with provider-backed account setup, sync, search,
   compose, reply, send, and offline outbox behavior.
5. Add a real TUI provider or redesign the experimental terminal boundary.

See `AGENTS.md` before changing the application.
