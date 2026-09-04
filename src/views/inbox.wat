;; Inbox rendering. It owns the mock display until real providers exist.
(func (export "_start")
  (call $print (i32.const 0x1000) (i32.const 606)))

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
