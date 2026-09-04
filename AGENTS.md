# AGENTS.md -- AI-Direct IR Mail Example

## Goal

Build a useful terminal mail client with application behavior authored in WAT.
Use mature storage, mail-protocol, TLS, and terminal implementations through
project-owned providers. Do not add mail-specific APIs to `host-rs`.

## Repository Role

This is the application and integration driver. Keep user behavior, application
state, and product policy here. Move a reusable runtime/composition requirement
to `ai-direct-ir`; move a reusable library adapter and its WIT contract to
`ai-direct-ir-providers`; then vendor and consume the resulting provider here.
The app may break during that builder-phase work.

## Rules

- Never install, upgrade, or remove software without explicit user consent.
- **Never commit or push without an explicit request.** Finishing a unit of
  work is not a request. Leave changes in the working tree, report what
  changed, and let the user decide when it lands.
- Never commit real email, account identifiers, passwords, OAuth tokens, SMTP
  credentials, private keys, mailbox databases, or copied private fixtures.
- Change the smallest owning WAT source under `src/`, not generated
  `mail.wasm`. Keep `mail.wat` as the module boundary and ordered include list;
  read `src/README.md` and `.agents/skills/ai-direct-ir/SKILL.md` before
  restructuring.
  `host-rs check`, `run`, and `dist` rebuild changed WAT automatically.
- Keep the WAT memory map current whenever raw memory is used.
- The current harness and provider formats are experimental. Replace weak
  interfaces directly; do not add compatibility layers in builder phase.
- Add a dependency as a vendored provider with a WIT contract, provenance,
  license, hash, test, and explicit permissions. Do not make `host-rs` grow for
  SQLite, SMTP, IMAP, JMAP, TLS, or TUI features.
- This repository is an integration driver for the harness and provider catalog.
  When a generic capability is missing, improve those sibling projects with the
  mail use case and allow this example to break while the experimental design
  changes. Do not add a mail-specific harness workaround.
- Before selecting or vendoring SQLite or another consequential upstream
  implementation, present the user with candidates, licenses, WASM/component
  paths, and tradeoffs; wait for explicit approval.
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
