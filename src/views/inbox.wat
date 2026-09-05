;; Inbox rendering. It owns the mock display until real providers exist.
(func $view.inbox
  (call $print (global.get $inbox.ptr) (global.get $inbox.len)))

;; Unplaced: the root's `;; @data` region owns the address, `air` derives
;; $inbox.ptr and $inbox.len, so editing the text is the whole change.
(data $inbox
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
