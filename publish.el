
;(add-to-list 'load-path "~/.emacs.d")
;(load "~/.emacs.d/init.el")

(when (locate-library "package")
  ;; If org-mode or htmlize is installed via the package system, we
  ;; need to initialize the package system since emacs batch mode does
  ;; not load it. -- cinsk
  (require 'package)
  (package-initialize))

(require 'cc-mode)
(require 'ruby-mode)

(global-font-lock-mode t)
(setq org-hide-block-startup nil)
(setq org-startup-folded 'showeverything)

(setq org-export-htmlize-output-type 'css)

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


(setq org-publish-project-alist
      '(("org-www"
         ;; Path to your org files.
         :base-directory "org/"
         :base-extension "org"

         ;; Path to your Jekyll project.
         :publishing-directory "src/articles/"
         :recursive t
         :publishing-function org-publish-org-to-html
         :headline-levels 4
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
        ))

(org-publish "www" 'force)

;(org-export-htmlize-region-for-paste (0 1))
