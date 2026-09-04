;; AI-Direct IR Mail -- root module and ordered source index.
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

  ;; @include src/state.wat
  ;; @include src/views/inbox.wat
)
