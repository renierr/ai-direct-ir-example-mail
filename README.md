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
| `ai-direct-ir` | Generic platform | Improve `air` composition, validation, permissions, lifecycle, and packaging when this app exposes a reusable need. |
| `ai-direct-ir-providers` | Reusable providers | Package upstream SQLite, mail protocol, TUI, and other mature implementations as reproducible WASM/WIT providers. |
| `ai-direct-ir-example-mail` | This application | Write the mail client's product behavior and state transitions directly in WAT, then consume declared providers. |

This repository is the consumer and integration test, not the place to solve
generic runtime or library problems. It may intentionally break while sibling
projects replace an experimental interface.

## Environment

### Current Mock Application

The current component demo needs only `air` on `PATH`:

| Tool | Why it is needed |
|---|---|
| `air` | Builds, checks, runs, and packages this project. |

No Rust, Cargo, Rust WASM target, database, network service, mail account, or
provider compiler is required to run the mock inbox. `air` assembles and
validates `mail.wat` in-process; it does not optimize it. `.env` is deliberately
ignored for future local credentials or configuration; this application does
not currently read it or pass environment variables to WAT.

`air check`, `run`, and `dist` rebuild `mail.wasm` automatically when
`mail.wat` is newer or the artifact is missing. Use `air build` to force a
rebuild.

### Future Component Providers

No composition tool is involved. A component consumes another by declaring it
under `[[providers]]`; `air` instantiates the provider and forwards its exports
into the application's imports at link time, so the wiring is manifest data,
not a build step:

```toml
[[providers]]
path = "vendor/ai-direct-mail-store-0.1.0/artifacts/wasm32-wasi/mail-store.component.wasm"
```

`wasm-tools` is needed only to *author* a provider whose upstream build emits a
Core module: `wasm-tools component new` lifts that blob to a component once, and
`--adapt wasi_snapshot_preview1.reactor.wasm` covers a Preview 1 module even
with no source. The committed artifact is the lifted component, so the lifting
never happens again. `wasm-tools` also stays an optional cross-check --
`validate`, `component wit`, `component targets`.

`air` invokes no external program at any point: it assembles WAT with an
embedded parser and links and runs with Wasmtime. A distribution is `air`, the
`.wasm` files, and `host.toml`; it contains no build tool and needs none on the
machine that runs it.

`wasm-tools` is Apache-2.0 and is compatible with the sibling projects'
AGPL-3.0-or-later repository licensing when notices are retained. We do not
bundle it: it is a platform-specific build-time executable, not an application
runtime dependency. SQLite, sync, SMTP, TLS, terminal, and secret-provider
tools remain unnecessary until an approved, vendored provider requires them.

## Current Demo

The runnable starter is a WASI 0.2 component that draws a compact mock inbox
on stdout. It proves the application shape and keeps all view state and
behavior in WAT:

```bash
air build
air check
air run
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
mail-specific `air` change.

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

- `mail.wat` -- root component: the `;; @wasi` boundary, the one core module
  with shared imports/memory and the lifted `run` entry, and the ordered
  source includes.
- `src/` -- application-owned WAT fragments by state, domain, view, input, and
  provider-adapter responsibility; see `src/README.md`.
- `host.toml` -- current harness entry point; provider declarations are added
  only once their artifacts exist.
- `providers/<name>/wit/` -- proposed WIT contracts, one package per directory.
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

1. Consume a small provider through `[[providers]]` to prove the WIT contract
   shape this application will use.
2. Present SQLite implementation candidates for explicit approval, then add a
   SQLite-backed `mail-store` provider and generic writable data mount.
3. Add mail synchronization and submission providers with explicit TLS and
   credential handling.
4. Replace the mock inbox with provider-backed account setup, sync, search,
   compose, reply, send, and offline outbox behavior.
5. Add a real TUI provider or redesign the experimental terminal boundary.

See `AGENTS.md` before changing the application.
