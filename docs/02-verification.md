# Verification Plan

## Current Foundation

```bash
air build
air check
air run
air dist
```

`air check` must report `component instantiated, all imports satisfied`;
`air run` must draw the mock inbox and exit 0. `dist/` contains the harness,
`host.toml`, and `mail.wasm` and nothing else -- the bundle carries no build
tool, so it runs with an empty environment:

```bash
cd dist && env -i PATH=/var/empty ./air run host.toml
```

## Before Real Accounts

- Each provider WIT package validates on its own. A WIT directory is one
  package, so every contract has its own directory:

  ```bash
  for wit in providers/*/wit; do wasm-tools component wit "$wit"; done
  ```
- Provider components pass their catalog conformance tests.
- Use a disposable local mail server/account, never a personal mailbox.
- Verify TLS certificate failures, authentication failures, network timeouts,
  malformed messages, offline transitions, and SMTP rejection behavior.
- Verify database migrations and recovery from interrupted sync/submit.
- Inspect `git status` before each commit to ensure no local data or secrets are
  included.
