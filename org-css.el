(when (locate-library "package")
  ;; If org-mode or htmlize is installed via the package system, we
  ;; need to initialize the package system since emacs batch mode does
  ;; not load it. -- cinsk
  (require 'package)
  (package-initialize))

(unless (locate-library "org")
  (message "error: cannot load org mode.")
  (kill-emacs 1))

;; older version of org-mode may require 'org-install
(require 'org)

(message "org: %s" (org-version nil 'full))

(when (locate-library "htmlize")
  (require 'htmlize)
  (if (boundp 'htmlize-version)
      (message "htmlize: %s" htmlize-version))
  (setq htmlize-convert-nonascii-to-entities nil))

;(message "%S" command-line-args-left)

(let ((outfile (car command-line-args-left)))
  (with-temp-buffer
    (org-export-htmlize-generate-css)
    (write-file outfile)))
