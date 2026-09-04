;; AI-Direct IR Mail -- runnable mock inbox foundation.
;;
;; This intentionally uses only WASI stdout until the mail-store, mail-sync,
;; mail-submit, and tui providers exist. No real mail or secrets are present.
;; Memory: 0x00..0x0b iovec/write result; 0x1000+ immutable display text.
(module
  (import "wasi_snapshot_preview1" "fd_write"
    (func $fd_write (param i32 i32 i32 i32) (result i32)))
  (memory 1)
  (export "memory" (memory 0))

  (func $print (param $ptr i32) (param $len i32)
    (i32.store (i32.const 0) (local.get $ptr))
    (i32.store (i32.const 4) (local.get $len))
    (drop (call $fd_write (i32.const 1) (i32.const 0)
      (i32.const 1) (i32.const 8))))

  (func (export "_start")
    (call $print (i32.const 0x1000) (i32.const 373)))

  (data (i32.const 0x1000)
    "\n"
    "  AI-Direct Mail                                      mock/offline\n"
    "  ----------------------------------------------------------------\n"
    "  Inbox (3)                                      [r] refresh  [q] quit\n"
    "\n"
    "  > Ada Lovelace        Component provider proposal             09:41\n"
    "    Linh Tran           Weekend plans                            Yesterday\n"
    "    Build system        Mail client foundation created          Mon\n"
    "\n"
    "  This is a WASI-only mock inbox. Real SQLite, sync, SMTP, and\n"
    "  interactive TUI support will arrive as project-owned providers.\n"
    "  See providers/ and docs/ for the intended contracts.\n\n")
)
