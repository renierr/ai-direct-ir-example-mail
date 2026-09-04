# Verification Plan

## Current Foundation

```bash
host-rs build
host-rs check
host-rs run
host-rs dist
```

Confirm that the mock inbox text appears and that `dist/` contains the harness,
`host.toml`, and `mail.wasm`.

## Before Real Accounts

- Provider WIT worlds validate with `wasm-tools component wit providers/`.
- Provider components pass their catalog conformance tests.
- Use a disposable local mail server/account, never a personal mailbox.
- Verify TLS certificate failures, authentication failures, network timeouts,
  malformed messages, offline transitions, and SMTP rejection behavior.
- Verify database migrations and recovery from interrupted sync/submit.
- Inspect `git status` before each commit to ensure no local data or secrets are
  included.
