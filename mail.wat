;; AI-Direct IR Mail -- root component and ordered source index.
;;
;; This intentionally uses only WASI stdout until the mail-store, mail-sync,
;; mail-submit, and tui providers exist. No real mail or secrets are present.
;;
;; `;; @wasi stdout` is the whole Component Model boundary: `air` generates the
;; imports, the shared memory and the canonical ABI lowering from it, and hands
;; the application ordinary Core functions on the `wasi` instance.
;;
;; Build: air build
;; Run:   air run
;;
;; Memory map (1 page): 0x200 stream write result,
;;                      0x1000..0x8000 `;; @data` display text,
;;                      0x8000+ canonical ABI bump allocation

(component
  ;; @wasi stdout
  ;; @data 0x1000..0x8000

  ;; --- application logic, ordinary Core WAT -----------------------------
  (core module $main
    (import "env" "memory" (memory 1))
    (import "wasi" "get-stdout" (func $get_stdout (result i32)))
    (import "wasi" "write" (func $write (param i32 i32 i32 i32)))

    ;; The stdout stream is a resource handle, not a file descriptor: asking
    ;; for it once and keeping it is the difference between one handle and one
    ;; per line printed.
    (global $out (mut i32) (i32.const 0))
    ;; result<_, stream-error> lands in the 8 bytes at 0x200. A view prints
    ;; many lines and reports one status, so failures accumulate here.
    (global $err (mut i32) (i32.const 0))

    (func $print (param $ptr i32) (param $len i32)
      (call $write (global.get $out)
        (local.get $ptr) (local.get $len) (i32.const 0x200))
      (global.set $err
        (i32.or (global.get $err) (i32.load (i32.const 0x200)))))

    ;; `run: func() -> result`: ok is exit 0, err is a failed run.
    (func (export "run") (result i32)
      (global.set $out (call $get_stdout))
      (call $view.inbox)
      (global.get $err))

    ;; @include src/state.wat
    ;; @include src/views/inbox.wat
  )

  (core instance $app (instantiate $main
    (with "env" (instance $mem))
    (with "wasi" (instance $wasi))))

  (func $run (result (result)) (canon lift (core func $app "run")))
  (instance $run-i (export "run" (func $run)))
  (export "wasi:cli/run@0.2.12" (instance $run-i))
)
