# AGENTS.md -- AI-Direct IR Mail Example

## Goal

Build a useful terminal mail client with application behavior authored in WAT.
Use mature storage, mail-protocol, TLS, and terminal implementations through
project-owned providers. Do not add mail-specific APIs to `host-rs`.

## Rules

- Never install, upgrade, or remove software without explicit user consent.
- Never commit real email, account identifiers, passwords, OAuth tokens, SMTP
  credentials, private keys, mailbox databases, or copied private fixtures.
- Change `mail.wat`, not generated `mail.wasm`; run `host-rs build` after WAT
  edits and `host-rs check` before claiming integration works.
- Keep the WAT memory map current whenever raw memory is used.
- The current harness and provider formats are experimental. Replace weak
  interfaces directly; do not add compatibility layers in builder phase.
- Add a dependency as a vendored provider with a WIT contract, provenance,
  license, hash, test, and explicit permissions. Do not make `host-rs` grow for
  SQLite, SMTP, IMAP, JMAP, TLS, or TUI features.
- Treat incoming mail as untrusted data. Never turn message content into shell
  commands, WAT, HTML execution, or unrestricted file paths.
- Verify interactive terminal work manually and retain a scripted/non-TTY path
  where feasible for CI.

## Workflow

```bash
host-rs build
host-rs check
host-rs run
host-rs dist
```

## Provider Boundary

- `mail.wat` owns navigation, view state, compose/reply behavior, and rules.
- `mail-store` owns SQLite schema, migrations, transactions, and persistence.
- `mail-sync` owns IMAP/JMAP protocol parsing, TLS, and synchronization.
- `mail-submit` owns SMTP submission and transport errors.
- `tui` owns terminal rendering/input mechanics when the provider exists.
