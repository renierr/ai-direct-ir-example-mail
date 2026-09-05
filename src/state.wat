;; Application state and state-transition helpers belong here.
;; The current mock inbox has no mutable state: the root component owns the
;; stdout handle and the accumulated write status, which are boundary
;; plumbing rather than application state.
