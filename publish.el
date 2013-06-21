
;;(add-to-list 'load-path "~/.emacs.d")
;;(load "~/.emacs.d/init.el")

(when (locate-library "package")
  ;; If org-mode or htmlize is installed via the package system, we
  ;; need to initialize the package system since emacs batch mode does
  ;; not load it. -- cinsk
  (require 'package)
  (package-initialize))

;;(require 'cc-mode)
;;(require 'ruby-mode)

(global-font-lock-mode t)
;;(add-hook 'org-mode-hook 'turn-on-font-lock)

;;(setq org-hide-leading-stars t)
;;(setq org-odd-levels-only t)
;;(setq org-agenda-include-diary t)

;;(setq org-hide-block-startup nil)
;;(setq org-startup-folded 'showeverything)

;; `org-export-htmlize-output-type' was used before org version 8.0.3
(setq org-export-htmlize-output-type 'css)
;; org 8.0.3 uses different variable name
(setq org-org-htmlized-css-url t
      org-html-htmlize-output-type 'css)

(unless (locate-library "org")
  (message "error: cannot load org mode.")
  (kill-emacs 1))

;; older version of org-mode may require 'org-install
;;(require 'org)
;;(require 'org-exp)
;;(require 'ob)
;;(require 'ob-tangle)

(message "org: %s" (org-version nil 'full))

(when (and (> emacs-major-version 22)
           (fboundp 'org-set-emph-re))
  ;; Current org-mode mark-up algorithm does not support marking
  ;; partial word. (e.g. =partial=word)
  ;;
  ;; On some languages that have postposition, which has no word
  ;; boundary with the previous noun (e.g. Korean aka josa),
  ;; marking-up partial word is essential.
  ;;
  ;; To work around current implementation, it is possible to insert
  ;; invisible unicode character such as "word joiner" character,
  ;; \u2060, between the noun and the postposition, to enable partial
  ;; word.  Thus the text will be "=partial=\u2060word", and adding
  ;; this special character to `org-emphasis-regexp-components' will
  ;; do the trick. (Use `ucs-insert' to insert the character into the
  ;; text)
  ;;
  ;; See the original idea from:
  ;;   http://thread.gmane.org/gmane.emacs.orgmode/46197/focus=46263
  (org-set-emph-re 'org-emphasis-regexp-components
                   '(" \t('\"{"
                     "- \t.,:!?;'\")}\\\u2060"
                     " \t\r\n,\"'⁠"
                     "." 1)))

;;(setcar (assoc "_" org-emphasis-alist) "@")
;;(org-set-emph-re 'org-emphasis-alist org-emphasis-alist)


(when (locate-library "htmlize")
  (require 'htmlize)
  (if (boundp 'htmlize-version)
      (message "htmlize: %s" htmlize-version))
  (setq htmlize-convert-nonascii-to-entities nil))


(setq org-publish-project-alist
      '(("org-www"
         ;; Path to your org files.
         :base-directory "org/"
         :base-extension "org"

         ;; Path to your Jekyll project.
         :publishing-directory "src/articles/"
         :link-home "../index.html"
         :link-up "../articles.html"
         :recursive t
         :publishing-function org-html-publish-to-html
         ;;:publishing-function org-publish-org-to-html
         ;;:htmlized-source t
         ;;:headline-levels 3
         :table-of-contents t
         :sub-superscript {}
         :html-extension "html"
         :body-only t ;; Only export section between <body> </body>
         )


        ("org-www-static"
         :base-directory "org/"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|php"
         :publishing-directory "src/articles/"
         :recursive t
         :publishing-function org-publish-attachment)

        ("www" :components ("org-www" "org-www-static"))

        ("posts" :components ("org-posts" "org-posts-static"))

        ("org-posts"
         ;; Path to your org files.
         :base-directory "posts/"
         :base-extension "org"

         ;; Path to your Jekyll project.
         :publishing-directory "src/_posts/"
         :link-home "../index.html"
         :link-up "../posts.html"
         :recursive t
         :publishing-function org-html-publish-to-html
         ;;:publishing-function org-publish-org-to-html
         ;;:htmlized-source t
         ;;:headline-levels 3
         :table-of-contents nil
         :sub-superscript {}
         :html-extension "html"
         :body-only t ;; Only export section between <body> </body>
         )

        ("org-posts-static"
         :base-directory "posts/"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|php"
         :publishing-directory "src/img/posts/"
         :recursive t
         :publishing-function org-publish-attachment)))


;;(org-publish "www" 'force)
(org-publish "www" nil)

(setq org-export-html-toplevel-hlevel 3)
(org-publish "posts" nil)

;(org-export-htmlize-region-for-paste (0 1))
